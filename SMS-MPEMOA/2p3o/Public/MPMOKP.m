classdef MPMOKP < handle
% <MPMOP>
    properties
    %% Initialization
        M;
        D;
        DM;
        profit00;
        profit01;
        profit02;
        profit10;
        profit11;
        profit12;
        weight00;
        weight01;
        weight02;
        weight10;
        weight11;
        weight12;
        c00;
        c01;
        c02;
        c10;
        c11;
        c12;
        encoding = 'binary';
    end
    methods
        %% Initialization
        function obj = Init_D(obj,d,pro00,pro01,pro02,pro10,pro11,pro12,wei00,wei01,wei02,wei10,wei11,wei12)                      
            obj.M = 6;
            obj.DM = 2;
            obj.D = d;
            
            % random profit generation
            obj.profit00=pro00;
            obj.profit01=pro01;
            obj.profit02=pro02;
            obj.profit10=pro10;
            obj.profit11=pro11;
            obj.profit12=pro12;
            
            obj.weight00=wei00;
            obj.weight01=wei01;
            obj.weight02=wei02;
            obj.weight10=wei10;
            obj.weight11=wei11;
            obj.weight12=wei12;
      
            obj.c00=sum(obj.weight00)*0.5;
            obj.c01=sum(obj.weight01)*0.5;
            obj.c02=sum(obj.weight02)*0.5;
            obj.c10=sum(obj.weight10)*0.5;
            obj.c11=sum(obj.weight11)*0.5;
            obj.c12=sum(obj.weight12)*0.5;
        end
        %% Calculate objective values for each party
        function PopObj = CalV(obj,PopDec) 
            PopObj(:,1:obj.M/2)=MPMOKP_attri(obj.profit00,obj.profit01,obj.profit02, PopDec);
            PopObj(:,obj.M/2+1:obj.M)=MPMOKP_attri(obj.profit10,obj.profit11,obj.profit12,PopDec);
        end
        function PopObj = CalW(obj,PopDec) 
            PopObj(:,1:obj.M/2)=MPMOKP_attri(obj.weight00,obj.weight01,obj.weight02, PopDec);
            PopObj(:,obj.M/2+1:obj.M)=MPMOKP_attri(obj.weight10,obj.weight11,obj.weight12,PopDec);
        end
    end
end