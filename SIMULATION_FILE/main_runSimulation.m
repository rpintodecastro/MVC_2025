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


%% Preparation
clearvars
close all
clc

%%%
% Prepare the MATLAB path to include the necessary folders. This folder 
% will be automatically deleted once Matlab is closed.
addpath('Results and Scoring');
addpath('Parameters')
addpath('Reference')

%% Save results settings
% If YES option is selected, all simulation results are saved in the
% project folder "Result and Scoring" with the file nomenclature:
% "UserName_data_time", where "UserDataName" can be set as desired.
% The entire workspace, which will include the simulation results, is
% saved as well as the html report. The simulation results are, at the end
% of the simulation, present in the Matlab workspace in form of stucture of
% timeseries by the name "out".
 %saving_results = 'yes';
saving_results = 'no';

UserDataName = 'MVC2025';

%% Close figure
% If YES option is selected, all matlab figures generated at the end of the
% simulation reporting main results will be closed.
% close_figure = 'yes';
close_figure = 'no';

%% References
% Uncomment the desired reference cycle to be implemented during the simulation
reference1;

%%%
% The evaluation of the proposals will be carried out with the "timefactor 
% = 60" option. All simulation parameters are computed accordingly. The 
% "timefactor" will not be modified for the final evaluation.
timefactor = 60; 
V_star.time = V_star.time/timefactor;
Tsim = V_star.time(end)*60/timefactor;

%% Load system parameters
Parameters;

%% Load control system parameters
ControlSysParameters;

%% EMS
% Participants must uncomment the file "ProposedEMS" and insert in all 
% variables necessary for their solution."
% The file BaseEMS must be commented out.
BaseEMS;
ProposedEMS;

%% Run simulation
tic
out = sim("MVC2025_sim.slx");

elapsedTime = toc;

%% Post processing
postProcessing;
