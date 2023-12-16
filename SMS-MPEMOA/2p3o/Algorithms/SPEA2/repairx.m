function offspring = repairx(varargin)
    
%     offspring = repairx(MOP,offs,Vector) repair each solution in offs 
%     based on randomly selected vector from Vector.  

%     offspring = repairx(MOP,offs,Vector,index) repair the single solution 
%     offs based on the specified vector through index from Vector.

    MOP = varargin{1};
    offs = varargin{2};
    Vector = varargin{3};
    D = MOP.D;
    persistent C;
    if isempty(C)
        C=[MOP.c00,MOP.c01,MOP.c10,MOP.c11];
    end
    persistent W;
    if isempty(W)
        W=[MOP.weight00;MOP.weight01;MOP.weight10;MOP.weight11];
    end 
    persistent S;
    if isempty(S)
        S=[MOP.profit00;MOP.profit01;MOP.profit10;MOP.profit11];
    end  
    
    [m,~]=size(offs);
    
    if nargin == 3
        for i = 1:m
            x = offs(i,:);
            R=MOP.CalW(x);
            vec = Vector(randperm(end,1),:);
            rs = S.*vec';
            ratio = sum(rs,1)./sum(W,1);
            [~,rank]=sort(ratio,2,'descend');
            
            %drop
            for j = D:-1:1
                if sum(R>C)>=1 && x(rank(j))==1    
                    x(rank(j)) = 0;
                    R=R-W(:,rank(j))';
                end
            end
            offs(i,:) = x;
        end
        offspring = offs;
    else
        index = varargin{4};
        R=MOP.CalW(offs);
        vec = Vector(index,:);
        rs = S.*vec';
        ratio = sum(rs,1)./sum(W,1);
        [~,rank]=sort(ratio,2,'descend');

        %drop
        for j = D:-1:1
            if sum(R>C)>=1 && offs(rank(j))==1   
                offs(rank(j)) = 0;
                R=R-W(:,rank(j))';
            end
        end
        offspring = offs;
    end
end