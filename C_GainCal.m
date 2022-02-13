%% Speed controller gain setting

% SC.Kp=2*SC.Zeta*Jm_Hat*SC.Wc;
% SC.Ki=Jm_Hat*SC.Wc^2;
% SC.Ka=2/SC.Kp;

SC.Kp=Jm_Hat*SC.Wc;
SC.Ki=SC.Kp*SC.Wc/5;
SC.Ka=2/SC.Kp;

%% Current controller gain setting

CC.Kp_Mat=CC.Wc*[Lds_Hat 0;0 Lqs_Hat];
CC.Ki_Mat=CC.Wc*(Rs_Hat+CC.Ra)*eye(2);
CC.Ka_Mat=inv(CC.Kp_Mat);

%% FW Gain

FW.Kp=0.002;
FW.Ki=50;
FW.Ka=200;

