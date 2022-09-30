function plotAllocations(Params, allocations, agents, tasks)
    % set plotting paramters
    set(0, 'DefaultAxesFontSize', 20)
    set(0, 'DefaultTextFontSize', 20, 'DefaultTextFontWeight', 'demi')
    set(0, 'DefaultAxesFontName', 'Times New Roman')
    set(0, 'DefaultTextFontName', 'Times New Roman')
    set(0, 'DefaultLineLineWidth', 2); % < == very important
    set(0, 'DefaultlineMarkerSize', 10)
    
    figure
    % plot the agents' time schedule
    subplot(Params.numAgents, 1, 1);
    title('Agents Time Schedule')
    subplot(Params.numAgents, 1, Params.numAgents);
    
    if Params.numTasks > 12
        Cmap = colormap('lines');
    else
        cmap1 = colormap('lines');
        cmap2 = colormap('prism');
        Cmap = [cmap1(1: 6, :); cmap2(1:6, :)];
    end
    for ii = 1: Params.numAgents
        subplot(Params.numAgents, 1, ii);
        hold on
        ylabel(['a' num2str(ii)]);
        grid on
        box on
        axis([0 2000 0 2])
        yticks([])
        taskPath = genTaskPath(allocations(ii), agents(ii), tasks);
        for jj = 1: length(taskPath)
            taskID= taskPath(jj);
            coAgents = find(allocations(ii).timeTable(:, taskID) > 0);
            realStartTime = max(allocations(ii).timeTable(coAgents, taskID));
            if length(coAgents) == tasks(taskID).numAgents
                plot([realStartTime, realStartTime + tasks(taskID).duration], [0.7, 0.7], 'color', Cmap(taskID, :), 'LineWidth', 10);
                plot([allocations(ii).timeTable(ii, taskID), realStartTime], [0.7, 0.7], '--', 'color', Cmap(taskID, :), 'LineWidth', 2.0);
                text([realStartTime + tasks(taskID).duration/ 2], [1.5], ['t_{' num2str(taskID) '}']);
            else
                plot([realStartTime, realStartTime + tasks(taskID).duration], [1, 1], 'k-', 'LineWidth', 10);
                plot([allocations(ii).timeTable(ii, taskID), realStartTime], [1, 1], 'k--', 'LineWidth', 2.0);
                text([realStartTime + tasks(taskID).duration/ 2], [1.5], ['t_{' num2str(taskID) '}']);
            end
        end
    end
end