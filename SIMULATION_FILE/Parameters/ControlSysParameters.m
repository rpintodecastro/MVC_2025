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

%% Control parameters
	
% Tug speed loop	
CTRLtug.alpha_F = 2\GEN.rhow*TUG.S*0.007;
CTRLtug.beta_F = CTRLtug.alpha_F*TUG.Vn/2;
CTRLtug.fcV = 1/150*timefactor;
CTRLtug.kpV = 2*pi*CTRLtug.fcV*TUG.M/2*10;							
CTRLtug.kiV = CTRLtug.kpV*CTRLtug.beta_F/(TUG.M/2);
	
% Tug + vessel speed loop
CTRLves.alpha_F = 2\GEN.rhow*(TUG.S + VES.S)*0.0035;
CTRLves.beta_F = CTRLves.alpha_F*TUG.Vn/2;
CTRLves.fcV = 1/300*timefactor;
CTRLves.kpV = 2*pi*CTRLves.fcV*(TUG.M + VES.M)/2;					
CTRLves.kiV = CTRLves.kpV*CTRLves.beta_F/((TUG.M + VES.M)/2);

% Propeller + PMSM speed loop
CTRLpmsm.alpha_T = TUG.kQ*GEN.rhow*TUG.Dm^5/(2*pi)^2/TUG.tau^2; 
CTRLpmsm.beta_T = CTRLpmsm.alpha_T*MOT.Wnom/MOT.p/TUG.tau;
CTRLpmsm.fcw = 1/6*timefactor;
CTRLpmsm.kpw = 2*pi*CTRLpmsm.fcw*(MOT.J + TUG.Jp/TUG.tau^2);					
CTRLpmsm.kiw = CTRLpmsm.kpw*(MOT.D + CTRLpmsm.beta_T + TUG.Dp/TUG.tau^2)/(MOT.J + TUG.Jp/TUG.tau^2);
	
% Motor current loops parameters
CTRLpmsm.fci = 1e2;
CTRLpmsm.kpp = 2*pi*CTRLpmsm.fci*MOT.Ls;				
CTRLpmsm.kip = CTRLpmsm.kpp*MOT.R/MOT.Ls;
CTRLpmsm.kpm = 2*pi*CTRLpmsm.fci*MOT.L0;				
CTRLpmsm.kim = CTRLpmsm.kpm*MOT.R/MOT.L0;
CTRLpmsm.kp0 = 2*pi*CTRLpmsm.fci*MOT.L0;				
CTRLpmsm.ki0 = CTRLpmsm.kpm*MOT.R/MOT.L0;