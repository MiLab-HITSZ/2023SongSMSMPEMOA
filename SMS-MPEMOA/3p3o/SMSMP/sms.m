function [objs,P] = sms(MOP,SC,N,k)
    DM = 2;
    P = Init_Pop(MOP,N);
    vector = GenVector(7);
    cal_sc = 0; %��ʼ����������cal_sc 
%     objs = -MOP.CalV(repairx(MOP,P,vector));
    [FrontNo,FrontNo0,FrontNo1,objs] = DoubleSort(P,MOP,vector);
    EP = [];
    while cal_sc < SC
        cal_sc = cal_sc + 1;
        fprintf("On %d-th problem in SMS-EMOA %d-th generation running\n",k,cal_sc);
        MatingPool = TournamentSelection(2,N,FrontNo);
        Offspring  = GA(P(MatingPool,:));
        [P,objs,FrontNo0,FrontNo1] = EnvironmentalSelection(P,objs,Offspring,FrontNo0,FrontNo1,MOP,vector);
        FrontNo = NDSort([FrontNo0',FrontNo1'],N);
        NonDominated = zeros(1,N);
        for dm = 1:DM
            FrontNum = NDSort(objs(:,(1+(dm-1)*2):(dm*2)),N);
            NonDominated = NonDominated | (FrontNum == 1);
        end
        EP = [EP;P(find(NonDominated==1),:)];
    end
    
    P = repairxx(MOP,EP,vector);
    [P,~,~] = unique(P,'rows');
    objs = MOP.CalV(P);
    
    [Num_of_P,~] = size(P);
    NonDominated = zeros(1,Num_of_P);
    for dm = 1:DM
        FrontNum = NDSort(-objs(:,(1+(dm-1)*2):(dm*2)),Num_of_P);
        NonDominated = NonDominated | (FrontNum == 1);
    end
    P = P(find(NonDominated==1),:);
    objs = objs(find(NonDominated==1),:);
    
%     disp(objs);
%     weights = MOP.CalW(P);
%     wei = MOP.c00;
%     disp(weights);
%     disp(wei);
end

function vector = GenVector(x)
    vector = [];
    for i = 0:x
        for j = 0:x
            for l = 0:x
                for m = 0:x
                    if(i+j+l+m)==x
                        vector = [vector;[i,j,l,m]];
                    end
                end
            end
        end
    end
end

function [FrontNo,FrontNo0,FrontNo1,objs] = DoubleSort(P,MOP,vector)
    repair_P = repairxx(MOP,P,vector);
    objs = -MOP.CalV(repair_P);
    [n,~] = size(objs);
    [FrontNo0,~] = NDSort(objs(:,1:2),n);
    [FrontNo1,~] = NDSort(objs(:,3:4),n);
    FrontNo = NDSort([FrontNo0',FrontNo1'],n);
end

function [P,objs,FrontNo0,FrontNo1] = EnvironmentalSelection(P,objs,Offspring,FrontNo0,FrontNo1,MOP,vector)
    repair_off = repairxx(MOP,Offspring,vector);
    off_objs = -MOP.CalV(repair_off);

    [n,~] = size(off_objs);
    count = 1;
    while count < n+1
        currS = Offspring(count,:);
        currObj = off_objs(count,:);
        [P,objs,FrontNo0,FrontNo1] = Reduce([P;currS],[objs;currObj],FrontNo0,FrontNo1,mod(count,2));
        count = count+1;
    end
end









