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

%% Energy management parameters
tau0 = 120/timefactor;							% [s] Filter time constant

ESM.fc = 1/300*timefactor;						% [Hz] SM SoE loop bandwidth
ESM.kp = 2*pi*ESM.fc*SM.E_nom;	        		% [W] P gain