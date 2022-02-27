INV2.SwitchingFrequency = 10e3;    % Switching frequency [Hz]


%-- Current Controller Gains ------------------------------------------
DCMotor.Wcc = 2*pi*500;             % current controller bandwidth [rad/s]
DCMotor.Kpc = DCMotor.La*DCMotor.Wcc;               % P gain
DCMotor.Kic = DCMotor.Ra*DCMotor.Wcc;               % I gain
DCMotor.Kac = 1/DCMotor.Kpc;                % Anti-windup gain

%--- Speed Controller Gains -------------------------------------------
DCMotor.Wsc=2*pi*50;              % speed controller bandwidth [rad/s]
DCMotor.Ksp=DCMotor.J*DCMotor.Wsc;                % P gain
DCMotor.Ksi=DCMotor.Ksp*DCMotor.Wsc/5;            % I gain
DCMotor.Ksa=1/DCMotor.Ksp;                % Anti-windup gain
DCMotor.Te_limit=DCMotor.Te_rated;
DCMotor.Ia_limit=DCMotor.Ia_rated;