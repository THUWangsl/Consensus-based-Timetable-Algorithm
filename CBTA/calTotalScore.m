function totalScore = calTotalScore(Params, allocation, agent, tasks)
    startTime = zeros(1, Params.numTasks);
    for ii = 1:Params.numTasks
        if sum(allocation.timeTable(:, ii) > 0) <= tasks(ii).numAgents
            startTime(ii) = Params.infty * (tasks(ii).numAgents - sum(allocation.timeTable(:, ii) > 0)) + max(allocation.timeTable(:, ii));
        else
            startTime(ii) = calGlobalStartTime(allocation, agent, tasks(ii).id, tasks);
        end
    end
    totalScore = sum(startTime);
end
