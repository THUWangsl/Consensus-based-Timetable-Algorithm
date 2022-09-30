function taskPath = genTaskPath(allocation, agent, tasks)
    selfTasks = find(allocation.timeTable(agent.id, :) > 0);
    globalStart = zeros(1, length(selfTasks));
    for ii = 1: length(selfTasks)
        taskID = selfTasks(ii);
        coAgents = find(allocation.timeTable(:, taskID) > 0);
        coStarts = allocation.timeTable(coAgents, taskID);
        if length(coAgents) <= tasks(taskID).numAgents
            globalStart(ii) = max(coStarts);
        else
            while length(coAgents) > tasks(taskID).numAgents
                [~, idx] = max(allocation.timeTable(coAgents, taskID));
                coAgents(idx) = [];
            end
            if sum(coAgents == agent.id) > 0
                globalStart(ii) = max(allocation.timeTable(coAgents, taskID));
            else
                globalStart(ii) = allocation.timeTable(agent.id, taskID);
            end
        end
    end
    [~, idx] = sort(globalStart);
    taskPath = selfTasks(idx);
end