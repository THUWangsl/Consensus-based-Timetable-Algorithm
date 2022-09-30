function [allocations, iterations] = coAllocation(Params, allocations, agents, tasks, G)
    iterations = 0;
    converged = 0;
    unChanged = 0;
    while ~converged
        newInclusions = zeros(1, Params.numAgents);
        newRemovals = zeros(1, Params.numAgents);
        for ii = 1: Params.numAgents
            [allocations(ii), newInclusions(ii)] = taskInclusion(Params, allocations(ii), agents(ii), tasks);
        end
        for ii = 1: Params.numAgents
            for jj = 1: Params.numAgents
                if G(ii, jj)
                    [allocations(jj), newRemovals(jj)] = consensus(Params, allocations(jj), jj, allocations(ii), ii, agents(jj), tasks);
                end
            end
        end
        iterations = iterations + 1;
        if sum(newInclusions) + sum(newRemovals) == 0
            unChanged = unChanged + 1;
        else
            unChanged = 0;
        end
        if unChanged >= Params.numAgents
            converged = 1;
            iterations = iterations - Params.numAgents;
        end
    end
end