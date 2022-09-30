%% 4 agents
clear; clc; close all;

Params.numAgents = 4;

nRuns = 100;
% row topology
topology = zeros(Params.numAgents); % communication link between vehicles
for ii = 1:Params.numAgents - 1
    topology(ii, ii + 1) = 1;
end
topology = topology + topology';

% define the global parameters
Params.Xmax = 10000;
Params.Ymax = 10000;
Params.Zmax = 1000;
Params.infty = 1E10;
Params.maxRm = 5;

% define the default task struct
taskDefault.id = 1;
taskDefault.position = zeros(1, 3);
taskDefault.duration = 0;
taskDefault.numAgents = 2;

% define the default agent struct
agentDefault.id = 1;
agentDefault.position = zeros(1, 3);
agentDefault.speed = 30;

nTasks = 4:2:8;
lenTasks = length(nTasks);

meanStartProposed = zeros(lenTasks, nRuns);
iterationsProposed = zeros(lenTasks, nRuns);
runTimeProposed = zeros(lenTasks, nRuns);
meanStartCBGA = zeros(lenTasks, nRuns);
iterationsCBGA = zeros(lenTasks, nRuns);
runTimeCBGA = zeros(lenTasks, nRuns);
for tt = 1:lenTasks
    kk = 1;
    while kk <= nRuns
        Params.numTasks = nTasks(tt);
        Params.upperLimit = Params.numTasks;
        % define the tasks
        rangeMax = [Params.Xmax, Params.Ymax, Params.Zmax];
        tasks = repmat(taskDefault, [1, Params.numTasks]);
        for ii = 1:Params.numTasks
            tasks(ii).id = ii;
            tasks(ii).position = rangeMax .* rand(1, 3);
            tasks(ii).duration = 200 + 200 * rand;
            tasks(ii).numAgents = 1;
        end

        % define the agents
        agents = repmat(agentDefault, [1, Params.numAgents]);
        for ii = 1:Params.numAgents
            agents(ii).id = ii;
            agents(ii).position = rangeMax .* rand(1, 3);
            agents(ii).speed = 20 + 20 * rand;
        end
        
        addpath('CBGA')
        [meanStartCBGA(tt, kk), iterationsCBGA(tt, kk), runTimeCBGA(tt, kk), feasible] = funcCBGA(Params, agents, tasks, topology);
        rmpath('CBGA')
        if feasible
            addpath('CBTA')
            [meanStartProposed(tt, kk), iterationsProposed(tt, kk), runTimeProposed(tt, kk)] = funcCBTA(Params, agents, tasks, topology);
            rmpath('CBTA')
            disp(['Number of tasks: ' num2str(Params.numTasks), ', number of feasible solutions: ' num2str(kk)]);
            kk = kk + 1;
        end
    end
end
save Results/SingleAgentTaskResults/singleTask4Agents.mat

%% 8 agents
clear; clc; close all;

Params.numAgents = 8;

nRuns = 100;
% row topology
topology = zeros(Params.numAgents); % communication link between vehicles
for ii = 1:Params.numAgents - 1
    topology(ii, ii + 1) = 1;
end
topology = topology + topology';

% define the global parameters
Params.Xmax = 10000;
Params.Ymax = 10000;
Params.Zmax = 1000;
Params.infty = 1E10;
Params.maxRm = 5;

% define the default task struct
taskDefault.id = 1;
taskDefault.position = zeros(1, 3);
taskDefault.duration = 0;
taskDefault.numAgents = 2;

% define the default agent struct
agentDefault.id = 1;
agentDefault.position = zeros(1, 3);
agentDefault.speed = 30;

nTasks = 8: 4: 16;
lenTasks = length(nTasks);

meanStartProposed = zeros(lenTasks, nRuns);
iterationsProposed = zeros(lenTasks, nRuns);
runTimeProposed = zeros(lenTasks, nRuns);
meanStartCBGA = zeros(lenTasks, nRuns);
iterationsCBGA = zeros(lenTasks, nRuns);
runTimeCBGA = zeros(lenTasks, nRuns);
for tt = 1:lenTasks
    kk = 1;
    while kk <= nRuns
        Params.numTasks = nTasks(tt);
        Params.upperLimit = Params.numTasks;
        % define the tasks
        rangeMax = [Params.Xmax, Params.Ymax, Params.Zmax];
        tasks = repmat(taskDefault, [1, Params.numTasks]);
        for ii = 1:Params.numTasks
            tasks(ii).id = ii;
            tasks(ii).position = rangeMax .* rand(1, 3);
            tasks(ii).duration = 200 + 200 * rand;
            tasks(ii).numAgents = 1;
        end

        % define the agents
        agents = repmat(agentDefault, [1, Params.numAgents]);
        for ii = 1:Params.numAgents
            agents(ii).id = ii;
            agents(ii).position = rangeMax .* rand(1, 3);
            agents(ii).speed = 20 + 20 * rand;
        end
        
        addpath('CBGA')
        [meanStartCBGA(tt, kk), iterationsCBGA(tt, kk), runTimeCBGA(tt, kk), feasible] = funcCBGA(Params, agents, tasks, topology);
        rmpath('CBGA')
        if feasible
            addpath('CBTA')
            [meanStartProposed(tt, kk), iterationsProposed(tt, kk), runTimeProposed(tt, kk)] = funcCBTA(Params, agents, tasks, topology);
            rmpath('CBTA')
            disp(['Number of tasks: ' num2str(Params.numTasks), ', number of feasible solutions: ' num2str(kk)]);
            kk = kk + 1;
        end
    end
end
save Results/SingleAgentTaskResults/singleTask8Agents.mat

%% 12 agents
clear; clc; close all;

Params.numAgents = 12;

nRuns = 100;
% row topology
topology = zeros(Params.numAgents); % communication link between vehicles
for ii = 1:Params.numAgents - 1
    topology(ii, ii + 1) = 1;
end
topology = topology + topology';

% define the global parameters
Params.Xmax = 10000;
Params.Ymax = 10000;
Params.Zmax = 1000;
Params.infty = 1E10;
Params.maxRm = 5;

% define the default task struct
taskDefault.id = 1;
taskDefault.position = zeros(1, 3);
taskDefault.duration = 0;
taskDefault.numAgents = 2;

% define the default agent struct
agentDefault.id = 1;
agentDefault.position = zeros(1, 3);
agentDefault.speed = 30;

nTasks = 12: 6: 24;
lenTasks = length(nTasks);

meanStartProposed = zeros(lenTasks, nRuns);
iterationsProposed = zeros(lenTasks, nRuns);
runTimeProposed = zeros(lenTasks, nRuns);
meanStartCBGA = zeros(lenTasks, nRuns);
iterationsCBGA = zeros(lenTasks, nRuns);
runTimeCBGA = zeros(lenTasks, nRuns);
for tt = 1:lenTasks
    kk = 1;
    while kk <= nRuns
        Params.numTasks = nTasks(tt);
        Params.upperLimit = Params.numTasks;
        % define the tasks
        rangeMax = [Params.Xmax, Params.Ymax, Params.Zmax];
        tasks = repmat(taskDefault, [1, Params.numTasks]);
        for ii = 1:Params.numTasks
            tasks(ii).id = ii;
            tasks(ii).position = rangeMax .* rand(1, 3);
            tasks(ii).duration = 200 + 200 * rand;
            tasks(ii).numAgents = 1;
        end

        % define the agents
        agents = repmat(agentDefault, [1, Params.numAgents]);
        for ii = 1:Params.numAgents
            agents(ii).id = ii;
            agents(ii).position = rangeMax .* rand(1, 3);
            agents(ii).speed = 20 + 20 * rand;
        end
        
        addpath('CBGA')
        [meanStartCBGA(tt, kk), iterationsCBGA(tt, kk), runTimeCBGA(tt, kk), feasible] = funcCBGA(Params, agents, tasks, topology);
        rmpath('CBGA')
        if feasible
            addpath('CBTA')
            [meanStartProposed(tt, kk), iterationsProposed(tt, kk), runTimeProposed(tt, kk)] = funcCBTA(Params, agents, tasks, topology);
            rmpath('CBTA')
            disp(['Number of tasks: ' num2str(Params.numTasks), ', number of feasible solutions: ' num2str(kk)]);
            kk = kk + 1;
        end
    end
end
save Results/SingleAgentTaskResults/singleTask12Agents.mat