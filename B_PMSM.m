%% Initialization

%clc
%clear
%close all
format short eng
%% Simulation mode

Mode.Ctrl=1 ;        % Control mode
% 1: Torque control, 2: Speed control
Mode.PWM=1;         % PWM method
% 1: SCPWM, 2: 60deg DPWM, 3: 120deg(on) DPWM, 4: 120deg(off) DPWM
Mode.CC_Type=2;     % Current controller type
% 1: State feedback, 2: Complex vector
Mode.SC_Type=2;     % Speed controller type
% 1: PI controller, 2: IP controller
Mode.AntiWindup=1;  % Antiwindup
% 0: Off, 1: On
Mode.FW=0;  % Flux-weakening control
%  MTPA map이 약자속맵을 포함하므로 별도 약자속 알고리즘 불필요 %
% 0: Off, 1: On
%% Machine parameters
p=4;                        % # of pole pairs
Lamf=(FluxD_Id_Iq_Theta(1,(1+I_step)/2,(1+I_step)/2));
Lds=Lds_normal;
Lqs=Lqs_normal;
Rs=0.09;
Is_Rated=300;%sqrt(2)      % Peak Value
Jm=0.054;
Bm=.001;
%% System parameters
Vdc=650;        % dc-link voltage
fsw=20e3;       % Switching frequency
Tsw=1/fsw;      % Switching period
fs=2*fsw;       % Samping frequency (double sampling)
Ts=1/fs;        % Samping period
Simstep = Tsw/50;
%% Estimated parameters
Lamf_Hat=1.0*Lamf;
Rs_Hat=1.0*Rs;
Lds_Hat=1.0*Lds;
Lqs_Hat=1.0*Lqs;
Jm_Hat=1.0*Jm;
Bm_Hat=1.0*Bm;
%% MTPA trajectory calculation

MTPA.Is=linspace(-Is_Rated,Is_Rated,1001);
if Lds_Hat~=Lqs_Hat
    MTPA.Idsr=(Lamf_Hat-sqrt(8*(Lds_Hat-Lqs_Hat)^2*MTPA.Is.^2+Lamf_Hat^2))/(-8*(Lds_Hat-Lqs_Hat));
    MTPA.Iqsr=sign(MTPA.Is).*sqrt(MTPA.Is.^2-MTPA.Idsr.^2);
else
    MTPA.Idsr=-500*eps:eps:500*eps;
    MTPA.Iqsr=MTPA.Is;
end
MTPA.Te=3/2*p*(Lamf*MTPA.Iqsr+(Lds-Lqs)*MTPA.Idsr.*MTPA.Iqsr);

Ind_PosTe = find(MTPA.Te>=0);
Te_Rated = 200;%1*interp1(MTPA.Is(Ind_PosTe),MTPA.Te(Ind_PosTe),Is_Rated)
%% Controller setting

SC.Wc=20*2*pi;              % Speed controller BW
SC.Zeta=0.707;
SC.Te_lim=1.0*Te_Rated;     % Torque limit for Speed controller

CC.Wc=1000*2*pi;             % Current controller BW
CC.Is_lim=Is_Rated;         % Current constraint
CC.Ra=10*Rs_Hat;            % Active damping

FW.Vs_lim=0.55*Vdc;         % Voltage limit for FW controller

run('C_GainCal');	% Calculation of controller gains

%% Command setting

Thetarm_Init=0*pi*1/p;

%------Command timing------%

Step_Time=[0.25 0.5 0.75 1];
Stop_Time=1;

%------Torque Control Mode------%

Te_Ref_Set=ones(1,5)*Te_Rated*1;
Te_SlewRate=inf;
Wrm_Init=0*2*pi/60;
Wrm_Fin=8000*2*pi/60%16900*2*pi/60;

%------Speed Control Mode------%

Wrpm_Ref_Set=[0 2000 3000 4000 5000];

% Load torque disturbance
TL=[0 0 0 0 0]
%*Te_Rated;

if Mode.Ctrl==1    
    Wrpm_Ref_Set=Wrm_Init*ones(1,5);
    TL=zeros(1,5);
else  
    Wrm_Init=Wrpm_Ref_Set(1)*2*pi/60;
end

%% Run Simulink

sim('HighFiedelity_Simulation.slx')

