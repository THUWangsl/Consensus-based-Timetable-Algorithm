function [allocation, newBids] = buildBundle(allocation, agent, tasks)
    newBids = 0;
    numTasks = length(tasks);
    taskPath = allocation.taskPath;
    lenTaskPath = find(taskPath == -1, 1) - 1;

    while lenTaskPath < length(tasks)
        marginalScore = zeros(1, numTasks);
        insPos = zeros(1, numTasks);
        totalScore = calTotalScore(taskPath, agent, tasks);
        for ii = 1:numTasks
            if sum(taskPath == ii) == 0
                tmpScore = zeros(1, lenTaskPath + 1);
                for jj = 1:lenTaskPath + 1
                    insTaskPath = [taskPath(1:jj - 1), ii, taskPath(jj:end - 1)];
                    insTotalScore = calTotalScore(insTaskPath, agent, tasks);
                    tmpScore(jj) = insTotalScore - totalScore;
                end
                [marginalScore(ii), insPos(ii)] = max(tmpScore);
            end
        end
        comp = zeros(1, numTasks);
        for ii = 1:numTasks
            scores = allocation.assignMatrix(:, ii);
            scores(find(scores == 0)) = [];
            if tasks(ii).numAgents > 1
                if tasks(ii).numAgents > length(scores)
                    comp(ii) = 1;
                elseif marginalScore(ii) > min(scores)
                    comp(ii) = 1;
                end
            else
                if marginalScore(ii) > sum(scores)
                    comp(ii) = 1;
                end
            end
        end

        [maxMarginalScore, maxTaskID] = max(comp .* marginalScore);
        insP = insPos(maxTaskID);
        if maxMarginalScore > 0
            allocation.bundle(lenTaskPath + 1) = maxTaskID;
            allocation.taskPath = [taskPath(1:insP - 1), maxTaskID, taskPath(insP:end - 1)];
            allocation.assignMatrix(agent.ID, maxTaskID) = maxMarginalScore;
            taskPath = allocation.taskPath;
            lenTaskPath = lenTaskPath + 1;
            newBids = 1;
        else
            break;
        end
    end
    for ii = 1: numTasks
        while sum(allocation.assignMatrix(:, ii) > 0) > tasks(ii).numAgents
            coAgents = find(allocation.assignMatrix(:, ii) > 0);
            [~, idx] = min(allocation.assignMatrix(coAgents, ii));
            allocation.assignMatrix(coAgents(idx), ii) = 0;
        end
    end
end
