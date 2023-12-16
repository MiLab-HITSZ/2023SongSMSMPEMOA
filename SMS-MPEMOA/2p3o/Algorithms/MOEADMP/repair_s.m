function offspring = repair_s(MOP,r,C,W,x)
    D = MOP.D;

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
    offspring = x;
end