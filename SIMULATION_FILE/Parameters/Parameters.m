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


%% Hybrid energy storage system (HESS) parameters

%% Battery Pack Information (2.2 MW, 2.2 MWh)
BAT.P_nom			= 2.2e6;						% [W] Rated power
BAT.V_nom           = 800;	                        % [V] Rated voltage
BAT.I_nom           = BAT.P_nom/BAT.V_nom;	        % [A] Rated current
BAT.Q_nom           = BAT.I_nom*3600/timefactor;    % [C] Rated capacity
BAT.E_nom           = BAT.Q_nom*BAT.V_nom;	        % [J] Rated energy
BAT.r               = 0.01;				            % [Ohm] Series resistance
BAT.rho             = 1e-3;			                % [Ohm] RC branch resistance
BAT.ci              = 0.1;				            % [F] RC branch capacitance
BAT.SoC_0           = 0.95;			                % [-] Initial state-of-charge
BAT.SoC_min			= 0.05;							% [-] Miminum state-of-charge
BAT.SoC_max			= 1+eps;						% [-] Maximum state-of-charge

%% Supercapacitor Module Information	(2.2 MW, 70 kWh)
SM.P_nom			= 2.2e6;						% [W] Rated power
SM.V_nom            = 800;							% [V] Rated voltage
SM.I_nom            = SM.P_nom/SM.V_nom;	        % [A] Rated current
SM.r                = 0.002;						% [Ohm] Main branch series resistance
SM.C                = 2.5/timefactor;				% [F] Constant capacitance
SM.k                = 1.5/timefactor;				% [F/V] Voltage-dependent capacitance gain

SM.rho_1            = 90;							% [Ohm] First branch series resistance
SM.ci_1             = 1.5/timefactor;				% [Ohm] First branch capacitance
SM.rho_2            = 1e3;							% [Ohm] Second branch series resistance
SM.ci_2             = 4/timefactor;					% [F] Second branch capacitance
	
SM.E_nom            = 2\(SM.C + SM.ci_1 + SM.ci_2)*SM.V_nom^2 + 3\SM.k*SM.V_nom^3;	
                                                    % [J] Rated energy
SM.V_0              = 0.8*SM.V_nom;					% [V] Initial voltage
SM.SoE_0            = (2\(SM.C + SM.ci_1 + SM.ci_2)*SM.V_0^2 + 3\SM.k*SM.V_0^3)/SM.E_nom;
                                                    % [-] Initial state-of-energy
SM.E_nom_kWh        = SM.E_nom/3.6e6;               % [J] Rated energy

SM.SoE_min			= 0.01;							% [-] Miminum state-of-energy
SM.SoE_max			= 1+eps;						% [-] Maximum state-of-energy

%% DC/DC converter efficiency
CONV.BATeta        = [.75 .85 .92 .93 .94 .95 .95 .96 .95 .94 .92*ones(1,6)]*100;
                                                    % [-] Efficiency of battery DC/DC converter
CONV.BATi          = (0:0.1:1.5)*BAT.I_nom;         % [A] Current vector to tabulate converter efficiency
CONV.SMeta         = [.83 .88 .95 .96 .97 .98 .98 .98 .97 .95 .94*ones(1,6)]*100;
                                                    % [-] Efficiency of SM DC/DC converter
CONV.SMi           = (0:0.1:1.5)*SM.I_nom;          % [A] Current vector to tabulate converter efficiency

%% 6 Phase PMSM Information
% Electric parameters
MOT.R               = 20.6e-3;						% [Ohm] Phase resistance
MOT.L               = 2.5e-3;					    % [H] Self-inductance
MOT.M               = 0.8e-3;					    % [H] Mutual-inductance
MOT.Ls              = MOT.L + 4*MOT.M;				% [H] Synchronous inductance
MOT.L0              = MOT.L - 2*MOT.M;				% [H] Zero-sequence inductance
MOT.p               = 3;							% [-] Pole pairs
MOT.PMflux          = 4.8*sqrt(2);			        % [Vs] PM flux-linkage, 

% Rated Values
MOT.Wmnom           = 1000/30*pi;				    % [rad/s] Rated mechanical speed 
MOT.Wnom            = MOT.p*MOT.Wmnom;			    % [rad/s] Rated electrical speed 
MOT.Tenom           = 20e3;					        % [Nm] Rated torque
MOT.fmnom           = MOT.Wmnom/2/pi;
MOT.Inom            = MOT.Tenom/(3/2*MOT.p*MOT.PMflux); % [A] Rated current;
% MOT.Vnom            = 2/2*sqrt((MOT.Wnom*2*MOT.PMflux + MOT.R*MOT.Inom)^2 + (-MOT.Wnom*MOT.Ls*MOT.Inom)^2);
                                                    % [V] Rated voltage
MOT.Pjnom           = 4\3*MOT.R*MOT.Inom^2;         % [W] Rated joule loss
MOT.Pmnom           = MOT.Tenom*MOT.Wnom/MOT.p;     % [W] Rated mechanical power 
MOT.Pnom            = MOT.Pjnom + MOT.Pmnom;        % [W] Rated electrical power
% MOT.Qnom            = 4\3*MOT.Wnom*MOT.L*MOT.Inom^2;% [VAR] Rated reactive power

% Mechanical parameters
MOT.Dnom            = MOT.Tenom/(MOT.Wnom/MOT.p);
MOT.D               = 0.03*MOT.Dnom;                % [Nms/rad] Rotor damping coeff
MOT.J               = 0.2*MOT.D/6;                  % [kgm^2] Rotor inertia


%% DC-link parameters
BUS.Vdc             = 5e3;                          % [V] DC-link rated voltage
BUS.Idc_nom         = MOT.Pnom/BUS.Vdc;             % [A] DC-link rated current

%% Others
Ts = 1e-3;
DF = 1;

%% Propeller and vessel informations
% General info
GEN.g               = 9.81;							% [m/s^2] Gravity acceleration
GEN.rhow            = 1000;							% [kg/m^3] Water mass density 

% Tug parameters
TUG.tau             = 5;							% [-] Gear ratio 
TUG.L               = 27.8;							% [m] Tug lenght
TUG.M               = 600e3/timefactor;				% [kg] Tug mass
TUG.S               = 392;							% [m^2] Tug wetted area
TUG.kT              = 0.1483;						% [-] Thurst coefficient
TUG.kQ              = 0.0347;						% [-] Torque coefficient 
TUG.Dm              = 3;							% [m] Propeller diameter
TUG.Jp              = 232.8/timefactor;				% [kg*m^2] Propeller inertia
TUG.Dp              = 0.02*MOT.Tenom*TUG.tau/(MOT.Wmnom/TUG.tau); % [Nms/rad] Propeller dump coefficient

% Tug rated values
TUG.Vw              = 0;				            % [m/s] Water speed in tug moving direction
TUG.wf              = 0;				            % [-] Wake fraction
TUG.fpnom           = MOT.fmnom/TUG.tau;
TUG.Fpnom           = TUG.kT*GEN.rhow*TUG.fpnom^2*TUG.Dm^4;	% [N] Rated thrust force
TUG.Tpnom           = TUG.kQ*GEN.rhow*TUG.Dm^5*TUG.fpnom^2;	% [Nm] Rated propulsion torque
TUG.Vn              = 15*0.514444;			        % [m/s] Rated speed
TUG.etanom          = TUG.kT/TUG.kQ*(TUG.Vn/(TUG.fpnom)/TUG.Dm); % [-] Propeller rated efficiency
TUG.Frnom           = 2\GEN.rhow*TUG.S*0.007*TUG.Vn^2; % [N] Estimated rated resistance thrust

% Vessel parameters
VES.M               = 100410e3/timefactor;          % [kg] Vessel mass
VES.L               = 246;                          % [m] Vessel lenght
VES.S               = 1.2339e+04;				    % [m^2] Vessel wetted area

