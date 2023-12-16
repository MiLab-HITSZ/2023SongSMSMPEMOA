function [objs,P] = sms_final(MOP,SC,N,k)
    DM = 3;
    P = Init_Pop(MOP,N);
    vector = GenVector(6);
    cal_sc = 0; %��ʼ����������cal_sc 

    %�޸����ӱ�Ҫ����
    C=[MOP.c00,MOP.c01,MOP.c02,MOP.c10,MOP.c11,MOP.c12,MOP.c20,MOP.c21,MOP.c22];
    W=[MOP.weight00;MOP.weight01;MOP.weight02;MOP.weight10;MOP.weight11;MOP.weight12;MOP.weight20;MOP.weight21;MOP.weight22];
    S=[MOP.profit00;MOP.profit01;MOP.profit02;MOP.profit10;MOP.profit11;MOP.profit12;MOP.profit20;MOP.profit21;MOP.profit22];
    
    [P,~,FrontNo] = EnvironmentalSelection1(P,MOP,N,vector,C,W,S);
    MAX_SIZE = 5000;
    EP = zeros(MAX_SIZE,MOP.D);
    count = 1;
    while cal_sc < SC
        cal_sc = cal_sc + 1;
        fprintf("On %d-th problem in SMS-EMOA %d-th generation running\n",k,cal_sc);
        MatingPool = TournamentSelection(2,N,FrontNo);
        Offspring  = GA(P(MatingPool,:));
        P = [P;Offspring];
        [P,objs,FrontNo] = EnvironmentalSelection1(P,MOP,N,vector,C,W,S);
%         NonDominated = zeros(1,N);
%         for dm = 1:DM
%             FrontNum = NDSort(objs(:,(1+(dm-1)*3):(dm*3)),N);
%             NonDominated = NonDominated | (FrontNum == 1);
%         end
        NonDominated = NDSort(objs,N);
        T = P(find(NonDominated==1),:);
        for i = 1:size(T,1)
%             EP(count,:) = [EP;P(find(NonDominated==1),:)];
            EP(count,:) = T(i,:);
            count = count + 1;
            if(count == MAX_SIZE + 1)
                count = 1;
            end
        end
    end
    
    P = repairxx(MOP,EP,vector,C,W,S);
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
    
    % disp(objs);
    % weights = MOP.CalW(P);
    % wei = MOP.c00;
    % disp(weights);
    % disp(wei);
end

function vector = GenVector(x)
    vector = [];
    for i = 0:x
        for j = 0:x
            for l = 0:x
                for m = 0:x
                    for p = 0:x
                        for q = 0:x
                            for f = 0:x
                                for g = 0:x
                                   for h = 0:x
                                       if(i+j+l+m+p+q+f+g+h)==x
                                           vector = [vector;[i,j,l,m,p,q,f,g,h]];
                                       end
                                   end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end