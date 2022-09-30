function insertedAllocation = insertInAllocation(allocation, agent, tasks, taskID, insPos)
    % insert task taskID at insPos in the allocation
    taskPath = genTaskPath(allocation, agent, tasks);
    insertedTaskPath = [taskPath(1: insPos - 1), taskID, taskPath(insPos: end)];
    insertedAllocation = allocation;
    
    % update the local start time of tasks in the inserted allocation
    insertedAllocation.timeTable(agent.id, insertedTaskPath(1)) = norm(agent.position - tasks(insertedTaskPath(1)).position) / agent.speed;
    currentTime = calGlobalStartTime(insertedAllocation, agent, insertedTaskPath(1), tasks);
    for ii = 2: length(insertedTaskPath)
        taskCurr = tasks(insertedTaskPath(ii));
        taskPrev = tasks(insertedTaskPath(ii - 1));
        insertedAllocation.timeTable(agent.id, taskCurr.id) = currentTime + taskPrev.duration + norm(taskCurr.position - taskPrev.position) / agent.speed;
        currentTime = calGlobalStartTime(insertedAllocation, agent, taskCurr.id, tasks);
    end
end