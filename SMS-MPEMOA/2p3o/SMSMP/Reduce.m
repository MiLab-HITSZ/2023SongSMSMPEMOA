function [Population,Obj,FrontNo0,FrontNo1] = Reduce(Population,Obj,FrontNo0,FrontNo1,flag)
% Delete one solution from the population

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    %% Identify the solutions in the last front
    FrontNo0   = UpdateFront(Obj(:,1:2),FrontNo0);
    FrontNo1   = UpdateFront(Obj(:,3:4),FrontNo1);
    if flag == 0
        LastFront = find(FrontNo0==max(FrontNo0));
        PopObj = Obj(LastFront,1:2);
    else
        LastFront = find(FrontNo1==max(FrontNo1));
        PopObj = Obj(LastFront,3:4);
    end
    [N,M]     = size(PopObj);
    
    %% Calculate the contribution of hypervolume of each solution
    deltaS = inf(1,N);
    if M == 2
        [~,rank] = sortrows(PopObj);
        for i = 2 : N-1
            deltaS(rank(i)) = (PopObj(rank(i+1),1)-PopObj(rank(i),1)).*(PopObj(rank(i-1),2)-PopObj(rank(i),2));
        end
    elseif N > 1
        deltaS = CalHV(PopObj,max(PopObj,[],1)*1.1,1,10000);
    end
    
    %% Delete the worst solution from the last front
    [~,worst] = min(deltaS);
    FrontNo0   = UpdateFront(Obj(:,1:2),FrontNo0,LastFront(worst));
    FrontNo1   = UpdateFront(Obj(:,3:4),FrontNo1,LastFront(worst));
    Population(LastFront(worst),:) = [];
    Obj(LastFront(worst),:) = [];
end