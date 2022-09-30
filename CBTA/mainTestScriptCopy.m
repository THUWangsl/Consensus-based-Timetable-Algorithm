clear; clc; close all;

nRuns = 1000;
tRuns = zeros(1, nRuns);
iterRuns = zeros(1, nRuns);
pltFig = 1;
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
Params.maxRm = 10;

% define the default task struct
taskDefault.id = 1;
taskDefault.position = zeros(1, 3);
taskDefault.duration = 0;
taskDefault.numAgents = 2;

% define the default agent struct
agentDefault.id = 1;
agentDefault.position = zeros(1, 3);
agentDefault.speed = 30;


nTasks = 4;
lenTasks = length(nTasks);

meanStartProposed = zeros(lenTasks, nRuns);
iterationsProposed = zeros(lenTasks, nRuns);
runTimeProposed = zeros(lenTasks, nRuns);
meanStartCBGA = zeros(lenTasks, nRuns);
iterationsCBGA = zeros(lenTasks, nRuns);
runTimeCBGA = zeros(lenTasks, nRuns);
totalRuns = zeros(1, lenTasks);
for tt = 1:lenTasks
    kk = 1;
    totalRuns(tt) = 0;
    while kk <= nRuns
        Params.numTasks = 4 + randi(4);
        Params.numAgents = 2 + randi(4);
        Params.upperLimit = Params.numTasks;
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
                for ii = 1:Params.numAgents - 1
                    Graph(ii, ii + 1) = 1;
                end
                Graph(numVehicles, 1) = 1;
                Graph = Graph + Graph';
            case 'Star'
                % Star topology
                Graph = zeros(Params.numAgents); % communication link between vehicles
                for ii = 1:4
                    Graph(ii, ii + 1) = 1;
                end
                Graph(3, 5) = 1;
                Graph(2, 6) = 1;
                Graph = Graph + Graph';
            otherwise
                % set default topology as mesh
                Graph = ~eye(numVehicles); % communication link between vehicles
        end
        % define the tasks
        rangeMax = [Params.Xmax, Params.Ymax, Params.Zmax];
        tasks = repmat(taskDefault, [1, Params.numTasks]);
        for ii = 1:Params.numTasks
            tasks(ii).id = ii;
            tasks(ii).position = rangeMax .* rand(1, 3);
            tasks(ii).duration = 200 + 200 * rand;
            tasks(ii).numAgents = 2;
        end
        
        % define the agents
        agents = repmat(agentDefault, [1, Params.numAgents]);
        for ii = 1:Params.numAgents
            agents(ii).id = ii;
            agents(ii).position = rangeMax .* rand(1, 3);
            agents(ii).speed = 20 + 20 * rand;
        end
        
        numTasks = Params.numTasks;
        numAgents = Params.numAgents;
        % define the default allocation struct
        allocationDefault.id = 1;
        allocationDefault.timeTable = zeros(Params.numAgents, Params.numTasks);
        allocationDefault.timeStamp = zeros(1, Params.numAgents);
        allocationDefault.numRm = zeros(1, Params.numTasks);
        
        % define the allocations
        allocations = repmat(allocationDefault, [1, Params.numAgents]);
        Params.maxNumAgents = 0;
        for ii = 1:Params.numTasks
            if tasks(ii).numAgents > Params.maxNumAgents
                Params.maxNumAgents = tasks(ii).numAgents;
            end
        end
        tic
        [allocations, iterationsProposed(tt, kk)] = coAllocation(Params, allocations, agents, tasks, Graph);
        runTimeProposed(tt, kk) = toc;
        startTime = max(allocations(1).timeTable);
        meanStartProposed(tt, kk) = mean(startTime);
        if pltFig == 1
            close all;
            plotAllocations(Params, allocations, agents, tasks);
            pause(0.1);
        end
%         disp(['Number of tasks: ' num2str(Params.numTasks), ', number of feasible solutions: ' num2str(kk)]);
        kk = kk + 1;
        totalRuns(tt) = totalRuns(tt) + 1;
        disp(['Total number of runs: ', num2str(totalRuns(tt)), ', Average start time of tasks: ', num2str(mean(startTime))]);
    end
end
