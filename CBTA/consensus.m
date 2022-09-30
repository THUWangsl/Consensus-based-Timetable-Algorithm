function [allocation, newRemoval] = consensus(Params, recAllocation, recID, senAllocation, senID, recAgent, tasks)
    for ii = 1:Params.numAgents
        if ii == senID
            recAllocation.timeTable(ii, :) = senAllocation.timeTable(ii, :);
        elseif ii == recID
        elseif senAllocation.timeStamp(ii) > recAllocation.timeStamp(ii)
            recAllocation.timeTable(ii, :) = senAllocation.timeTable(ii, :);
        end
    end
    allocation = recAllocation;

    newRemoval = 0;
    for jj = 1:Params.numTasks
        coAgents = find(allocation.timeTable(:, jj) > 0);
        while length(coAgents) > tasks(jj).numAgents
            [~, idx] = max(allocation.timeTable(coAgents, jj));
            allocation.timeTable(coAgents(idx), jj) = 0;
            if coAgents(idx) == recAgent.id
                allocation.numRm(jj) = allocation.numRm(jj) + 1;
                newRemoval = 1;
            end
            coAgents(idx) = [];
        end
    end

    [taskPath] = genTaskPath(allocation, recAgent, tasks);
    for ii = 1:length(taskPath)
        taskID = taskPath(ii);
        if ii == 1
            allocation.timeTable(recAgent.id, taskID) = norm(recAgent.position - tasks(taskID).position) / recAgent.speed;
            currentTime = calGlobalStartTime(allocation, recAgent, taskID, tasks);
        else
            taskCurr = tasks(taskID);
            taskPrev = tasks(taskPath(ii - 1));
            allocation.timeTable(recAgent.id, taskID) = currentTime + taskPrev.duration + norm(taskCurr.position - taskPrev.position) / recAgent.speed;
            currentTime = calGlobalStartTime(allocation, recAgent, taskID, tasks);
        end
    end

    for ii = 1:Params.numAgents
        if senAllocation.timeStamp(ii) > allocation.timeStamp(ii)
            allocation.timeStamp(ii) = senAllocation.timeStamp(ii);
        end
    end
    allocation.timeStamp(senID) = allocation.timeStamp(senID) + 1;
end
