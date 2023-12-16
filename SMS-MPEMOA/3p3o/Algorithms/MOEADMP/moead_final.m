function [objs,P] = moead_final(MOP,SC,N,k)

    % MOP:multiobjective problem
    % SC:stopping criterion
    % N:the number of the subproblems considered in MOEA/D

    population = Init_Pop(MOP,N);
    rate_T = 0.1;
    T = ceil(N * rate_T);
    
    update_pop = 0.6;%按概率更新个体
    
    sel_neighbor = 0.5;
    cal_sc = 0;%初始评估个体数cal_sc 
   

    % 生成均匀分布权重向量，存于W
    M = MOP.M;%M为目标函数维度，也就是目标函数包含的“小”目标个数
    DM = MOP.DM;
    W = WV_generator(N,M/DM);
    N = size(W,1);
    
    %修复算子必要参数
    C=[MOP.c00,MOP.c01,MOP.c02,MOP.c10,MOP.c11,MOP.c12,MOP.c20,MOP.c21,MOP.c22];
    Q=[MOP.weight00;MOP.weight01;MOP.weight02;MOP.weight10;MOP.weight11;MOP.weight12;MOP.weight20;MOP.weight21;MOP.weight22];
    S=[MOP.profit00;MOP.profit01;MOP.profit02;MOP.profit10;MOP.profit11;MOP.profit12;MOP.profit20;MOP.profit21;MOP.profit22];
    s=sum(S,1)./sum(Q,1);
    [~,r]=sort(s,2,'descend');
    
    % 计算函数值，FV为N*M矩阵
%     population = population(1:N,:);
    repair_population = zeros(N,MOP.D);
    for t = 1:N
        repair_population(t,:) = repair_s(MOP,r,C,Q,population(t,:));
    end
    FV = MOP.CalV(repair_population);
%     FV = MOP.CalV(repair_s(MOP,population));

    %初始化参考界面Z
    Z = max(FV,[],1);
    
    %初始化EP    
    MAX_SIZE = 5000;
    EP = zeros(MAX_SIZE,MOP.D);
    objs = zeros(MAX_SIZE,M);
    count = 1;
    
    % 计算各权重向量相互间欧几里得距离,并找出每个向量距离最近的T个邻居向量（包括自身）
    D_of_W = zeros([N,N]);
    for i = 1:N
        for j = 1:N
            D_of_W(i,j) = pdist2(W(i,:),W(j,:));
        end
    end    

    B = zeros(N,T);
    TempB = zeros(N,N);
    
    for i = 1:N
        [~,TempB(i,:)] = sort(D_of_W(i,:),2);
        B(i,:) = TempB(i,1:T);
    end
    
    % 开始循环
    while cal_sc < SC
        for dm = 1:DM 
            
            cut = M/DM;
            count_dm = (1+(dm-1)*cut):(dm*cut);  
            
%             [Num_of_P,~] = size(population);
            fprintf("On %d-th problem in MOEA/D-MP %d-th generation running\n",k,cal_sc);
            cal_sc = cal_sc + 1;
            for i = 1:N
                rand_num = rand;
                if rand_num < sel_neighbor
                    P = randperm(T,2);
                    offspring_y = GAs(population(B(i,P(1)),:),population(B(i,P(2)),:));
                else
                    P = randperm(N,2);
                    offspring_y = GAs(population(P(1),:),population(P(2),:));
                end
                
                re_y = repair_s(MOP,r,C,Q,offspring_y);
                re_F_y=MOP.CalV(re_y);
                
                Z = max(Z,re_F_y);
                for j = 1:T
                    g_x = max(abs(FV(B(i,j),count_dm)-Z(:,count_dm)).*W(B(i,j),:)); %B(i,j)返回范围1：N的序号，对应某个个体
                    g_y = max(abs(re_F_y(:,count_dm)-Z(:,count_dm)).*W(B(i,j),:));                 
                    if g_y <= g_x
                        if rand < update_pop
                            population(B(i,j),:) = offspring_y;
                            FV(B(i,j),:) = re_F_y;
                        end
                        
                        objs(count,:) = re_F_y;
                        EP(count,:) = re_y;
                        count = count + 1;
                        if count == MAX_SIZE+1
                            count = 1;
                        end
                    end
                end
            end
        end
        
        [Num_of_EP,~] = size(EP);
     
        NonDominated = zeros(1,Num_of_EP);
        for dm = 1:DM
            FrontNum = NDSort(-objs(:,(1+(dm-1)*3):(dm*3)),Num_of_EP);
            NonDominated = NonDominated | (FrontNum == 1);
        end
        EP = EP(find(NonDominated==1),:);
        objs = objs(find(NonDominated==1),:);
    end
   
    [P,rank,~] = unique(EP,'rows');
    objs = objs(rank,:);
%     [MPS,~,~] = unique(offs,'rows');
%     objs = MOP.CalV(P);
%     disp(objs);
%     weights = MOP.CalW(P);
%     wei = MOP.c00;
%     disp(weights);
%     disp(wei);

end

