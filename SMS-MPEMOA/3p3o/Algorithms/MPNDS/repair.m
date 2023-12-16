function offspring = repair(MOP,r,C,W,off)
    D = MOP.D;
    
    [m,~]=size(off);
    %disp(off);
    for i = 1:m
        x = off(i,:);
        %disp(size(x));
        R=MOP.CalW(x);
        %drop
        for j = D:-1:1
            if x(r(j))==1 && sum(R>C)>=1   
                x(r(j)) = 0;
                R=R-W(:,r(j))';
            end
        end
        %add
    %     if c == 2
    %         for j = 1:D
    %             if (x(r(j))==0)&&(sum(R+W(:,r(j))'<=C)==M)
    %                 x(r(j))=1;
    %                 R=R+W(:,r(j))';
    %             end
    %         end
    %     end
        off(i,:) = x;
    end
    offspring = off;
end