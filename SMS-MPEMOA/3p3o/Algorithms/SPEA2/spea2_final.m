function [objs,P] = spea2_final(MOP,SC,N,k)
    DM = 3;
    P = Init_Pop(MOP,N);
    
    %修复算子必要参数
    C=[MOP.c00,MOP.c01,MOP.c02,MOP.c10,MOP.c11,MOP.c12,MOP.c20,MOP.c21,MOP.c22];
    W=[MOP.weight00;MOP.weight01;MOP.weight02;MOP.weight10;MOP.weight11;MOP.weight12;MOP.weight20;MOP.weight21;MOP.weight22];
    S=[MOP.profit00;MOP.profit01;MOP.profit02;MOP.profit10;MOP.profit11;MOP.profit12;MOP.profit20;MOP.profit21;MOP.profit22];
    s=sum(S,1)./sum(W,1);
    [~,r]=sort(s,2,'descend');
    
    objs = MOP.CalV(repair1(MOP,r,C,W,P));
    Fitness = CalFitness(objs);
    
    cal_sc = 0; %初始化评估次数cal_sc
    while cal_sc < SC
        cal_sc = cal_sc + 1;
        fprintf("On %d-th problem in SPEA2-MP %d-th generation running\n",k,cal_sc);
        MatingPool = TournamentSelection(2,N,Fitness);
        Offspring  = GA(P(MatingPool,:));  
        P = [P;Offspring];
        [P,Fitness] = Environmental_Selection(P,N,MOP,r,C,W);
        %disp(mean(Fitness));
        %disp(size(P,1));
    end

%     P = repair(MOP,P);
%     [MPS,~,~] = unique(P,'rows');
%     objs = MOP.CalV(MPS);

    P = repair1(MOP,r,C,W,P);
    [P,~,~] = unique(P,'rows');
    objs = MOP.CalV(P);
    
    [Num_of_P,~] = size(P);
    NonDominated = zeros(1,Num_of_P);
    for dm = 1:DM
        FrontNum = NDSort(-objs(:,(1+(dm-1)*3):(dm*3)),Num_of_P);
        NonDominated = NonDominated | (FrontNum == 1);
    end
    P = P(find(NonDominated==1),:);
    objs = objs(find(NonDominated==1),:);
%     [P,~,~] = unique(P,'rows');
%     [Num_of_P,~] = size(P);
%     NonDominated = true(Num_of_P,1);
%     for m=1:DM
%         NonDominated = NonDominated & (FNDS(objs(:,(m-1)*2+1:m*2)) == 1);
%     end
%     MPS = P(NonDominated,:);
%     objs = objs(NonDominated,:);
%     disp(objs);
%     weights = MOP.CalW(P);
%     wei = MOP.c00;
%     disp(weights);
%     disp(wei);
end


