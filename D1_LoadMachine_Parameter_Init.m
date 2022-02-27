%% Load Machine Parameters (DC Machine)
% Ratings
DCMotor.Power=300e3;               % Power[W]
DCMotor.Va_rated=550;             % Rated Voltage [V]
DCMotor.Ia_rated=500;              % Rated Current [A]
DCMotor.Wm_rated=15000*2*pi/60;    % Rated Angular Velocity[rad/s]
DCMotor.Te_rated=DCMotor.Power/DCMotor.Wm_rated;  % Rated Torque [Nm]

% Electrical Parameters
DCMotor.Ra=0.26;                  % Resistance [Ohm]
DCMotor.La=1.7e-3;                % Inductance [H]

% Mechanical Parameters
DCMotor.J=.01252;                 % Moment of inertia [kg-m^2]
DCMotor.B=.0;                     % Coefficient of viscous friction [kgm^2/sec]  

% Electrical Constants
DCMotor.Kt=DCMotor.Te_rated/DCMotor.Ia_rated;     % Torque constant [Nm/Wb/A]
DCMotor.K=DCMotor.Kt;      
