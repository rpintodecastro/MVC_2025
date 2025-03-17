%% Proposed EMS
% Write here all variables for the proposed EMS

%Step 1: create RL agent and workspace variables for reinforcement learning
% Tutorial:  https://www.mathworks.com/help/reinforcement-learning/ug/create-custom-simulink-environments.html
% Example: https://www.mathworks.com/help/reinforcement-learning/ug/water-tank-simulink-reinforcement-learning-environment.html


mdl = "MVC2025_sim"; % name of the model
%AGENT_FNAME = "finalAgent.mat";
AGENT_FNAME = "finalAgent_3_17_finalScore.mat"; % score of 1400

EMS_TYPE = "Baseline"; % evaluate the baseline solution provided by organizers
EMS_TYPE ="EvaluateRL"; % RL agent 
EMS_TYPE ="TrainRL";  % train rl agent

% load(AGENT_FNAME);
RLgain = 1; % enable RL agent

switch EMS_TYPE
    case "Baseline"
        RLgain =0; % disable RL agent
    case "EvaluateRL"
        
    case "TrainRL"
        
        
        %% TRAINING INFORMATION         
        Tsim = 50; %[s] % override simulation time to make it faster?
        % Ts; % sample time        
        maxepisodes = 5;
        %agentSampleTime = 0.1; % good performane, but with oscillation
        agentSampleTime = Ts;
        NumHiddenUnit = 64; 

        %agentSampleTime = Ts;
        maxsteps = ceil(Tsim/agentSampleTime);        
        StopTrainingValue=0; % condition to stop

        %-----------------------------------------------------
        %To create a specification object for an action channel carrying a continuous signal, use rlNumericSpec.
        actionInfo = rlNumericSpec([1 1],...
            LowerLimit=[-1  ]',...
            UpperLimit=[ 1]' );
        actionInfo.Name = "delta_TE";
        
        
        %Create a vector of observation specifications. 
        observationInfo = rlNumericSpec([4 1]);
        observationInfo.Name = "observations";
        %observationInfo.Description = "integrated error, error, and measured height";
        
        env = rlSimulinkEnv(mdl,mdl + "/Energy Management System/RL Agent",observationInfo,actionInfo);
        
        
        %Load Simulink Environments in Reinforcement Learning Designer
        %reinforcementLearningDesigner 
        % A) Manually import environement
        % B) Create agent (and its settings)
        % C) Train the agent
        %-------------------------
        
        % Create DDPG Agent
        %https://www.mathworks.com/help/releases/R2024b/reinforcement-learning/ug/train-ddpg-agent-to-swing-up-and-balance-pendulum.html
        initOpts = rlAgentInitializationOptions(NumHiddenUnit=NumHiddenUnit);
        agent = rlDDPGAgent(observationInfo,actionInfo,initOpts);
        
        % To ensure that the RL Agent block in the environment executes every Ts seconds (instead of the default one second), set the SampleTime property of the agent.
        agent.AgentOptions.SampleTime = agentSampleTime;
        %agent.AgentOptions.SampleTime = 1;
        
        % %Set a lower learning rate and gradient thresholds to avoid instability.
        agent.AgentOptions.CriticOptimizerOptions.LearnRate = 1e-3;
        agent.AgentOptions.ActorOptimizerOptions.LearnRate = 1e-3;
        agent.AgentOptions.CriticOptimizerOptions.GradientThreshold = 1;
        agent.AgentOptions.ActorOptimizerOptions.GradientThreshold = 1;
        % 
        % %Increase the length of the experience buffer and the size of the mini buffer.
        % agent.AgentOptions.ExperienceBufferLength = 1e5;
        agent.AgentOptions.MiniBatchSize = 128;
        
        % Train agent
        
        
        trainOpts = rlTrainingOptions(...
            MaxEpisodes=maxepisodes,...
            MaxStepsPerEpisode=maxsteps,...
            ScoreAveragingWindowLength=5,...
            Plots="training-progress",...
            StopTrainingCriteria="EpisodeSteps" ,...
            StopTrainingValue=maxsteps ,...
            SaveAgentCriteria="EpisodeCount",...
            SaveAgentValue=1,...
            SaveAgentDirectory=pwd + "\Agents_checkpoints");  % no stop criteria
%StopTrainingCriteria="none" 
            %StopTrainingValue=StopTrainingValue,...
        
            % Use the rlEvaluator object to measure policy performance every 10
            % episodes
%             evaluator = rlEvaluator(...
%                 NumEpisodes=1,...
%                 EvaluationFrequency=2);
            % Train the agent.
            trainingResults = train(agent,env,trainOpts);
        
            % save results
            save(AGENT_FNAME,'agent')

            % reinforcementLearningDesigner
end
