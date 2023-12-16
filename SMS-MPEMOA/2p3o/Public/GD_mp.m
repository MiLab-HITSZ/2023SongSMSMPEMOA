function Score = GD_mp(objs,PF0,PF1)
    Distance0 = min(pdist2(objs(:,1:3),PF0),[],2);
    Distance1 = min(pdist2(objs(:,4:6),PF1),[],2);
    
    Score = (norm(Distance0)+norm(Distance1))/(2*length(Distance0));
end

