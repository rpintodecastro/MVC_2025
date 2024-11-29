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

%% Weighting factors 

SCORES.didt_nom    = BAT.I_nom/(SM.E_nom/MOT.Pnom);         % Rated battery current time variation
SCORES.gamma       = 0.8;						            % Sharing DTP-PMSM coeff
SCORES.th          = 0.09*MOT.Inom^2;                       % Threshold for the winding exploitation evaluation

SCORES.k_bp        = 25/sqrt(30e-2);				    	% Battery pack current fluctuations factor
SCORES.k_e         = 25/(BAT.E_nom + SM.E_nom);				% Energy consumption factor
SCORES.k_spm       = 25/((SCORES.gamma*MOT.Pnom)^2*10e-2);  % DTP-PMSM torque sharing factor
SCORES.k_w         = 25;								    % Winding exploitation factor