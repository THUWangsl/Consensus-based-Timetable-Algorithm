
%% 4 agents
clear; clc; close all;

nRuns = 100;
topologyType = 'Row';

% define the global parameters
Params.numTasks = 12;
Params.numAgents = 8;
Params.Xmax = 10000;
Params.Ymax = 10000;
Params.Zmax = 1000;
Params.upperLimit = Params.numTasks;
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

topologies = cell(1, 4);
% mesh topology
topologies{1} = ~eye(Params.numAgents);
% row topology
topology = zeros(Params.numAgents); % communication link between vehicles
for ii = 1:Params.numAgents - 1
    topology(ii, ii + 1) = 1;
end
topologies{2} = topology + topology';
% circular topology
topology = zeros(Params.numAgents); % communication link between vehicles
for ii = 1:Params.numAgents - 1
    topology(ii, ii + 1) = 1;
end
topology(Params.numAgents, 1) = 1;
topologies{3} = topology + topology';
% star topology
topology = zeros(Params.numAgents);
for ii = 1:3
    topology(ii, ii + 1) = 1;
end
topology(3, 5) = 1;
topology(5, 6) = 1;
topology(7, 8) = 1;
topology(3, 7) = 1;
topologies{4} = topology + topology';

avgStartCBGA = cell(1, 4);
avgStartCBTA = cell(1, 4);
for ii = 1: 4
    avgStartCBGA{ii} = zeros(1, nRuns);
    avgStartCBTA{ii} = zeros(1, nRuns);
end

iterationsCBGA = cell(1, 4);
iterationsCBTA = cell(1, 4);
for ii = 1: 4
    iterationsCBGA{ii} = zeros(1, nRuns);
    iterationsCBTA{ii} = zeros(1, nRuns);
end

runTimeCBGA = cell(1, 4);
runTimeCBTA = cell(1, 4);
for ii = 1: 4
    runTimeCBGA{ii} = zeros(1, nRuns);
    runTimeCBTA{ii} = zeros(1, nRuns);
end

totalRuns = 0;

kk = 1;
while kk <= nRuns
    Params.upperLimit = Params.numTasks;
    
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
    feasible = zeros(1, 4);
    for ii = 1: 4
        [avgStartCBGA{ii}(kk), iterationsCBGA{ii}(kk), runTimeCBGA{ii}(kk), feasible(ii)] = funcCBGA(Params, agents, tasks, topologies{ii});
    end
    rmpath('CBGA')
    if sum(feasible) == 4
        addpath('CBTA')
        for ii = 1: 4
            [avgStartCBTA{ii}(kk), iterationsCBTA{ii}(kk), runTimeCBTA{ii}(kk)] = funcCBTA(Params, agents, tasks, topologies{ii});
        end
        rmpath('CBTA')
        disp(['Number of tasks: ' num2str(Params.numTasks), ', number of feasible solutions: ' num2str(kk)]);
        kk = kk + 1;
    end
    
    totalRuns = totalRuns + 1;
    disp(['Total number of runs: ', num2str(totalRuns)]);
end

save topologyMultiTask