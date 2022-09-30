clear;clc;close all;

nRuns = 1;
tRuns = zeros(1, nRuns);
iterRuns = zeros(1, nRuns);
pltFig = 10;
if nRuns > 10
    pltFig = 0;
end
topology = 'Row';

% define the global parameters
Params.numTasks = 4;
Params.numAgents = 4;
Params.Xmax = 10000;
Params.Ymax = 10000;
Params.Zmax = 1000;
Params.upperLimit = Params.numTasks;
Params.infty = 1E10;
Params.maxNumAgents = 2;
Params.maxRm = 6;

% define the default task struct
taskDefault.id = 1;
taskDefault.position = zeros(1, 3);
taskDefault.duration = 0;
taskDefault.numAgents = 2;

% define the default agent struct
agentDefault.id = 1;
agentDefault.position = zeros(1, 3);
agentDefault.speed = 30;

for kk = 1: nRuns
    Params.numTasks = 8;
    Params.numAgents = 4;
    % define the tasks
    rangeMax = [Params.Xmax, Params.Ymax, Params.Zmax];
    tasks = repmat(taskDefault, [1, Params.numTasks]);
    for ii = 1: Params.numTasks
        tasks(ii).id = ii;
        tasks(ii).position = rangeMax .* rand(1, 3);
        tasks(ii).duration = 200 + 200 * rand;
        tasks(ii).numAgents = 2;
    end
    
    % define the agents
    agents = repmat(agentDefault, [1, Params.numAgents]);
    for ii = 1: Params.numAgents
        agents(ii).id = ii;
        agents(ii).position = rangeMax .* rand(1, 3);
        agents(ii).speed = 20 + 20 * rand;
    end
    
    % define the default allocation struct
    allocationDefault.id = 1;
    allocationDefault.timeTable = zeros(Params.numAgents, Params.numTasks);
    allocationDefault.timeStamp = zeros(1, Params.numAgents);
    allocationDefault.numRm = zeros(1, Params.numTasks);
    
    % define the allocations
    allocations = repmat(allocationDefault, [1, Params.numAgents]);
    % The following four kinds of topologies are taken into consideration
    switch topology
        case 'Mesh'
            % mesh topology
            Graph = ~eye(Params.numAgents); % communication link between vehicles
        case 'Row'
            % row topology
            Graph = zeros(Params.numAgents); % communication link between vehicles
            
            for ii = 1:Params.numAgents - 1
                Graph(ii, ii + 1) = 1;
            end
            
            Graph = Graph + Graph';
        case 'Circular'
            % circular topology
            Graph = zeros(Params.numAgents); % communication link between vehicles
            for ii = 1: Params.numAgents - 1
                Graph(ii, ii + 1) = 1;
            end
            Graph(numVehicles, 1) = 1;
            Graph = Graph + Graph';
        case 'Star'
            % Star topology
            Graph = zeros(Params.numAgents); % communication link between vehicles
            for ii = 1: 4
                Graph(ii, ii + 1) = 1;
            end
            Graph(3, 5) = 1;
            Graph(2,6) = 1;
            Graph = Graph + Graph';
        otherwise
            % set default topology as mesh
            Graph = ~eye(numVehicles); % communication link between vehicles
    end
    tic
    [allocations, iterations] = coAllocation(Params, allocations, agents, tasks, Graph);
    toc
    disp(kk)
    if pltFig == 1
        plotAllocations(Params, allocations, agents, tasks);
    end
    startTime = max(allocations(1).timeTable);
    mean(startTime)
end