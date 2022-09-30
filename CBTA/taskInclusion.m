function [allocation, newInclusion] = taskInclusion(Params, allocation, agent, tasks)
    newInclusion = 0;
    taskPath = genTaskPath(allocation, agent, tasks);
    while length(taskPath) < Params.upperLimit
        marginalCost =- Params.numAgents * Params.infty * ones(1, Params.numTasks);
        insertedPos = zeros(1, Params.numTasks);
        % calculate the marginal cost of each task
        for ii = 1:Params.numTasks
            % a task is said to be a candidate if the task is not already in the task path and the number of removal
            % of this task by this agent is less than the set removal times
            if sum(taskPath == ii) == 0 && allocation.numRm(ii) < Params.maxRm
%             if sum(taskPath == ii) == 0
                localMarginalCost =- Params.numAgents * Params.infty * ones(1, length(taskPath) + 1);
                % for each position that task ii could be inserted at the task path
                for jj = 1:length(taskPath) + 1
                    insertedAllocation = insertInAllocation(allocation, agent, tasks, ii, jj);
                    insertedTaskPath = genTaskPath(insertedAllocation, agent, tasks);
                    tmpPath = [taskPath(1:jj - 1), ii, taskPath(jj:end)];
                    if length(tmpPath) == length(insertedTaskPath)
                        if sum(tmpPath == insertedTaskPath) == length(tmpPath)
                            totalScore = calTotalScore(Params, allocation, agent, tasks);
                            insertTotalScore = calTotalScore(Params, insertedAllocation, agent, tasks);
                            localMarginalCost(jj) =  totalScore - insertTotalScore;
                        end
                    end
                end
                [marginalCost(ii), insertedPos(ii)] = max(localMarginalCost);
            end
        end

        % select the maximum marginal cost
        [maxMarginalCost, taskID] = max(marginalCost);
        insPos = insertedPos(taskID);
        if maxMarginalCost >= 0
%             allocation = insertInAllocation(allocation, agent, tasks, taskID, insPos);
%             taskPath = genTaskPath(allocation, agent, tasks);
%             newInclusion = 1;
%         elseif maxMarginalCost == 0
            insertedAllocation = insertInAllocation(allocation, agent, tasks, taskID, insPos);
            coAgents = find(insertedAllocation.timeTable(:, taskID) > 0);
            while length(coAgents) > tasks(taskID).numAgents
                [~, idx] = max(insertedAllocation.timeTable(coAgents, taskID));
                coAgents(idx) = [];
            end
            if sum(coAgents == agent.id) > 0
                allocation = insertedAllocation;
                taskPath = genTaskPath(allocation, agent, tasks);
%                 allocation.bundle(length(taskPath)) = taskID;
                newInclusion = 1;
            else
                break;
            end
        else
            break;
        end
    end
end
