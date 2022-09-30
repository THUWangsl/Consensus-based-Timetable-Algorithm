function allocation = consensus(recAllocation, recID, senAllocation, senID)
    eps = 1E-6;
    senderkWinners = senAllocation.winners;
    senderkWinnerBids = senAllocation.winnerBids;
    senderkTimeStamp = senAllocation.timeStamp;
    senderkID = senID;

    receiveriWinners = recAllocation.winners;
    receiveriWinnerBids = recAllocation.winnerBids;
    receiveriTimeStamp = recAllocation.timeStamp;
    receiveriID = recID;

    recWinners = receiveriWinners;
    recWinnerBids = receiveriWinnerBids;

    numTasks = length(recAllocation.winners);


    for jj = 1: numTasks
        action = 0;             % 1: update 2: leave 3: reset
        % Entry 1-4
        if senderkWinners(jj) == senderkID
            if receiveriWinners(jj) == receiveriID
                if senderkWinnerBids(jj) > receiveriWinnerBids(jj)
                    % update here
                    action = 1;
                elseif abs(senderkWinnerBids(jj) - receiveriWinnerBids(jj)) < eps 
                    if senderkID < receiveriID
                        action = 1;
                    end
                end
            elseif receiveriWinners(jj) == senderkID
                action = 1;
            elseif receiveriWinners(jj) > 0
                m = receiveriWinners(jj);
                if senderkTimeStamp(m) > receiveriTimeStamp(m)
                    action = 1;
                end
                if senderkWinnerBids(jj) > receiveriWinnerBids(jj)
                    % update here
                    action = 1;
                elseif abs(senderkWinnerBids(jj) - receiveriWinnerBids(jj)) < eps 
                    if senderkID < receiveriID
                        action = 1;
                    end
                end
            elseif receiveriWinners(jj) == 0
                action = 1;
            end
        elseif senderkWinners(jj) == receiveriID
            if receiveriWinners(jj) == receiveriID
                action = 2;
            elseif receiveriWinners(jj) == senderkID
                action = 3;
            elseif receiveriWinners(jj) > 0
                m = receiveriWinners(jj);
                if senderkTimeStamp(m) > receiveriTimeStamp(m)
                    action = 3;
                end
            elseif receiveriWinners(jj) == 0
                action = 2;
            end
        elseif senderkWinners(jj) > 0
            m = senderkWinners(jj);
            if receiveriWinners(jj) == receiveriID
                if senderkTimeStamp(m) > receiveriTimeStamp(m)
                    if senderkWinnerBids(jj) > receiveriWinnerBids(jj)
                        % update here
                        action = 1;
                    elseif abs(senderkWinnerBids(jj) - receiveriWinnerBids(jj)) < eps 
                        if senderkID < receiveriID
                            action = 1;
                        end
                    end
                end
            elseif receiveriWinners(jj) == senderkID
                if senderkTimeStamp(m) > receiveriTimeStamp(m)
                    action = 1;
                else
                    action = 3;
                end
            elseif receiveriWinners(jj) > 0
                n = receiveriWinners(jj);
                if senderkTimeStamp(m) > receiveriTimeStamp(m)
                    if senderkTimeStamp(n) > receiveriTimeStamp(n)
                        action = 1;
                    end
                    if senderkWinnerBids(jj) > receiveriWinnerBids(jj)
                        % update here
                        action = 1;
                    elseif abs(senderkWinnerBids(jj) - receiveriWinnerBids(jj)) < eps 
                        if senderkID < receiveriID
                            action = 1;
                        end
                    end
                end
                if senderkTimeStamp(n) > receiveriTimeStamp(n)
                    if senderkTimeStamp(m) < receiveriTimeStamp(m)
                        action = 3;
                    end
                end
            elseif receiveriWinners(jj) == 0
                if senderkTimeStamp(m) > receiveriTimeStamp(m)
                    action = 1;
                end
            end
        elseif senderkWinners(jj) == 0
            if receiveriWinners(jj) == receiveriID
                action = 2;
            elseif receiveriWinners(jj) == senderkID
                action = 1;
            elseif receiveriWinners(jj) > 0
                m = receiveriWinners(jj);
                if senderkTimeStamp(m) > receiveriTimeStamp(m)
                    action = 1;
                end
            elseif receiveriWinners(jj) == 0
                action = 2;
            end
        end
        
        if action == 1
            recWinners(jj) = senderkWinners(jj);
            recWinnerBids(jj) = senderkWinnerBids(jj);
        elseif action == 3
            recWinners(jj) = 0;
            recWinnerBids(jj) = 0;
        end
    end
    
    allocation = recAllocation;
    allocation.winnerBids = recWinnerBids;
    allocation.winners = recWinners;
    for ii = 1: length(recAllocation.timeStamp)
        if senAllocation.timeStamp(ii) > allocation.timeStamp(ii)
            allocation.timeStamp(ii) = senAllocation.timeStamp(ii);
        end
    end

%     allocation.timeStamp = recTimeStamp;
    % allocation.timeStamp(senID) = Iteration;
end