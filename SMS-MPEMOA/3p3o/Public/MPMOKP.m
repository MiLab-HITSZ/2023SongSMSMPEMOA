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
        profit20;
        profit21;
        profit22;
        weight00;
        weight01;
        weight02;
        weight10;
        weight11;
        weight12;
        weight20;
        weight21;
        weight22;
        c00;
        c01;
        c02;
        c10;
        c11;
        c12;
        c20;
        c21;
        c22;
        encoding = 'binary';
    end
    methods
        %% Initialization
        function obj = Init_D(obj,d,pro00,pro01,pro02,pro10,pro11,pro12,pro20,pro21,pro22,wei00,wei01,wei02,wei10,wei11,wei12,wei20,wei21,wei22)                      
            obj.M = 9;
            obj.DM = 3;
            obj.D = d;
            
            % random profit generation
            obj.profit00=pro00;
            obj.profit01=pro01;
            obj.profit02=pro02;
            obj.profit10=pro10;
            obj.profit11=pro11;
            obj.profit12=pro12;
            obj.profit20=pro20;
            obj.profit21=pro21;
            obj.profit22=pro22;
            obj.weight00=wei00;
            obj.weight01=wei01;
            obj.weight02=wei02;
            obj.weight10=wei10;
            obj.weight11=wei11;
            obj.weight12=wei12;
            obj.weight20=wei20;
            obj.weight21=wei21;
            obj.weight22=wei22;
      
            obj.c00=sum(obj.weight00)*0.5;
            obj.c01=sum(obj.weight01)*0.5;
            obj.c02=sum(obj.weight02)*0.5;
            obj.c10=sum(obj.weight10)*0.5;
            obj.c11=sum(obj.weight11)*0.5;
            obj.c12=sum(obj.weight12)*0.5;
            obj.c20=sum(obj.weight20)*0.5;
            obj.c21=sum(obj.weight21)*0.5;
            obj.c22=sum(obj.weight22)*0.5;
        end
        %% Calculate objective values for each party
        function PopObj = CalV(obj,PopDec) 
            PopObj(:,1:3)=MPMOKP_attri(obj.profit00,obj.profit01,obj.profit02, PopDec);
            PopObj(:,4:6)=MPMOKP_attri(obj.profit10,obj.profit11,obj.profit12,PopDec);
            PopObj(:,7:9)=MPMOKP_attri(obj.profit20,obj.profit21,obj.profit22,PopDec);
        end
        function PopObj = CalW(obj,PopDec) 
            PopObj(:,1:3)=MPMOKP_attri(obj.weight00,obj.weight01,obj.weight02, PopDec);
            PopObj(:,4:6)=MPMOKP_attri(obj.weight10,obj.weight11,obj.weight12,PopDec);
            PopObj(:,7:9)=MPMOKP_attri(obj.weight20,obj.weight21,obj.weight22,PopDec);
        end
    end
end