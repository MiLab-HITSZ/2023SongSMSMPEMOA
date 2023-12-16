function Multi_conclude()
    delete(gcp('nocreate'));
    parpool(30);
    a = MPMOKP;
    evalu = 500;
    pop_size = 100;    
    result = [];
    for dim = [250 500 750]
        for k = 1:10
            s = load(sprintf('./problems/%d/MPMOKP%d_%d',dim,dim,k));
            profit00 = s.profit00;
            profit01 = s.profit01;
            profit02 = s.profit02;
            profit10 = s.profit10;
            profit11 = s.profit11;
            profit12 = s.profit12;
            profit20 = s.profit20;
            profit21 = s.profit21;
            profit22 = s.profit22;
            
            weight00 = s.weight00;
            weight01 = s.weight01;
            weight02 = s.weight02;
            weight10 = s.weight10;
            weight11 = s.weight11;
            weight12 = s.weight12;
            weight20 = s.weight20;
            weight21 = s.weight21;
            weight22 = s.weight22;
            
            nondominated_solution0 = s.nondominated_solution_0;
            nondominated_solution1 = s.nondominated_solution_1;
            nondominated_solution2 = s.nondominated_solution_2;

            a.Init_D(dim,profit00,profit01,profit02,profit10,profit11,profit12,profit20,profit21,profit22,weight00,weight01,weight02,weight10,weight11,weight12,weight20,weight21,weight22);
            PF0 = a.CalV(nondominated_solution0);
            PF0 = PF0(:,1:3);
            PF1 = a.CalV(nondominated_solution1);
            PF1 = PF1(:,4:6);
            PF2 = a.CalV(nondominated_solution2);
            PF2 = PF2(:,7:9);
            IGD1 = [];
            IGD2 = [];
            IGD3 = [];
            IGD4 = [];
            IGD5 = [];
            GD1 = [];
            GD2 = [];
            GD3 = [];
            GD4 = [];
            GD5 = [];
            parfor i = 1:30
                s = RandStream.create('mrg32k3a','NumStreams',30,'StreamIndices',i); 
                RandStream.setGlobalStream(s); 
                [obj1,~] = moead_final(a,evalu,pop_size,k);
                [obj2,~] = mpnds_final(a,evalu,pop_size,1,k);
                [obj3,~] = mpnds_final(a,evalu,pop_size,2,k);
                [obj4,~] = spea2_final(a,evalu,pop_size,k);
                [obj5,~] = sms_final(a,evalu,pop_size,k);

                GD1 = [GD1,GD_mp(obj1,PF0,PF1,PF2)];
                GD2 = [GD2,GD_mp(obj2,PF0,PF1,PF2)];
                GD3 = [GD3,GD_mp(obj3,PF0,PF1,PF2)];
                GD4 = [GD4,GD_mp(obj4,PF0,PF1,PF2)];
                GD5 = [GD5,GD_mp(obj5,PF0,PF1,PF2)];

                IGD1 = [IGD1,IGD_mp1(obj1,PF0,PF1,PF2)];
                IGD2 = [IGD2,IGD_mp1(obj2,PF0,PF1,PF2)];
                IGD3 = [IGD3,IGD_mp1(obj3,PF0,PF1,PF2)];
                IGD4 = [IGD4,IGD_mp1(obj4,PF0,PF1,PF2)];
                IGD5 = [IGD5,IGD_mp1(obj5,PF0,PF1,PF2)];

                fprintf("MPMOKP_%d_%d the %d-th running done!\n",dim,k,i);
            end
            IGD_mean1=mean(IGD1);
            IGD_std1=std(IGD1);
            IGD_mean2=mean(IGD2);
            IGD_std2=std(IGD2);  
            IGD_mean3=mean(IGD3);
            IGD_std3=std(IGD3); 
            IGD_mean4=mean(IGD4);
            IGD_std4=std(IGD4); 
            IGD_mean5=mean(IGD5);
            IGD_std5=std(IGD5);
            GD_mean1 = mean(GD1);
            GD_std1 = std(GD1);
            GD_mean2 = mean(GD2);
            GD_std2 = std(GD2);
            GD_mean3 = mean(GD3);
            GD_std3 = std(GD3);
            GD_mean4 = mean(GD4);
            GD_std4 = std(GD4);
            GD_mean5 = mean(GD5);
            GD_std5 = std(GD5);
            result = [result;IGD_mean1,IGD_std1,IGD_mean2,IGD_std2,IGD_mean3,IGD_std3,IGD_mean4,IGD_std4,IGD_mean5,IGD_std5,...
                GD_mean1,GD_std1,GD_mean2,GD_std2,GD_mean3,GD_std3,GD_mean4,GD_std4,GD_mean5,GD_std5];
            result = [result;IGD_mean5,IGD_std5];
            fprintf("MPMOKP_%d_%d done!\n",dim,k);
        end
        save(sprintf('result/result_%d.mat',dim),'result');
    end
end

