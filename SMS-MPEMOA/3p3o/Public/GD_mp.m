function Score = GD_mp(objs,PF0,PF1,PF2)
    Distance0 = min(pdist2(objs(:,1:3),PF0),[],2);
    Distance1 = min(pdist2(objs(:,4:6),PF1),[],2);
    Distance2 = min(pdist2(objs(:,7:9),PF2),[],2);
    
    Score = (norm(Distance0)+norm(Distance1)+norm(Distance2))/(3*length(Distance0));
end

