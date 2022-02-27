%========================= 전류 > 자속맵 to 자속 > 전류맵 변환===========%
for i = 1 : Angle_step 
      Fluxd_Theta_temp(:,:) = squeeze(FluxD_Id_Iq_Theta(i,:,1:(1+I_step)/2));
      Fluxq_Theta_temp(:,:) = squeeze(FluxQ_Id_Iq_Theta(i,:,1:(1+I_step)/2));
    %== Determine the minimum and maximum flux values. ==%

    % Create the table for the d-axis current
    id_fit = gridfit(Fluxd_Theta_temp,Fluxq_Theta_temp,id_m,ParamFluxDIndex,ParamFluxQIndex);
    ParamIdLookupTable = id_fit'; 
    % Create the table for the q-axis current
    iq_fit = gridfit(Fluxd_Theta_temp,Fluxq_Theta_temp,iq_m,ParamFluxDIndex,ParamFluxQIndex);
    ParamIqLookupTable = iq_fit'; 
    
    %== figure flux map. ==%
    figure(3);
    s= surf(ParamFluxDIndex,ParamFluxQIndex,ParamIdLookupTable','FaceAlpha','1');
    xlabel('\lambda_d [v.s]');ylabel('\lambda_q [v.s]');zlabel('id [A]');title('id Table'); grid on;
    colorbar
    s.FaceColor = 'flat';
    colormap jet
    view(3)
    
    figure(4); 
    s= surf(ParamFluxDIndex,ParamFluxQIndex,ParamIqLookupTable','FaceAlpha','1');
    xlabel('\lambda_d [v.s]');ylabel('\lambda_q [v.s]');zlabel('iq [A]'); title('iq Table'); grid on;
    colorbar
    s.FaceColor = 'flat';
    colormap jet
    view(3)
    
    % Set the table data
    idmap(i,:,:) =ParamIdLookupTable;
    iqmap(i,:,:) =ParamIqLookupTable;   
end