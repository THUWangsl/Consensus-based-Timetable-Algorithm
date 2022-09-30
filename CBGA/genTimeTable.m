function [timeTable, converge] = genTimeTable(Params, allocations, agents, tasks)
    timeTable = zeros(Params.numAgents, Params.numTasks);
    unChanged = 0;
    iter = 0;
    while 1
        oldTimeTable = timeTable;
        for ii = 1: Params.numAgents
            taskPath = allocations(ii).taskPath;
            lenTaskPath = find(taskPath == -1, 1) - 1;
            for jj = 1: lenTaskPath
                taskCurr = tasks(taskPath(jj));
                if jj == 1
                    timeTable(ii, taskCurr.id) = norm(agents(ii).position - taskCurr.position) / agents(ii).speed;
                else
                    taskPrev = tasks(taskPath(jj - 1));
                    globalStartPrev = max(timeTable(:, taskPrev.id));
                    timeTable(ii, taskCurr.id) = globalStartPrev + taskPrev.duration + norm(taskCurr.position - taskPrev.position) / agents(ii).speed;
                end
            end
        end
        if sum(sum(oldTimeTable == timeTable)) == Params.numTasks * Params.numAgents
            converge = 1;
            break;
        end
        iter = iter + 1;
        if iter > 2 * Params.numTasks
            converge = 0;
            break;
        end
    end
end