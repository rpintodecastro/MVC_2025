function [SCORES,resultData] = scoreComputation(resultData,BAT,SM,MOT,CTRLpmsm,Ts)
    %% Scoring computation


    % Get the weighting factors coefficients
    Weighting_Factors;
%     % check if the variable th exists, create it if not
%     if ~exist('th', 'var')
%         th = 0;
%     else
%         % In case it exists, check if it is within the limits
%         if(th<0)
%             th = 0;
%         elseif(th>1)
%             th = 1;
%         end
%     end
%     SCORES.th       = th;

    % Convert elapsed time to hours, minutes, and seconds
    SCORES.minutes = floor(mod(resultData.elapsedTime, 3600) / 60);
    SCORES.seconds = mod(resultData.elapsedTime, 60);

    % Constraint verification
    SCORES.constraintSoC = resultData.SoC_BP.data(end)>1 | resultData.SoC_BP.data(end)<=0;
    SCORES.constraintSoE = resultData.SoE_SM.data(end)>1 | resultData.SoE_SM.data(end)<=0;

    % BP usage
    s = tf('s');
    F = 1/(1+s/(2*pi*100));
    Fd = c2d(F,Ts,'tustin');
    if_BP = lsim(Fd,resultData.i_BP.Data,resultData.i_BP.Time);
    di_BP = timeseries(gradient(if_BP,Ts),resultData.i_BP.Time);
%     SCORES.phi_BP = sqrt(sum(di_BP.Data.^2)*Ts/di_BP.Time(end));
    SCORES.phi_BP = sqrt(sum((di_BP.Data/SCORES.didt_nom).^2)*Ts/di_BP.Time(end));



    % Energy consumption
    resultData.P_BP = timeseries(resultData.v_BP.Data.*resultData.i_BP.Data,resultData.v_BP.Time);
    E_BP = sum(resultData.P_BP.Data)*Ts;
    v_SM_fin = resultData.v_SM.Data(end);
    E_SM_fin = (2\(SM.C + SM.ci_1 + SM.ci_2)*v_SM_fin^2 + 3\SM.k*v_SM_fin^3);
    resultData.P_SM = timeseries(resultData.v_SM.Data.*resultData.i_SM.Data,resultData.v_SM.Time);
    E_SM = E_SM_fin - SM.SoE_0*SM.E_nom;
    SCORES.phi_E = E_BP + E_SM;


    % DTP-PMSM loading
    resultData.P_ABC = resultData.vDC_ABC.*resultData.iDC_ABC;
    resultData.P_DEF = resultData.vDC_DEF.*resultData.iDC_DEF;
    arg_ABC = max(resultData.P_ABC.Data.^2 - (SCORES.gamma*MOT.Pnom)^2, 0);
    arg_DEF = max(resultData.P_DEF.Data.^2 - (SCORES.gamma*MOT.Pnom)^2, 0);
    SCORES.phi_SPM = sum(arg_ABC+arg_DEF)*Ts/resultData.P_ABC.Time(end);
    


    % DTP_PMSM winding exploitation
    tau_e_ref = abs(resultData.Te_ref.Data)/MOT.Tenom;
   
    arg_ABC = sum(resultData.iABC.Data.*resultData.iABC.Data,2)<=SCORES.th;
    arg_DEF = sum(resultData.iDEF.Data.*resultData.iDEF.Data,2)<=SCORES.th;
    SCORES.phi_w = sum((arg_ABC + arg_DEF).*tau_e_ref)*Ts/resultData.iABC.Time(end);


    % Final score
    SCORES.Final_Score =    SCORES.k_bp*SCORES.phi_BP + ...
                            SCORES.k_e*SCORES.phi_E + ...
                            SCORES.k_spm*SCORES.phi_SPM + ...
                            SCORES.k_w*SCORES.phi_w;
end