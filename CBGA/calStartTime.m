function timeTable = calStartTime(allocations, agents, tasks)
    numAgents = length(agents);
    numTasks = length(tasks);
    timeTable = zeros(numAgents, numTasks);
    for ii = 1: numAgents
        taskPath = allocations(ii).taskPath;
        lenTaskPath = find(taskPath == -1, 1) - 1;
        if lenTaskPath > 0
            timeTable(ii, taskPath(1)) = norm(tasks(taskPath(1)).position - agents(ii).position) / agents(ii).speed;
            for jj = 2: lenTaskPath
                taskPrev = taskPath(jj - 1);
                timeTable(ii, taskPath(jj)) = timeTable(ii, taskPrev) + tasks(taskPrev).duration + norm(tasks(taskPath(jj)).position - tasks(taskPrev).position) / agents(ii).speed;
            end
        end
    end
    oldTimeTable = zeros(numAgents, numTasks);
    while sum(sum(abs(oldTimeTable - timeTable))) >0.01
        oldTimeTable = timeTable;
        for ii = 1: numAgents
            taskPath = allocations(ii).taskPath;
            lenTaskPath = find(taskPath == -1, 1) - 1;
            if lenTaskPath > 0
                timeTable(ii, taskPath(1)) = max(timeTable(:, taskPath(1)));
                for jj = 2: lenTaskPath
                    taskPrev = taskPath(jj - 1);
                    tmpStart = timeTable(ii, taskPrev) + tasks(taskPrev).duration + norm(tasks(taskPath(jj)).position - tasks(taskPrev).position) / agents(ii).speed;
                    tmpStart1 = max(timeTable(:, taskPath(jj)));
                    timeTable(ii, taskPath(jj)) = max(tmpStart, tmpStart1);
                end
            end
        end
    end
    % assignedTasks = 1: numTasks;
    % currentTime = zeros(1, numAgents);
    % while ~isempty(assignedTasks)
    % for ii = 1: numAgents
    %     taskPath = allocation.taskPath(ii);
    %     for jj = 1: length(taskPath)
    %         taskID = taskPath(jj);
    %         coAgents = find(assignMatrix(:, taskID) > 0);
    %         tStart = zeros(1, length(coAgents));
    %         for kk = 1: length(coAgents)
    %             if jj == 1
    %                 dis = norm(agents(coAgents(ii)))
    %             else
    %             end
    %             tStart(kk) = currentTime(coAgents(kk)) + %移动时间% + %前一任务的执行时�?%
    %     end
    % end
end