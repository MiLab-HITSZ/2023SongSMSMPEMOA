function Fitness = CalFitness(PopObj)
% Calculate the fitness of each solution

%------------------------------- Copyright --------------------------------
% Copyright (c) 2022 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    N = size(PopObj,1);

    %% Detect the dominance relation between each two solutions
    Dominate1 = false(N);
    Dominate2 = false(N);
    for i = 1 : N-1
        for j = i+1 : N
            k1 = any(PopObj(i,1:3)>PopObj(j,1:3)) - any(PopObj(i,1:3)<PopObj(j,1:3));
            if k1 == 1
                Dominate1(i,j) = true;
            elseif k1 == -1
                Dominate1(j,i) = true;
            end
            k2 = any(PopObj(i,4:6)>PopObj(j,4:6)) - any(PopObj(i,4:6)<PopObj(j,4:6));
            if k2 == 1
                Dominate2(i,j) = true;
            elseif k2 == -1
                Dominate2(j,i) = true;
            end
        end
    end

%     Dominate2 = false(N);
%     for i = 1 : N-1
%         for j = i+1 : N
%             k = any(PopObj(i,4:6)>PopObj(j,4:6)) - any(PopObj(i,4:6)<PopObj(j,4:6));
%             if k == 1
%                 Dominate2(i,j) = true;
%             elseif k == -1
%                 Dominate2(j,i) = true;
%             end
%         end
%     end
    
    %% Calculate S(i)
    S1 = sum(Dominate1,2);
    S2 = sum(Dominate2,2);
    
    %% Calculate R(i)
    R = zeros(1,N);
    for i = 1 : N
        R(i) = sum(S1(Dominate1(:,i))) + sum(S2(Dominate2(:,i)));
    end
    
    %% Calculate D(i)
    Distance1 = pdist2(PopObj(:,1:3),PopObj(:,1:3));
    Distance1(logical(eye(length(Distance1)))) = inf;
    Distance1 = sort(Distance1,2);

    Distance2 = pdist2(PopObj(:,4:6),PopObj(:,4:6));
    Distance2(logical(eye(length(Distance2)))) = inf;
    Distance2 = sort(Distance2,2);

    D = (1./(Distance1(:,floor(sqrt(N)))+2) + 1./(Distance2(:,floor(sqrt(N)))+2))./2;
    
    %% Calculate the fitnesses
    Fitness = R + D';
end