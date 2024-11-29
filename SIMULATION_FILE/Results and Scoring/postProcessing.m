%% VTS Motor Vehicles Challenge 2025
% Alessandro Serpi, Mario Porru
% Department of Electrical and Electronic Engineering
% University of Cagliari, Italy
% Fabio Tinazzi
% Department of Management and Engineering
% University of Padova, Italy
% Ludovico Ortombina
% Department of Industrial Engineering
% University of Padova, Italy
% https://github.com/VTSociety/MVC_2025
% Created from: 05 November 2024

% check if the elapsed time is available
if ~exist('elapsedTime', 'var')
    elapsedTime = 0;
end

% Prepare the results for the final score board
resultData     = prepareResultsData(out,BAT,SM,BUS,MOT,TUG,elapsedTime);

% Compute the scores
[SCORES,resultData] = scoresComputation(resultData,BAT,SM,MOT,CTRLpmsm,Ts);

% Show the results in the final report
disp('Please wait for the score board processing');
disp('Note: DO NOT close any plots');
options_doc_nocode.showCode = false;
web(publish('ResultsVTSChallenge2025.m',options_doc_nocode));
clear options_doc_nocode


% If desired, the results can be saved in a .mat file along with the workspace content
if (strcmp(saving_results,'yes'))
    % Save the current workspace in a .mat file of the temporary folder. The resultData structure is saved in the same file.
    workspace = fullfile('Results and Scoring','workspace.mat');
    save(workspace);
    % Then save the results in a specific folder for each simulation
    saveResults(UserDataName);
    clear workspace
end

% If desired, all figure can be closed at the end of the simulation
if (strcmp(close_figure,'yes'))
    close all;
end
clc;
disp('Finished');