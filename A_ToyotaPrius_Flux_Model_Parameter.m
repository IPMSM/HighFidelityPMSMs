%=========================================================================%
%==================== High Fidelity Machine Simulation.m =================%
%================== Hyeon-Jun Lee, Korea University, 2021 ================%
%=========================================================================%
%=======================Machine and simulation setting Info.==============% 
% Pole / Slot : ( 8P48S )
% Ratings : 30kW, 350Nm, max 17,900rev/min IPMSM
% FEA : 1/4 Model.
% Sweeping conditions 
%  1) Current : Id, Iq -300 to 300 21step 
%  2) Angle : 0 to 30deg 61step. 
% For 8 Pole Machine, Mechanical 30Degree = Electrical 360Degree
%% Initialize
clear all
clc;
%% Step1. Load the FEA Datas
fid=fopen('Fluxdq0_Toyota_Prius.txt','rt');      % Open the file for reading %demo2 
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
%%
%====== Machine Parameter ======%
Rs = 0.1;
P= 8;
Jm=0.054;
TL = 250;
Bm=0.0;
Wrm_Init = 0;
Thetarm_Init = 0;
flux_d_init = 0;
%% Step3. Flux_data_shaping
FluxD_Id_Iq_Theta = reshape(Flux_d,Angle_step,I_step,I_step);
FluxQ_Id_Iq_Theta = reshape(Flux_q,Angle_step,I_step,I_step);
Flux0_Id_Iq_Theta = reshape(Flux_0,Angle_step,I_step,I_step);
Torque_Id_Iq_Theta = reshape(Torque_e,Angle_step,I_step,I_step);

%% Flux_map 3D Mesh Plot
% ==== 자속맵 등고선 라인의 각도에 따른 Fluctuation 이미지 저장 코드 ====%
% for i = 1 : 1% Angle_step  
%     figure(2)
%     str = "{\theta}_{r} = " +i+ "[deg]"
%     sgtitle(str)
%     subplot(1,3,1)
%     %s = surf(Id_idx,Iq_idx,squeeze(FluxD_Id_Iq_Theta(1,:,:)),'FaceAlpha','1');
%     contourf(Id_idx,Iq_idx,squeeze(FluxD_Id_Iq_Theta(i,:,:)),8,'ShowText','on')
%     caxis([-0.3 0.3])
%     colorbar
%     s.FaceColor = 'flat';
%     xlabel('I_{ds}^r[A]');
%     ylabel('I_{qs}^r[A]');
%     zlabel('{\lambda}_{ds}^{r}[VA]');
%     title('{\lambda}_{ds}^{r}[Wb],  Magnet Tempeature 20^{\circ}C');
%     view(2)
%     colormap default
%     subplot(1,3,2)
%     %s = surf(Id_idx,Iq_idx,squeeze(FluxQ_Id_Iq_Theta(1,:,:)),'FaceAlpha','1');
%     contourf(Id_idx,Iq_idx,squeeze(FluxQ_Id_Iq_Theta(i,:,:)),8,'ShowText','on')
%     caxis([-0.3 0.3])
%     colorbar
%     s.FaceColor = 'flat';
%     xlabel('I_{ds}^r[A]');
%     ylabel('I_{qs}^r[A]');
%     zlabel('{\lambda}_{qs}^{r}[VA]');
%     title('{\lambda}_{qs}^{r}[Wb],  Magnet Tempeature 20^{\circ}C');
%     view(2)
% 
%     subplot(1,3,3)
%     %s = surf(Id_idx,-Iq_idx,squeeze(Torque_Id_Iq_Theta(1,:,:)),'FaceAlpha','1');
%     contourf(Id_idx,-Iq_idx,squeeze(Torque_Id_Iq_Theta(i,:,:)),10,'ShowText','on')
%     caxis([-400 400])
%     colorbar
%     s.FaceColor = 'flat';
%     xlabel('I_{ds}^r[A]');
%     ylabel('I_{qs}^r[A]');
%     zlabel('{Torque}[Nm]');
%     title('{Torque}[Nm], Magnet Tempeature 20^{\circ}C');
%     view(2)
%     saveas(gcf,i+"deg.png")
% end
%% Step4. 
%Plot the sweeping current points used to collect the data
for i = 1:length(Id_idx)
for j = 1:1:length(Iq_idx )
plot(Id_idx(i),Iq_idx(j),'b*');
hold on
end
end
% Plot the current limit circle
for angle_theta = pi/2:(pi/2/200):(3*pi/2)
plot(300*cos(angle_theta),300*sin(angle_theta),'r.');
hold on
end
xlabel('I_d [A]')
ylabel('I_q [A]')
title('Sweeping Points'); grid on;
xlim([-300,300]);
ylim([-300,300]);
hold off

%% Setting for Step.5
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
% ========================= 전류 > 자속맵 to 자속 > 전류맵 변환===========%
% for i = 1 : Angle_step 
%       Fluxd_Theta_temp(:,:) = squeeze(FluxD_Id_Iq_Theta(i,:,1:(1+I_step)/2));
%       Fluxq_Theta_temp(:,:) = squeeze(FluxQ_Id_Iq_Theta(i,:,1:(1+I_step)/2));
%     %== Determine the minimum and maximum flux values. ==%
% 
%     % Create the table for the d-axis current
%     id_fit = gridfit(Fluxd_Theta_temp,Fluxq_Theta_temp,id_m,ParamFluxDIndex,ParamFluxQIndex);
%     ParamIdLookupTable = id_fit'; 
%     % Create the table for the q-axis current
%     iq_fit = gridfit(Fluxd_Theta_temp,Fluxq_Theta_temp,iq_m,ParamFluxDIndex,ParamFluxQIndex);
%     ParamIqLookupTable = iq_fit'; 
%     
%     %== figure flux map. ==%
%     figure(3);
%     s= surf(ParamFluxDIndex,ParamFluxQIndex,ParamIdLookupTable','FaceAlpha','1');
%     xlabel('\lambda_d [v.s]');ylabel('\lambda_q [v.s]');zlabel('id [A]');title('id Table'); grid on;
%     colorbar
%     s.FaceColor = 'flat';
%     colormap jet
%     view(3)
%     
%     figure(4); 
%     s= surf(ParamFluxDIndex,ParamFluxQIndex,ParamIqLookupTable','FaceAlpha','1');
%     xlabel('\lambda_d [v.s]');ylabel('\lambda_q [v.s]');zlabel('iq [A]'); title('iq Table'); grid on;
%     colorbar
%     s.FaceColor = 'flat';
%     colormap jet
%     view(3)
%     
%     % Set the table data
%     idmap(i,:,:) =ParamIdLookupTable;
%     iqmap(i,:,:) =ParamIqLookupTable;   
% end
%%
% call inductance
fid=fopen('Inductancemap_Toyota_Prius.txt','rt');      % Open the file for reading %demo2 
datos=fscanf(fid,'%f %f %f %f %f',[5 inf]);  %Save 5 columns as float data
step = datos(1,:);
L_d = datos(2,:);
L_q = datos(3,:);
Lds_map = reshape(L_d,I_step,I_step)
Lqs_map = reshape(L_q,I_step,I_step)
Lds_normal = Lds_map((I_step+1)/2,(I_step+1)/2)
Lqs_normal = Lqs_map((I_step+1)/2,(I_step+1)/2)
%%
load('MTPA_table.mat');

TrqWrId = ATICALParameterList.Table3D(1).XAxis
TrqTId = ATICALParameterList.Table3D(1).YAxis
TrqWrIq = ATICALParameterList.Table3D(2).XAxis
TrqTIq = ATICALParameterList.Table3D(2).YAxis
TrqIdmap = ATICALParameterList.Table3D(1).ZAxis;
TrqIqmap= ATICALParameterList.Table3D(2).ZAxis;
run('B_PMSM');
