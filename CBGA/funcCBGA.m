function [avgStart, iterations, runTime, feasible, allocations] = funcCBGA(Params, agents, tasks, topology)
numTasks = Params.numTasks;
numAgents = Params.numAgents;
for ii = 1:numTasks
    tasks(ii).reward = 1E6;
    tasks(ii).ID = tasks(ii).id;
end
for ii = 1:numAgents
    agents(ii).ID = agents(ii).id;
end
allocationDefault.bundle = -1 * ones(1, numTasks + 1);
allocationDefault.taskPath = -1 * ones(1, numTasks + 1);
allocationDefault.timeStamp = zeros(1, numAgents);
allocationDefault.winners = zeros(1, numTasks);
allocationDefault.winnerBids = zeros(1, numTasks);
allocationDefault.assignMatrix = zeros(numAgents, numTasks);

allocations = repmat(allocationDefault, [1, numAgents]);
converge = 0;
unChanged = 0;
iterations = 0;
tic
while ~converge
    newInclusion = zeros(1, Params.numAgents);
    newRemoval = zeros(1, Params.numAgents);
    for ii = 1:Params.numAgents
        [allocations(ii), newInclusion(ii)] = buildBundle(allocations(ii), agents(ii), tasks);
    end
    for ii = 1:Params.numAgents
        for jj = 1:Params.numAgents
            if topology(ii, jj) == 1
                allocations(jj) = duoConsensus(allocations(jj), jj, allocations(ii), ii, tasks);
            end
        end
    end
    for ii = 1:Params.numAgents
        [allocations(ii), newRemoval(ii)] = taskRemoval(allocations(ii), agents(ii));
    end
    if sum(newInclusion) + sum(newRemoval) == 0
        if unChanged == 0
            runTime = toc;
        end
        unChanged = unChanged + 1;
    else
        unChanged = 0;
    end
    if unChanged >= Params.numAgents * 2
        converge = 1;
        iterations = iterations - Params.numAgents * 2;
        runTime = toc;
    end
    if iterations > 1000
        converge = 1;
    end
    iterations = iterations + 1;
end

[timeTable, feasible] = genTimeTable(Params, allocations, agents, tasks);
for ii = 1: numAgents
    allocations(ii).timeTable = timeTable;
end
avgStart = mean(max(timeTable));
end
