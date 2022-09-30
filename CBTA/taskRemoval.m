function [allocation, newRemoval] = taskRemoval(Params, allocation, agent, tasks)
    newRemoval = 0;
    for jj = 1: Params.numTasks
        coAgents = find(allocation.timeTable(:, jj) > 0);
        while length(coAgents) > tasks(jj).numAgents
            [~, idx] = max(allocation.timeTable(coAgents, jj));
            allocation.timeTable(coAgents(idx), jj) = 0;
            if coAgents(idx) == agent.id
                allocation.numRm(jj) = allocation.numRm(jj) + 1;
                newRemoval = 1;
            end
            coAgents(idx) = [];
        end
    end
    if Params.maxNumAgents > 1
        [allocation] = updateTaskPath(allocation, agent, tasks);
    end
end