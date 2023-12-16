function [Population,objs,FrontNo] = EnvironmentalSelection1(Population,MOP,N,vector,C,W,S)

    repair_P = repairxx(MOP,Population,vector,C,W,S);
    objs = -MOP.CalV(repair_P);
    [n,~] = size(objs);
    [FrontNo0,~] = NDSort(objs(:,1:3),n);
    [FrontNo1,~] = NDSort(objs(:,4:6),n);
    FrontNo = NDSort([FrontNo0',FrontNo1'],n);


%     CrowdDis = CrowdingDistance(objs,FrontNo);
    
    front = 1;
    count = 0;
    Next = zeros(1,size(Population,1));
    
    Last = find(FrontNo == front);
    temp = size(Last,2);
    count = count + temp;
    
    while count < N
       Next(Last) = true;
       front = front + 1;
       Last = find(FrontNo == front);
       temp = size(Last,2);
       count = count + temp;
    end
    
    if count == N
        Next(Last) = true;
    else
%         Next(Last) = true;
        for j = 1:count-N
            PopObj = objs(Last,:);
            [n,~]     = size(PopObj);
            deltaS0 = inf(1,n);
            deltaS1 = inf(1,n);
            deltaS  = inf(1,n);
%             [~,rank] = sortrows(PopObj(:,1:2));
%             for i = 2 : n-1
%                 deltaS0(rank(i)) = (PopObj(rank(i+1),1)-PopObj(rank(i),1)).*(PopObj(rank(i-1),2)-PopObj(rank(i),2));
%             end
% 
%             [~,rank] = sortrows(PopObj(:,3:4));
%             for i = 2 : n-1
%                 deltaS1(rank(i)) = (PopObj(rank(i+1),1)-PopObj(rank(i),1)).*(PopObj(rank(i-1),2)-PopObj(rank(i),2));
%             end
            if n>1
                deltaS0 = CalHV(PopObj(:,1:3),max(PopObj(:,1:3),[],1)*1.1,1,5000);
                deltaS1 = CalHV(PopObj(:,4:6),max(PopObj(:,4:6),[],1)*1.1,1,5000);
            end

            for i = 2 : n-1
                deltaS(i) = max(deltaS0(i),deltaS1(i));
            end
            [~,worst] = min(deltaS);
            Last(worst) = [];
        end
        Next(Last) = true;
    end
%     [~,Rank] = sort(CrowdDis(Last),'descend');
%     Next(Last(Rank(1:N-sum(Next)))) = true;
    index = find(Next);
    Population = Population(index,:);
    objs       = objs(index,:);
    FrontNo    = FrontNo(index);
%     CrowdDis   = CrowdDis(index);
end

