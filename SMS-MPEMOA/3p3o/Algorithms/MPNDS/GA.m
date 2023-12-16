function Offspring = GA(Parent)
    Parent1 = Parent(1:floor(end/2),:);
    Parent2 = Parent(floor(end/2)+1:floor(end/2)*2,:);
    [N,D]   = size(Parent1);
    % Uniform crossover
%     k = rand(N,D) < 0.5;
    % One point crossover
    k = repmat(1:D,N,1) > repmat(randi(D,N,1),1,D);
    k(repmat(rand(N,1)>1,1,D)) = false;
    Offspring1    = Parent1;
    Offspring2    = Parent2;
    Offspring1(k) = Parent2(k);
    Offspring2(k) = Parent1(k);
    Offspring     = [Offspring1;Offspring2];
    % Bitwise mutation
    Site = rand(2*N,D) < 1/D;
    Offspring(Site) = ~Offspring(Site);
    %Offspring = repair(MOP,Offspring);
end

