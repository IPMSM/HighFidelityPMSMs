%% MTPA map
load('MTPA_table.mat');

TrqWrId = ATICALParameterList.Table3D(1).XAxis
TrqTId = ATICALParameterList.Table3D(1).YAxis
TrqWrIq = ATICALParameterList.Table3D(2).XAxis
TrqTIq = ATICALParameterList.Table3D(2).YAxis
TrqIdmap = ATICALParameterList.Table3D(1).ZAxis;
TrqIqmap= ATICALParameterList.Table3D(2).ZAxis;

%% System parameters

INV1.fsw=20e3;       % Switching frequency
INV1.Tsw=1/INV1.fsw;      % Switching period
INV1.fs=2*INV1.fsw;       % Samping frequency (double sampling)
INV1.Ts=1/INV1.fs;        % Samping period

%% Estimated parameters
INV1.Lamf_Hat=1.0*Motor1.Lamf;
INV1.Rs_Hat=1.0*Motor1.Rs;
INV1.Lds_Hat=1.0*Motor1.Lds;
INV1.Lqs_Hat=1.0*Motor1.Lqs;
INV1.Jm_Hat=1.0*Motor1.Jm;
INV1.Bm_Hat=1.0*Motor1.Bm;

%% Controller setting
% Speed Controller 
INV1.SC.Wc=20*2*pi;              % Speed controller BW
INV1.SC.Zeta=0.707;
INV1.SC.Te_lim=1.0*Motor1.Te_Rated;     % Torque limit for Speed controller

% Current Controller
INV1.CC.Wc=1000*2*pi;             % Current controller BW
INV1.CC.Is_lim=Motor1.Is_Rated;         % Current constraint
INV1.CC.Ra=10*INV1.Rs_Hat;            % Active damping

INV1.FW.Vs_lim=0.55*Vdc;         % Voltage limit for FW controller

%% Speed controller gain setting

INV1.SC.Kp=INV1.Jm_Hat*INV1.SC.Wc;
INV1.SC.Ki=INV1.SC.Kp*INV1.SC.Wc/5;
INV1.SC.Ka=2/INV1.SC.Kp;

%% Current controller gain setting

INV1.CC.Kp_Mat=INV1.CC.Wc*[INV1.Lds_Hat 0;0 INV1.Lqs_Hat];
INV1.CC.Ki_Mat=INV1.CC.Wc*(INV1.Rs_Hat+INV1.CC.Ra)*eye(2);
INV1.CC.Ka_Mat=inv(INV1.CC.Kp_Mat);

%% FW Gain

FW.Kp=0.002;
FW.Ki=50;
FW.Ka=200;