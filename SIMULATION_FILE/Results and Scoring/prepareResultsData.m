function [resultData,SCORES] = prepareResultsData(out,BAT,SM,BUS,MOT,TUG,elapsedTime)

    % Load Results: the data are in per unit (p.u.) and are thus multiplied by
    % the normalisation factor to get quantities in natural quantities.
    % The "to file" Simulink block does not allow to save data in a file name by reading from the workspace. Therefore, the data are loaded in the workspace and then moved to the "tempSimResults" folder.

    % The list of measurement that are going to be used are:
    %measList    = {'P_ABC', 'P_DEF', 'P_BP', 'P_SM', 'i_BP', 'v_BP', 'i_SM', 'v_SM', 'SoC_BP', 'SoE_SM', 'iDC_ABC', 'vDC_ABC', 'iDC_DEF', 'vDC_DEF', 'Te_ref', 'iABC', 'iDEF', 'Pe', 'DTe_star', 'wm_star', 'V_star', 'V', 'Ft', 'Fr', 'Te', 'Tp'};

    resultData.i_BP     = out.iBP * BAT.I_nom;
    resultData.v_BP     = out.vBP * BAT.V_nom;
    resultData.i_SM     = out.iSM * SM.I_nom;
    resultData.v_SM     = out.vSM * SM.V_nom;
    resultData.SoC_BP   = out.SoC_BP;
    resultData.SoE_SM   = out.SoE_SM;
    resultData.iDC_ABC  = out.iDC_ABC * BUS.Idc_nom;
    resultData.vDC_ABC  = out.vDC_ABC * BUS.Vdc;
    resultData.iDC_DEF  = out.iDC_DEF * BUS.Idc_nom;
    resultData.vDC_DEF  = out.vDC_DEF * BUS.Vdc;
    resultData.Te_ref   = out.Te_star * MOT.Tenom;
    resultData.iABC     = out.iABC * MOT.Inom;
    resultData.iDEF     = out.iDEF * MOT.Inom;
    resultData.Pe       = out.Pe * MOT.Pnom;
    resultData.DTe_star = out.DTestar * MOT.Tenom;
    resultData.wm_star  = out.wm_star * MOT.Wnom/MOT.p;
    resultData.V_star   = out.V_star * TUG.Vn;
    resultData.V        = out.V * TUG.Vn;
    resultData.Ft       = out.Ft * TUG.Fpnom;
    resultData.Fr       = out.Fr * TUG.Fpnom;
    resultData.Te       = out.Te * MOT.Tenom;
    resultData.Tp       = out.Tp * TUG.Tpnom;
    % Save the elapsed time
    resultData.elapsedTime = elapsedTime;

    



    % % Move all the "simResults_*.mat" files to the temporary "tempSimResults"
    % % folder. 
    % if ~exist('tempSimResults', 'dir')
    %     mkdir('tempSimResults');
    % end
    % movefile('simResults_*.mat', 'tempSimResults');

    % % Remove the string "simResults_" from the file names
    % files = dir('tempSimResults');
    % for i = 1:length(files)
    %     if startsWith(files(i).name, 'simResults_')
    %         oldName = fullfile('tempSimResults', files(i).name);
    %         newName = fullfile('tempSimResults', strrep(files(i).name, 'simResults_', ''));
    %         movefile(oldName, newName);
    %     end
    % end

end
