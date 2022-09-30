function [taskPath, globalStart] = genTaskPath(allocation, agent, tasks)
    selfTasks = find(allocation.timeTable(agent.id, :) > 0);
    globalStart = zeros(1, length(selfTasks));
    for ii = 1: length(selfTasks)
        taskID = selfTasks(ii);
        coAgents = find(allocation.timeTable(:, taskID) > 0);
        coStarts = allocation.timeTable(coAgents, taskID);
        if length(coAgents) <= tasks(taskID).numAgents
            globalStart(ii) = max(coStarts);
        else
            [sortCoStarts, sortIdx] = sort(coStarts);
            agentIDs = coAgents(sortIdx(1: tasks(selfTasks(ii)).numAgents));
            if sum(agentIDs == agent.id) > 0
                globalStart(ii) = sortCoStarts(tasks(selfTasks(ii)).numAgents);
            else
                globalStart(ii) = allocation.timeTable(agent.id, selfTasks(ii));
            end
        end
    end
    [globalStart, idx] = sort(globalStart);
    taskPath = selfTasks(idx);
end