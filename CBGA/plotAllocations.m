function startTimes = plotAllocations(Params, allocations, agents, tasks)
    % set plotting paramters
    set(0, 'DefaultAxesFontSize', 16)
    set(0, 'DefaultTextFontSize', 20, 'DefaultTextFontWeight', 'demi')
    set(0, 'DefaultAxesFontName', 'Times New Roman')
    set(0, 'DefaultTextFontName', 'Times New Roman')
    set(0, 'DefaultLineLineWidth', 2); % < == very important
    set(0, 'DefaultlineMarkerSize', 10)

    % the agents' time schedule
    figure
    subplot(Params.numAgents, 1, 1);
    title('Agents Time Schedule')
    subplot(Params.numAgents, 1, Params.numAgents);
    cmap1 = colormap('lines');
    cmap2 = colormap('prism');
%     Cmap = [cmap1(1: 6, :); cmap2(1:6, :)];
    Cmap = cmap1;
    startTimes = zeros(1, Params.numTasks);
    for ii = 1: length(agents)
        subplot(length(agents), 1, ii);
        hold on
        ylabel(['A' num2str(ii)]);
        grid on
        axis([0 2500 0 2])
        taskPath = allocations(ii).taskPath;
        realStartTime = 0;
        lenTaskPath = find(taskPath == -1, 1) - 1;
        for jj = 1: lenTaskPath
            if jj == 1
                realStartTime = norm(agents(ii).position - tasks(taskPath(jj)).position) / agents(ii).speed;
            else
                taskCurr = tasks(taskPath(jj));
                taskPrev = tasks(taskPath(jj - 1));
                realStartTime = realStartTime + taskPrev.duration + norm(taskCurr.position - taskPrev.position) / agents(ii).speed;
            end
            taskID = taskPath(jj);
            startTimes(taskID) = realStartTime;
            plot([realStartTime, realStartTime + tasks(taskID).duration], [1, 1], 'color', Cmap(taskID, :), 'LineWidth', 10);
            text([realStartTime + tasks(taskID).duration/ 2], [1.5], ['t_{' num2str(taskID) '}']);
        end
    end

end