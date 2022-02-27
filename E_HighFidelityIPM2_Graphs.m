%% Flux_map 3D Mesh Plot
% ==== Fluxmap Fluctuation image extraction part ====%
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