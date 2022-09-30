function totalScore = calTotalScore(taskPath, agent, tasks)
    lenTaskPath = find(taskPath == -1, 1) - 1;
    taskDistance = zeros(1, lenTaskPath);
    if lenTaskPath > 0
        taskCurr = tasks(taskPath(1));
        taskDistance(1) = norm(agent.position - taskCurr.position) / agent.speed;
        for ii = 2: lenTaskPath
            taskCurr = tasks(taskPath(ii));
            taskPrev = tasks(taskPath(ii - 1));
            taskDistance(ii) = taskDistance(ii - 1) + norm(taskCurr.position - taskPrev.position) / agent.speed + taskPrev.duration;
%             taskDistance(ii) = norm(taskCurr.position - taskPrev.position);
        end
    end
    totalScore = 0;
    for ii = 1: lenTaskPath
        taskCurr = tasks(taskPath(ii));
        totalScore = totalScore + taskCurr.reward - taskDistance(ii) - taskCurr.duration;
    end
end