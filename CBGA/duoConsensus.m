function allocation = duoConsensus(recAllocation, recID, senAllocation, senID, tasks)
eps = 1e-9;
allocation = recAllocation;

recAssignMatrix = recAllocation.assignMatrix;
recTimeStamp = recAllocation.timeStamp;
senAssignMatrix = senAllocation.assignMatrix;
senTimeStamp = senAllocation.timeStamp;

numTasks = length(tasks);
for jj = 1:numTasks
    if tasks(jj).numAgents == 1
        % consensus with CBBA rules here
        if sum(senAssignMatrix(:, jj)) == 0
            senWinner = 0;
            senWinnerBids = 0;
        else
            senWinner = find(senAssignMatrix(:, jj) > 0);
            senWinnerBids = senAssignMatrix(senWinner, jj);
        end
        
        if sum(recAssignMatrix(:, jj)) == 0
            recWinner = 0;
            recWinnerBids = 0;
        else
            recWinner = find(recAssignMatrix(:, jj) > 0);
            recWinnerBids = recAssignMatrix(recWinner, jj);
        end
        
        action = 0; % 1: update 2: leave 3: reset
        % Entry 1-4
        if senWinner == senID
            if recWinner == recID
                if senWinnerBids > recWinnerBids
                    % update here
                    action = 1;
                elseif abs(senWinnerBids - recWinnerBids) < eps
                    if senID < recID
                        action = 1;
                    end
                end
            elseif recWinner == senID
                action = 1;
            elseif recWinner > 0
                m = recWinner;
                if senTimeStamp(m) > recTimeStamp(m)
                    action = 1;
                end
                if senWinnerBids > recWinnerBids
                    % update here
                    action = 1;
                elseif abs(senWinnerBids - recWinnerBids) < eps
                    if senID < recID
                        action = 1;
                    end
                end
            elseif recWinner == 0
                action = 1;
            end
        elseif senWinner == recID
            if recWinner == recID
                action = 2;
            elseif recWinner == senID
                action = 3;
            elseif recWinner > 0
                m = recWinner;
                if senTimeStamp(m) > recTimeStamp(m)
                    action = 3;
                end
            elseif recWinner == 0
                action = 2;
            end
        elseif senWinner > 0
            m = senWinner;
            if recWinner == recID
                if senTimeStamp(m) > recTimeStamp(m)
                    if senWinnerBids > recWinnerBids
                        % update here
                        action = 1;
                    elseif abs(senWinnerBids - recWinnerBids) < eps
                        if senID < recID
                            action = 1;
                        end
                    end
                end
            elseif recWinner == senID
                if senTimeStamp(m) > recTimeStamp(m)
                    action = 1;
                else
                    action = 3;
                end
            elseif recWinner > 0
                n = recWinner;
                if senTimeStamp(m) > recTimeStamp(m)
                    if senTimeStamp(n) > recTimeStamp(n)
                        action = 1;
                    end
                    if senWinnerBids > recWinnerBids
                        % update here
                        action = 1;
                    elseif abs(senWinnerBids - recWinnerBids) < eps
                        if senID < recID
                            action = 1;
                        end
                    end
                end
                if senTimeStamp(n) > recTimeStamp(n)
                    if senTimeStamp(m) < recTimeStamp(m)
                        action = 3;
                    end
                end
            elseif recWinner == 0
                if senTimeStamp(m) > recTimeStamp(m)
                    action = 1;
                end
            end
        elseif senWinner == 0
            if recWinner == recID
                action = 2;
            elseif recWinner == senID
                action = 1;
            elseif recWinner > 0
                m = recWinner;
                if senTimeStamp(m) > recTimeStamp(m)
                    action = 1;
                end
            elseif recWinner == 0
                action = 2;
            end
        end
        
        if action == 1                  % update
            recAssignMatrix(:, jj) = senAssignMatrix(:, jj);
        elseif action == 3              % reset
            recAssignMatrix(recWinner, jj) = 0;
        end
    else
%         % first of all, merge the sender's information
%         for mm = 1: size(recAssignMatrix, 1) - 1
%             if mm == senID || senTimeStamp(mm) > recTimeStamp(mm)
%                 recAssignMatrix(mm, jj) = senAssignMatrix(mm, jj);
%             end
%         end
%         coAgents = find(recAssignMatrix(:, jj) > 0);
%         while length(coAgents) > tasks(jj).numAgents
%             [~, idx] = min(recAssignMatrix(coAgents, jj));
%             recAssignMatrix(coAgents(idx), jj) = 0;
%             coAgents = find(recAssignMatrix(:, jj) > 0);
%         end
        % update the information that the receiver already knows
        recCoAgents = find(recAssignMatrix(:, jj) > 0);
        senCoAgents = find(senAssignMatrix(:, jj) > 0);
        for mm = 1: size(recAssignMatrix, 1)
            recCoAgent = mm;
            if senID == recCoAgent || senTimeStamp(recCoAgent) > recTimeStamp(recCoAgent) && recCoAgent ~= recID
                recAssignMatrix(recCoAgent, jj) = senAssignMatrix(recCoAgent, jj);
            end
        end
        for mm = 1: length(senCoAgents)
            senCoAgent = senCoAgents(mm);
            if senCoAgent ~= recID && recAssignMatrix(senCoAgent, jj) == 0 && senTimeStamp(senCoAgent) > recTimeStamp(senCoAgent)
                if length(recCoAgents) < tasks(jj).numAgents
                    recAssignMatrix(senCoAgent, jj) = senAssignMatrix(senCoAgent, jj);
                elseif min(recAssignMatrix(recCoAgents, jj)) < senAssignMatrix(senCoAgent, jj)
                    [~, idx] = min(recAssignMatrix(recCoAgents, jj));
                    recAssignMatrix(recCoAgents(idx), jj) = 0;
                    recAssignMatrix(senCoAgent, jj) = senAssignMatrix(senCoAgent, jj);
                elseif min(recAssignMatrix(recCoAgents, jj)) < senAssignMatrix(senCoAgent, jj)
                    if senCoAgent < recID
                        [~, idx] = min(recAssignMatrix(recCoAgents, jj));
                        recAssignMatrix(recCoAgents(idx), jj) = 0;
                        recAssignMatrix(senCoAgent, jj) = senAssignMatrix(senCoAgent, jj);
                    end
                end
            end
        end
    end
end
for ii = 1:length(recAllocation.timeStamp)
    if senAllocation.timeStamp(ii) > allocation.timeStamp(ii)
        allocation.timeStamp(ii) = senAllocation.timeStamp(ii);
    end
end
allocation.assignMatrix = recAssignMatrix;
allocation.timeStamp(senID) = allocation.timeStamp(senID) + 1;
end
