%% IEEE-VTS Motor Vehicles Challenge 2025
% Energy Management and Control of a Marine Electric Propulsion System

fprintf('Simulation Results: %s\n',UserDataName)
fprintf('\n')

fprintf('\n')

if (SCORES.constraintSoC || SCORES.constraintSoE)
    if SCORES.constraintSoC
        fprintf('-----------------------------------------------------------------------\n');
        fprintf('Battery constraints NOT verified. Simulation results NOT valid.\n');
        fprintf('-----------------------------------------------------------------------\n');
    else
        fprintf('-----------------------------------------------------------------------\n');
        fprintf('Supercapacitor constraints NOT verified. Simulation results NOT valid.\n');
        fprintf('-----------------------------------------------------------------------\n');
    end
    fprintf ('\n')
    fprintf('Final State-of-Charge of battery subsystem: %f%%\n', resultData.SoC_BP.Data(end)*100);
    fprintf('Final State-of-Energy of supercapacitor subsystem: %f%%\n', resultData.SoE_SM.Data(end)*100);
    fprintf ('\n')
else
    fprintf('-----------------------------------------------------------------------\n');
    fprintf('The FINAL SCORE is: %f\n', SCORES.Final_Score);
    fprintf('-----------------------------------------------------------------------\n');
    fprintf ('\n')
    
    %%%
    
    fprintf('Final State-of-Charge of battery subsystem: %f%%\n', resultData.SoC_BP.Data(end)*100);
    fprintf('Final State-of-Energy of supercapacitor subsystem: %f%%\n', resultData.SoE_SM.Data(end)*100);
    fprintf ('\n')
    
    fprintf('Impact of each cost function term on the final score:\n')
    fprintf('Battery current fluctuation impact on total cost: %f%%\n', (SCORES.k_bp*SCORES.phi_BP/SCORES.Final_Score*100));
    fprintf('Energy consumption impact on total cost: %f%%\n', (SCORES.k_e*SCORES.phi_E/SCORES.Final_Score*100));
    fprintf('DTP-PMSM overloading impact on total cost: %f%%\n', (SCORES.k_spm*SCORES.phi_SPM/SCORES.Final_Score*100));
    fprintf('DTP-PMSM winding exploitation impact on total cost: %f%%\n', (SCORES.k_w*SCORES.phi_w/SCORES.Final_Score*100));
end

%%%
% Ther simulation time is calculated in minutes and seconds
fprintf('Elapsed time: %d minutes, and %.2f seconds\n', SCORES.minutes, SCORES.seconds);
fprintf('\n')

%% Plot of results

%% Electric motor power
figure
plot(resultData.P_ABC/1000, 'LineWidth', 1.5, 'DisplayName', 'P_{ABC}^{}')
hold on; grid on;
plot(resultData.P_DEF/1000, 'LineWidth', 1.5, 'DisplayName', 'P_{DEF}^{}')
line([0 resultData.P_ABC.time(end)], SCORES.gamma*MOT.Pnom*[1 1]/1000, 'Color','k', 'LineStyle', '--', 'LineWidth', 1.5, 'DisplayName', 'P_{lim}^{}')
title('')
xlim([resultData.P_ABC.time(1) resultData.P_ABC.time(end)])
xlabel('Time [s]')
ylabel('Eletric motor winding power [kW]')
legend show
box on;


figure
plot(resultData.Pe/1000, 'LineWidth', 1.5, 'DisplayName', 'P_{e}^{}')
hold on; grid on;
plot((resultData.DTe_star.*resultData.wm_star)/1000, 'LineWidth', 1.5, 'DisplayName', '\DeltaP_{e}^{}')
title('')
xlim([resultData.Pe.time(1) resultData.Pe.time(end)])
xlabel('Time [s]')
ylabel('Eletric motor power and power unbalance [kW]')
legend show
box on;


%% Battery and supercapacitor 
figure
plot(resultData.P_BP/1000, 'LineWidth', 1.5, 'DisplayName', 'P_{BP}^{}')
hold on; grid on;
plot(resultData.P_SM/1000, 'LineWidth', 1.5, 'DisplayName', 'P_{SM}^{}')
title('')
xlim([resultData.v_BP.time(1) resultData.v_BP.time(end)])
xlabel('Time [s]')
ylabel('Battery and supercapacitor power [kW]')
legend show
box on;

figure
plot(resultData.SoC_BP, 'LineWidth', 1.5, 'DisplayName', 'SoC_{BP}^{}')
hold on; grid on;
plot(resultData.SoE_SM, 'LineWidth', 1.5, 'DisplayName', 'SoE_{SM}^{}')
title('')
xlim([resultData.SoC_BP.time(1) resultData.SoC_BP.time(end)])
xlabel('Time [s]')
ylabel('Battery SoC and SM SoE [%]')
legend show
box on;

%% Tug speed
figure
plot(resultData.V_star, 'LineWidth', 1.5, 'DisplayName', 'V^{*}')
hold on; grid on;
plot(resultData.V, 'LineWidth', 1.5, 'DisplayName', 'V^{}')
title('')
xlim([resultData.V_star.time(1) resultData.V_star.time(end)])
xlabel('Time [s]')
ylabel('Speed [m/s]')
legend show
box on;

%% Traction and resisitive force
figure
plot(resultData.Ft/1000, 'LineWidth', 1.5, 'DisplayName', 'F_{t}^{}')
hold on; grid on;
plot(resultData.Fr/1000, 'LineWidth', 1.5, 'DisplayName', 'F_{r}^{}')
title('')
xlim([resultData.Ft.time(1) resultData.Ft.time(end)])
xlabel('Time [s]')
ylabel('Force [kN]')
legend show
box on;

%% Motor and propeller torque
figure
plot(resultData.Te/1000, 'LineWidth', 1.5, 'DisplayName', 'T_{pmsm}')
hold on; grid on;
plot(resultData.Tp/1000, 'LineWidth', 1.5, 'DisplayName', 'T_{prop}')
title('')
xlim([resultData.Te.time(1) resultData.Te.time(end)])
xlabel('Time [s]')
ylabel('Torque [kNm]')
legend show
box on;

clear gamma

% delete all timeseries files
vars = whos;
for i = 1:length(vars)
    if strcmp(vars(i).class, 'timeseries')
        clear(vars(i).name); % Delete the time series variable
    end
end

