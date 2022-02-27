%% Flux_map 3D Mesh Plot
clf
figure(2)
subplot(2,2,1)
%s = surf(Id_idx,Iq_idx,squeeze(FluxD_Id_Iq_Theta(1,:,:)),'FaceAlpha','1');
contourf(Id_idx,Iq_idx,squeeze(FluxD_Id_Iq_Theta(1,:,:)),'ShowText','on')
colorbar
%s.FaceColor = 'flat';
xlabel('I_{ds}^r[A]');
ylabel('I_{qs}^r[A]');
zlabel('{\lambda}_{ds}^{r}[VA]');
title('{\lambda}_{ds}^{r},  Magnet Tempeature 20^{\circ}C');
colormap jet	

view(2)

subplot(2,2,2)
%s = surf(Id_idx,Iq_idx,squeeze(FluxQ_Id_Iq_Theta(1,:,:)),'FaceAlpha','1');
contourf(Id_idx,Iq_idx,squeeze(FluxQ_Id_Iq_Theta(1,:,:)),'ShowText','on')
colorbar
%s.FaceColor = 'flat';
xlabel('I_{ds}^r[A]');
ylabel('I_{qs}^r[A]');
zlabel('{\lambda}_{qs}^{r}[VA]');
title('{\lambda}_{qs}^{r},  Magnet Tempeature 20^{\circ}C');
%colormap jet
view(2)

subplot(2,2,3)
%s = surf(Id_idx,Iq_idx,squeeze(Flux0_Id_Iq_Theta(1,:,:)),'FaceAlpha','1');
contourf(Id_idx,Iq_idx,squeeze(Flux0_Id_Iq_Theta(1,:,:)),'ShowText','on')
colorbar
%s.FaceColor = 'flat';
xlabel('I_{ds}^r[A]');
ylabel('I_{qs}^r[A]');
zlabel('{\lambda}_{0}^{r}[VA]');
title('{\lambda}_{0}^{r},  Magnet Tempeature 20^{\circ}C');
%colormap jet
%grid on
view(2)

subplot(2,2,4)
%s = surf(Id_idx,-Iq_idx,squeeze(Torque_Id_Iq_Theta(1,:,:)),'FaceAlpha','1');
contourf(Id_idx,-Iq_idx,squeeze(Torque_Id_Iq_Theta(1,:,:)),'ShowText','on')
colorbar
%s.FaceColor = 'flat';
xlabel('I_{ds}^r[A]');
ylabel('I_{qs}^r[A]');
zlabel('{Torque}[Nm]');
title('{Torque}[Nm], Magnet Tempeature 20^{\circ}C');
%colormap jet
view(2)