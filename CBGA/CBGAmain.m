% clear
% numTasks = 10;
% numAgents = 4;
% worldDimension = 2;
% worldMax = 1000;
% 
% agentDefault.ID = 0;
% agentDefault.position = zeros(1, worldDimension);
% 
% taskDefault.ID = 0;
% taskDefault.position = zeros(1, worldDimension);
% taskDefault.numAgents = 0;
% taskDefault.duration = 0;
% taskDefault.reward = 0;
% 
% allocationDefault.bundle = -1 * ones(1, numTasks + 1);
% allocationDefault.taskPath = -1 * ones(1, numTasks + 1);
% allocationDefault.timeStamp = zeros(1, numAgents);
% allocationDefault.winners = zeros(1, numTasks);
% allocationDefault.winnerBids = zeros(1, numTasks);
% allocationDefault.assignMatrix = zeros(numAgents, numTasks);
% 
% agents = repmat(agentDefault, [1, numAgents]);
% for ii = 1: numAgents
%     agents(ii).ID = ii;
%     agents(ii).position = worldMax * rand(1, worldDimension);
% end
% 
% tasks = repmat(taskDefault, [1, numTasks]);
% for ii = 1: numTasks
%     tasks(ii).ID = ii;
%     tasks(ii).position = worldMax * rand(1, worldDimension);
%     tasks(ii).numAgents = 1;
%     tasks(ii).duration = 300 * rand;
%     tasks(ii).reward = 2000 + 2000 * rand;
% end

% clear;clc;
% numTasks = 10;
% numAgents = 4;
% pltfig = 0;
% 
% taskDefault.id = 0;
% taskDefault.reward = 0;
% taskDefault.position = zeros(1, 2);
% taskDefault.scoreFactor = 0;
% taskDefault.duration = 0;
% taskDefault.numAgents = 2;
% 
% agentDefault.id = 0;
% agentDefault.position = zeros(1, 2);
% agentDefault.speed = 0;
% % agentDefault.maxAlloc = 0;
% 
% world.xMax = 10000;
% world.yMax = 10000;
numTasks = Params.numTasks;
numAgents = Params.numAgents;
for ii = 1: numTasks
    tasks(ii).reward = 1E6;
    tasks(ii).ID = tasks(ii).id;
end
for ii = 1: numAgents
    agents(ii).ID = agents(ii).id;
end
allocationDefault.bundle = -1 * ones(1, numTasks + 1);
allocationDefault.taskPath = -1 * ones(1, numTasks + 1);
allocationDefault.timeStamp = zeros(1, numAgents);
allocationDefault.winners = zeros(1, numTasks);
allocationDefault.winnerBids = zeros(1, numTasks);
allocationDefault.assignMatrix = zeros(numAgents, numTasks);

% tasks = repmat(taskDefault, [1, numTasks]);
% for ii = 1:numTasks
%     tasks(ii).id = ii;
%     tasks(ii).reward = 50000 + 5000 * rand;
%     tasks(ii).position(1) = world.xMax * rand;
%     tasks(ii).position(2) = world.yMax * rand;
%     tasks(ii).scoreFactor = 0.001;
%     tasks(ii).duration = 50 + 50 * rand;
% %     tasks(ii).numAgents = randi(2);
% end
% 
% agents = repmat(agentDefault, [1, numAgents]);
% for ii = 1:numAgents
%     agents(ii).id = ii;
%     agents(ii).ID = ii;
%     agents(ii).position(1) = world.xMax * rand;
%     agents(ii).position(2) = world.yMax * rand;
%     agents(ii).speed = 10 + 10 * rand;
% %     agents(ii).maxAlloc = 4 + randi(3);
% end


allocations = repmat(allocationDefault, [1, numAgents]);
Graph = ~eye(numAgents);

converge = 0;
iter = 1;
while ~converge
    newInclusion = zeros(1, numAgents);
    newRemoval = zeros(1, numAgents);
    for ii = 1: numAgents
        [allocations(ii), newInclusion(ii)] = buildBundle(allocations(ii), agents(ii), tasks);
    end
    for ii = 1: numAgents
        for jj = 1: numAgents
            if Graph(ii, jj) == 1
                allocations(jj) = duoConsensus(allocations(jj), jj, allocations(ii), ii, tasks);
            end
        end
    end
    for ii = 1: numAgents
        [allocations(ii), newRemoval(ii)] = taskRemoval(allocations(ii), agents(ii));
    end
    if sum(newInclusion) + sum(newRemoval) == 0
        convege = 1;
        break;
    end
    iter = iter + 1;
end

[timeTable, converge] = genTimeTable(Params, allocations, agents, tasks);
tmpAllocations = allocations;
for ii = 1: Params.numAgents
    tmpAllocations(ii).timeTable = timeTable;
end
plotCoAllocations(Params, tmpAllocations, agents, tasks)

