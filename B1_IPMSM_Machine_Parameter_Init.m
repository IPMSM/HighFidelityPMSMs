% ==================================================%
% ========== High Fidelity Machine Modeling ========%
% ==================================================%

%% Step1. Load the FEA Datas
fid=fopen('Fluxdq0_Toyota_Prius.txt','rt');      % Open the file for reading
datos=fscanf(fid,'%f %f %f %f %f',[5 inf]);  %Save 5 columns as float data
step = datos(1,:);
Flux_d = datos(2,:);
Flux_q = datos(3,:);
Flux_0 = datos(4,:);    
Torque_e = datos(5,:);

%% Step2. Sweeping Parameters setting
I_min = -300;   %[A]
I_max = 300;    %[A]
I_step = 21; %21
Angle_max = 360; %[mech_deg]%30 for Itemp20
Angle_step = 361; %91
Id_idx = linspace(I_min,I_max,I_step);
Iq_idx = linspace(I_min,I_max,I_step);
Angle_idx = linspace(0,Angle_max,Angle_step);
Angle_idx_LUT = linspace(-180,180,Angle_step);
Angle_idx_initial = (length(Angle_idx)+1)/2

%% Step3. Flux_data_shaping
FluxD_Id_Iq_Theta = reshape(Flux_d,Angle_step,I_step,I_step);
FluxQ_Id_Iq_Theta = reshape(Flux_q,Angle_step,I_step,I_step);
Flux0_Id_Iq_Theta = reshape(Flux_0,Angle_step,I_step,I_step);
Torque_Id_Iq_Theta = reshape(Torque_e,Angle_step,I_step,I_step);

%% Setting for Step.4
% Set the spacing for the table rows and columns
flux_d_size = 70;
flux_q_size = 70;
% Create 2-D grid coordinates based on the d-axis and q-axis currents 
[id_m,iq_m] = meshgrid(Id_idx(1:(1+I_step)/2),Iq_idx);
Flux_d_max = max(max(max(FluxD_Id_Iq_Theta(:,:,:))));
Flux_d_min = min(min(min(FluxD_Id_Iq_Theta(:,:,:))));
Flux_q_max = max(max(max(FluxQ_Id_Iq_Theta(:,:,:))));
Flux_q_min = min(min(min(FluxQ_Id_Iq_Theta(:,:,:))));
ParamFluxDIndex = linspace(Flux_d_min,Flux_d_max,flux_d_size);
ParamFluxQIndex = linspace(Flux_q_min,Flux_q_max,flux_q_size);
flux_d_idx=ParamFluxDIndex;
flux_q_idx=ParamFluxQIndex;

%% Step5. Fd/q = f/g(id,iq), to Id/q = v/w(Fd,Fq), map inversion
load('Fluxmap.mat');
% run('A2_IPMSM_LUT_Inversion.m'); 
% U don't have to run this line every time.
% (It's time consuming proceess) output file is fluxmap.mat.

%% Step6. Open Inductance map
fid=fopen('Inductancemap_Toyota_Prius.txt','rt');      % Open the file for reading %demo2 
datos=fscanf(fid,'%f %f %f %f %f',[5 inf]);  %Save 5 columns as float data
step = datos(1,:);
L_d = datos(2,:);
L_q = datos(3,:);
Lds_map = reshape(L_d,I_step,I_step)            % static inductance map as a function of Id and Iq
Lqs_map = reshape(L_q,I_step,I_step)            % static inductance mpa as a fucntion of Id and Iq
Lds_normal = Lds_map((I_step+1)/2,(I_step+1)/2) % zero current value
Lqs_normal = Lqs_map((I_step+1)/2,(I_step+1)/2) % zero current value

%% Test Machine (Motor1) Mechanical Parameter %%
Motor1.P= 8;                            % Pole Number (P)
Motor1.p= Motor1.P/2;                          % Pole pairs (pp)
Motor1.flux_d_init = 0;
Motor1.Rs = 0.1;        

Motor1.Lamf=(FluxD_Id_Iq_Theta(1,(1+I_step)/2,(1+I_step)/2));    % PM Flux density (Vm)
Motor1.Lds=Lds_normal;                                           % D-axis inductance (zero-current)
Motor1.Lqs=Lqs_normal;                                           % Q-axis inductance (zero-current)   

Motor1.Jm=0.054;                        % Rotor Inertial
Motor1.Bm=0.001;                        % Mechanical friciton
Motor1.Wrm_Init = 0;                    % Initial Speeds
Motor1.Thetarm_Init = 0;                % Initial Rotor positions

%% Test Machine Ratings
Motor1.Is_Rated=300;      % Peak Value
Motor1.Te_Rated = 206;    % Peak Torque