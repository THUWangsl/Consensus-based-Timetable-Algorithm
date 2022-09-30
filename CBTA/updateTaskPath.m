function [allocation, newRemoval, taskPath] = updateTaskPath(allocation, agent, tasks)
newRemoval = 0;
[taskPath] = genTaskPath(allocation, agent, tasks);
numSelfTasks = length(taskPath);

for ii = 1: numSelfTasks
    taskID = taskPath(ii);
    if ii == 1
        allocation.timeTable(agent.id, taskID) = norm(agent.position - tasks(taskID).position) / agent.speed;
        currentTime = calGlobalStartTime(allocation, agent, taskID, tasks);
    else
        taskCurr = tasks(taskID);
        taskPrev = tasks(taskPath(ii - 1));
        allocation.timeTable(agent.id, taskID) = currentTime + taskPrev.duration + norm(taskCurr.position - taskPrev.position) / agent.speed;
        currentTime = calGlobalStartTime(allocation, agent, taskID, tasks);
    end
end

end