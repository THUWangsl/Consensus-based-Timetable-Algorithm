function [avgStart, iterations, runTime, allocations] = funcCBTA(Params, agents, tasks, topology)
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

iterations = 0;
converged = 0;
unChanged = 0;

tic 

while ~converged
    newInclusions = zeros(1, Params.numAgents);
    newRemovals = zeros(1, Params.numAgents);
    for ii = 1: Params.numAgents
        [allocations(ii), newInclusions(ii)] = taskInclusion(Params, allocations(ii), agents(ii), tasks);
    end
    for ii = 1: Params.numAgents
        for jj = 1: Params.numAgents
            if topology(ii, jj)
                [allocations(jj), newRemovals(jj)] = consensus(Params, allocations(jj), jj, allocations(ii), ii, agents(jj), tasks);
            end
        end
    end
    iterations = iterations + 1;
    if sum(newInclusions) + sum(newRemovals) == 0
        if unChanged == 0
            runTime = toc;
        end
        unChanged = unChanged + 1;
    else
        unChanged = 0;
    end
    if unChanged >= Params.numAgents
        converged = 1;
        iterations = iterations - Params.numAgents;
    end
end

startTime = max(allocations(1).timeTable);
avgStart = mean(startTime);

end