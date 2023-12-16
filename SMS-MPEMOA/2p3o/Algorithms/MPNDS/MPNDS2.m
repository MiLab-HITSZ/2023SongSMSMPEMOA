function [FrontNo,MaxFNo] = MPNDS2(objs,N)
    L(:,1) = FNDS(objs(:,1:3));
    L(:,2) = FNDS(objs(:,4:6));
    [FrontNo,MaxFNo] = NDSort(L,N);
end

