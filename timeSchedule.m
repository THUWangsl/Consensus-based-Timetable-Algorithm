%% 4 agents
clear; clc; close all;

nRuns = 1;
pltFig = 1;
if nRuns > 10
    pltFig = 0;
end

% define the global parameters
Params.numAgents = 4;
Params.Xmax = 10000;
Params.Ymax = 10000;
Params.Zmax = 1000;

Params.infty = 1E10;
Params.maxRm = 10;

topology = zeros(Params.numAgents); % communication link between vehicles
for ii = 1:Params.numAgents - 1
    topology(ii, ii + 1) = 1;
end
topology = topology + topology';

% define the default task struct
taskDefault.id = 1;
taskDefault.position = zeros(1, 3);
taskDefault.duration = 0;
taskDefault.numAgents = 2;

% define the default agent struct
agentDefault.id = 1;
agentDefault.position = zeros(1, 3);
agentDefault.speed = 30;


Params.numTasks = 8;
Params.upperLimit = Params.numTasks;

totalRuns = 0;

kk = 1;
while kk <= nRuns
    % define the tasks
    rangeMax = [Params.Xmax, Params.Ymax, Params.Zmax];
    tasks = repmat(taskDefault, [1, Params.numTasks]);
    for ii = 1:Params.numTasks
        tasks(ii).id = ii;
        tasks(ii).position = rangeMax .* rand(1, 3);
        tasks(ii).duration = 200 + 200 * rand;
        tasks(ii).numAgents = randi(3);
    end
    
    % define the agents
    agents = repmat(agentDefault, [1, Params.numAgents]);
    for ii = 1:Params.numAgents
        agents(ii).id = ii;
        agents(ii).position = rangeMax .* rand(1, 3);
        agents(ii).speed = 20 + 20 * rand;
    end
    
    addpath('CBGA')
    [avgStartCBGA, iterationsCBGA, runTimeCBGA, con, allocations] = funcCBGA(Params, agents, tasks, topology);
    if con
        if pltFig
            plotCoAllocations(Params, allocations, agents, tasks);
        end
        rmpath('CBGA')
        addpath('CBTA')
        [avgStartCBTA, iterationsCBTA, runTimeCBTA, allocations] = funcCBTA(Params, agents, tasks, topology);
        if pltFig
            plotAllocations(Params, allocations, agents, tasks);
        end
        rmpath('CBTA')
        kk = kk + 1;
        %     disp(['Number of tasks: ' num2str(Params.numTasks), ', number of feasible solutions: ' num2str(kk)]);
    end
end
totalRuns = totalRuns + 1;
disp([avgStartCBGA, avgStartCBTA])
% disp(['Total number of runs: ', num2str(totalRuns(tt))]);
% save 4AgentsSchedule