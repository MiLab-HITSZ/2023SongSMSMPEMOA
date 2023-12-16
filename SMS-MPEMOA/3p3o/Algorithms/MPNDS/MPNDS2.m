function [FrontNo,MaxFNo] = MPNDS2(objs,N)
    L(:,1) = FNDS(objs(:,1:3));
    L(:,2) = FNDS(objs(:,4:6));
    L(:,3) = FNDS(objs(:,7:9));
    [FrontNo,MaxFNo] = NDSort(L,N);
end

