%% Proposed EMS
% Write here all variables for the proposed EMS

%Step 1: create RL agent and workspace variables for reinforcement learning
% Tutorial:  https://www.mathworks.com/help/reinforcement-learning/ug/create-custom-simulink-environments.html
% Example: https://www.mathworks.com/help/reinforcement-learning/ug/water-tank-simulink-reinforcement-learning-environment.html


mdl = "MVC2025_sim"; % name of the model
AGENT_FNAME = "finalAgent.mat";

%EMS_TYPE = "Baseline"; 
EMS_TYPE ="EvaluateRL";
%EMS_TYPE ="TrainRL";


load(AGENT_FNAME);
RLgain = 1; % enable RL agent

switch EMS_TYPE
    case "Baseline"
        RLgain =0; % disable RL agent
    case "EvaluateRL"        
        
    case "TrainRL"
        doTraining = true;
        
        %% TRAINING INFORMATION 
        if doTraining
            Tsim = 30; %[s] % override simulation time to make it faster?
            % Ts; % sample time
        end
        
        %To create a specification object for an action channel carrying a continuous signal, use rlNumericSpec.
        actionInfo = rlNumericSpec([1 1],...
            LowerLimit=[-3  ]',...
            UpperLimit=[ 3]' );
        actionInfo.Name = "delta_TE";
        
        
        %Create a three-element vector of observation specifications. 
        observationInfo = rlNumericSpec([7 1]);
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
        agent = rlDDPGAgent(observationInfo,actionInfo);
        
        % To ensure that the RL Agent block in the environment executes every Ts seconds (instead of the default one second), set the SampleTime property of the agent.
        agent.AgentOptions.SampleTime = 0.5;
        
        %Set a lower learning rate and gradient thresholds to avoid instability.
        agent.AgentOptions.CriticOptimizerOptions.LearnRate = 1e-3;
        agent.AgentOptions.ActorOptimizerOptions.LearnRate = 1e-3;
        agent.AgentOptions.CriticOptimizerOptions.GradientThreshold = 1;
        agent.AgentOptions.ActorOptimizerOptions.GradientThreshold = 1;
        
        %Increase the length of the experience buffer and the size of the mini buffer.
        agent.AgentOptions.ExperienceBufferLength = 1e5;
        agent.AgentOptions.MiniBatchSize = 128;
        
        % Train agent
        maxepisodes = 1000;
        maxsteps = ceil(Tsim/agent.AgentOptions.SampleTime);
        StopTrainingValue=10;
        trainOpts = rlTrainingOptions(...
            MaxEpisodes=maxepisodes,...
            MaxStepsPerEpisode=maxsteps,...
            ScoreAveragingWindowLength=5,...
            Verbose=false,...
            Plots="training-progress",...
            StopTrainingCriteria="EvaluationStatistic",...
            StopTrainingValue=StopTrainingValue,...
            SaveAgentCriteria="EvaluationStatistic",...
            SaveAgentValue=StopTrainingValue);
        
        
        
            % Use the rlEvaluator object to measure policy performance every 10
            % episodes
            evaluator = rlEvaluator(...
                NumEpisodes=1,...
                EvaluationFrequency=2);
            % Train the agent.
            trainingResults = train(agent,env,trainOpts,Evaluator=evaluator);
        
            % save results
            save(AGENT_FNAME,'agent')

    
end
