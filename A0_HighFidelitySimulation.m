%=========================================================================%
%==================== High Fidelity Machine Simulation.m =================%
%================== Hyeon-Jun Lee, Korea University, 2021 ================%
%==============================IPMSM.github.io============================%
%=========================================================================%

%=======================Machine and simulation setting Info.==============% 
% Motor Under Test : Toyota Prius HEV (2010, FEA model from ORNL. US DoE)
% Pole / Slot : ( 8P48S )
% Ratings : 60kW, 207Nm, max 13,500rev/min IPMSM
% FEA : 1/4 Model, Ansys Maxwell 2D Version 17.
% Sweeping conditions 
%  1) Current : Id, Iq -300 to 300 21step 
%  2) Angle : 0 to 360deg 361step. 
%=========================================================================%
%% Initialize Parameter
% ========================= Do not Edit here ============================%
clear all
clc;
Vdc=650;        % dc-link voltage
run('B1_IPMSM_Machine_Parameter_Init.m');
run('C1_INV1_GainSetting.m');
run('D1_LoadMachine_Parameter_Init.m');
run('D2_INV2_GainSetting.m');
TestMachine_TorqueControl = 1;
TestMachine_SpeedControl = 2;
PMSM_Torque = 1;
PMSM_Speed = 2;
DC_Speed = 1;
DC_Torque = 0;
% ========================= Do not Edit here ============================%

%% Operating Mode Setting %%
TestMode = TestMachine_TorqueControl; % (1) TestMachine_SpeedControl (2)TestMachine_TorqueContorl

% ------- Do not edit here ----------------- %
if (TestMode  == TestMachine_TorqueControl)
    INV1.DriveMode = PMSM_Torque;
    INV2.DriveMode = DC_Speed; % DC_Torque, DC_Speed
elseif (TestMode == TestMachine_SpeedControl)  
    INV1.DriveMode = PMSM_Speed;
    INV2.DriveMode = DC_Torque; % DC_Torque, DC_Speed
end
% ------------------------------------------ %

%% Simulation Scenario

%------Command timing------%
Step_Time=[0 1 2 3 4 5];
Stop_Time=6;

%------Torque Control Mode------%
Te_Ref_Set=[0.0001 0.00001 0.2 0.3 0.4 0.5]*Motor1.Te_Rated;
Te_SlewRate=inf;

Wrm_Init=0*2*pi/60;
Wrm_Fin=8000*2*pi/60%16900*2*pi/60;

%------Speed Control Mode------%
Wrpm_Ref_Set=[5000 5000 5000 5000 5000];


%% Simulation Setting
Simstep = INV1.Tsw/50;
%% Command setting

Thetarm_Init=0*pi*1/Motor1.p;

