function [Population,FrontNo,CrowdDis] = EnvironmentalSelection(Population,MOP,r,C,W,N,opt)
%     repair_P = repairx(MOP,Population);
    repair_P = repair(MOP,r,C,W,Population);
    objs = MOP.CalV(repair_P);
    if opt == 1
        [FrontNo,~] = MPNDS(objs,N,MOP);
    else
        [FrontNo,~] = MPNDS2(objs,N);
    end

    CrowdDis = CrowdingDistance(objs,FrontNo);
    
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
    [~,Rank] = sort(CrowdDis(Last),'descend');
    Next(Last(Rank(1:N-sum(Next)))) = true;
    index = find(Next);
    Population = Population(index,:);
    FrontNo    = FrontNo(index);
    CrowdDis   = CrowdDis(index);
end

