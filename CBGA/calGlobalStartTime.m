function globalStartTime = calGlobalStartTime(allocation, agent, taskID, tasks)
    coAgents = find(allocation.timeTable(:, taskID) > 0);
    if length(coAgents) <= tasks(taskID).numAgents
        globalStartTime = max(allocation.timeTable(coAgents, taskID));
    else
        while length(coAgents) > tasks(taskID).numAgents
            [~, idx] = max(allocation.timeTable(coAgents, taskID));
            coAgents(idx) = [];
        end
        if sum(coAgents == agent.id) > 0
            globalStartTime = max(allocation.timeTable(coAgents, taskID));
        else
            globalStartTime = allocation.timeTable(agent.id, taskID);
        end
    end
end