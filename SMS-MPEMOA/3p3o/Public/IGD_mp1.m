function Score= IGD_mp1(PopObj,PF0,PF1,PF2)
%     % <metric> <min>
%     %%calculate the IGD  for the result
%     [~,M]=size(PF);
%     [row,~]=size(PF);
%     [col,~]=size(PopObj);
%     Distance_IGD=zeros(row,col);
% 
%     %we calculate their distance between real PF and PF for each party, sum
%     %them,and find the min value for each individual
%     for i=1:DM
%         real_PopObj = real(PopObj);
%         Distance_IGD = Distance_IGD+pdist2(PF(:,(i-1)*M/DM+1:i*M/DM),real_PopObj(:,(i-1)*M/DM+1:i*M/DM));
%     end  
    
    Distance_IGD0 = pdist2(PF0,PopObj(:,1:3));
    Distance_IGD0 = min(Distance_IGD0,[],2);
    
    Distance_IGD1 = pdist2(PF1,PopObj(:,4:6));
    Distance_IGD1 = min(Distance_IGD1,[],2);

    Distance_IGD2 = pdist2(PF2,PopObj(:,7:9));
    Distance_IGD2 = min(Distance_IGD2,[],2);
    
    IGD    = mean([Distance_IGD0;Distance_IGD1;Distance_IGD2]);

    Score = IGD;
end
