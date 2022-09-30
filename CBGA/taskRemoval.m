function [allocation, newBids] = taskRemoval(allocation, agent)
    newBids = 0;
    lenBundle = find(allocation.bundle == -1, 1) - 1;
    outBidIdx = 0;
    for ii = 1: lenBundle
        if allocation.assignMatrix(agent.ID, allocation.bundle(ii)) == 0
            outBidIdx = ii;
            break;
        end
    end
    if outBidIdx > 0
        outBidTasks = allocation.bundle(outBidIdx: lenBundle);
        for outBidTask = outBidTasks(2: end)
            allocation.bundle(find(allocation.bundle == outBidTask)) = [];
            allocation.bundle = [allocation.bundle, -1];
            allocation.taskPath(find(allocation.taskPath == outBidTask)) = [];
            allocation.taskPath = [allocation.taskPath, -1];
            allocation.assignMatrix(agent.ID, outBidTask) = 0;
            newBids = 1;
        end
        allocation.taskPath(find(allocation.taskPath == allocation.bundle(outBidIdx))) = [];
        allocation.taskPath = [allocation.taskPath, -1];
        allocation.bundle(outBidIdx) = [];
        allocation.bundle = [allocation.bundle, -1];
    end
end