%% Initialization
 n=6;
 Mod = (n+1)^2;
Mode = 0;
YLM  = cell(Mod,1);
BDF = 2;

%% Creat Spherical Harmonics
 for L=0:n           % L = degree
     for m= -L:L        % M = Order
          YLM{L^2+L+m+1} = SphericalHarmonics(L,m);    % Single Spherical Harmonics
     end
 end
 
% Function for each single Mode.
% Create Function Handles for Loop

%% Variables and assignmens
syms zetaa
syms phii
syms deltaT 
syms C

AA0 = cell(length(YLM),1);%%%%%%%% a und b Bennenung muss in Kommentar erklrt
AA1 = cell(length(YLM),1);
BB0 = cell(length(YLM),1);
BB1 = cell(length(YLM),1);

for i = 0:BDF-1
    for j = 0:Mod-1
        syms(['a', num2str(i), '_', num2str(j)]);
        syms(['b', num2str(i), '_',num2str(j)]); 
    end
    for k = 1:Mod
        if i == 0
            AA0{k} = eval(['a', num2str(i), '_',num2str((k-1))]);
            BB0{k} = eval(['b', num2str(i), '_',num2str((k-1))]);

        else
            AA1{k} = eval(['a', num2str(i), '_',num2str((k-1))]);
            BB1{k} = eval(['b', num2str(i), '_',num2str((k-1))]);
        end

     end

end
H = zeros(2*Mod,1);

%% Create R and q and timederrivates R_dot and q_dot 
R     = 0;
q     = 0;
Rdot  = 0;
qdot  = 0;

for i=1:length(YLM)     % Constructing Polynomials
    R= AA1{i}*YLM{i}+R;                           %R
    Rdot= (((AA1{i}-AA0{i})*YLM{i})/deltaT)+Rdot; %Rdot with FDM
    
    q= BB1{i}*YLM{i}+q;                           %q
    qdot= (((BB1{i}-BB0{i})*YLM{i})/deltaT)+qdot; %qdot
end

%% Differentials for R and q
q_grad = diff(q,zetaa)*sqrt(1-zetaa^2);     %Gradient q first component/secound is zero
q_grad2 = diff(q,phii)/sqrt(1-zetaa^2);     %Gradient q secound component/secound is zero
R_grad = diff(R,zetaa)*sqrt(1-zetaa^2);     %Gradient R first component/secound is zero
R_grad2 = diff(R,phii)/sqrt(1-zetaa^2);     %Gradient q secound component/secound is zero
R_Hess11 = (1-zetaa^2)*diff(diff(R,zetaa),zetaa)-zetaa*diff(R,zetaa); %(1,1)entry hessian matrix
R_Hess22 = diff(diff(R,phii),phii)/(1-zetaa^2) -zetaa*diff(R,zetaa); %(1,1)entry hessian matrix
R_Hess12 = diff(R,phii)*zetaa/(1-zetaa^2)+diff(diff(R,zetaa),phii);
R_Laplace = (1-zetaa^2)*diff(diff(R,zetaa),zetaa)- 2*zetaa*diff(R,zetaa)+diff(diff(R,phii),phii)/(1-zetaa^2); %Laplace Operator from R
Alpha = R_grad^2+R_grad2^2+R^2; %Alpha
N_abs = sqrt(Alpha);  %N_abs %N_abs  %ATTENTION. N_abs = sqrt(1+R_grad^2/R^2). I have taken 1/R out of the sqrt() and multiply it with R! therefore (only) sqrt(alpha)

%% Construt and assably symbolic funcitons.
mu = 0.07275;           % surface tension
rho = 1;                % density
C = (2*mu)/(YLM{1}*rho);% Bernoulli Invariant
% Compare the terms with Masther Thesis
Lambda = R_Hess11*R_grad^2+R_Hess22*R_grad2^2+R_grad2*R_grad*R_Hess12-Alpha*R_Laplace + 3*R*(R_grad^2+R_grad2^2) + 2*R^3; 
FirstTerm = qdot*R;
SecoundTerm = ((Rdot*R)/(Alpha))*((R^2*Rdot)/2 + R_grad*q_grad+R_grad2*q_grad2);
ThirdTerm = (R/(2*(Alpha)^2))*((R_grad*q_grad+R_grad2*q_grad2)^2 + R^2*(q_grad^2+q_grad2^2)+(q_grad*R_grad2-q_grad2*R_grad)^2*(2+(R_grad^2+R_grad2^2)/(R^2)));
Fourthterm = N_abs*Lambda*mu/(Alpha^2*rho);
SixthTerm = R*C;
G = FirstTerm - SecoundTerm  + ThirdTerm + Fourthterm - SixthTerm;
m=0;
FunctionH          = cell(2*Mod,1);

%% Loop for construction Functions
for ll=0:n
    for mm=-ll:ll
        FunctionH{2*(ll^2+ll+mm+1)-1}=R^ll*((R^2*Rdot - R*ll*q)*YLM{ll^2+ll+mm+1} + q*((1-zetaa^2)*diff(YLM{ll^2+ll+mm+1},zetaa)*diff(R,zetaa)+diff(YLM{ll^2+ll+mm+1},phii)*diff(R,phii)/(1-zetaa^2)));      
        FunctionH{2*(ll^2+ll+mm+1)}=G*YLM{ll^2+ll+mm+1};
    end
end

%% Python Code
newFunctionH = cell(size(FunctionH));
    
for i = 1:numel(FunctionH)
    funH = char(FunctionH{i});
    modifiedExpression = strrep(funH, '^', '.^');
    modifiedExpression = strrep(modifiedExpression, '*', '.*');
    modifiedExpression = strrep(modifiedExpression, '/', './');
    modifiedExpression = strtrim(modifiedExpression);
    modifiedExpression = strrep(modifiedExpression, 'val(zetaa) =', '');
    modifiedExpression = strtrim(modifiedExpression);
    newFunctionH{i} = str2func(['@(zetaa, phii) ', modifiedExpression]);
end
    
FunctionH = newFunctionH;

%% CalPoly1_n 
file_name = sprintf('CalPoly1_%d.m', n);
file_id = fopen(file_name, 'w');

fprintf(file_id, 'function H = CalPoly1_%d(', n);
for L = BDF-1:-1:0
    for h = 0:Mod-1
        fprintf(file_id, 'a%d_%d,', L, h);
    end
end
for L = BDF-1:-1:0
    for h = 0:Mod-1
        fprintf(file_id, 'b%d_%d,', L, h);
    end
end
fprintf(file_id, 'deltaT,Mod)\n');

fprintf(file_id, '\tH = cell(2*Mod,1);\n');

for i = 1:length(newFunctionH)
    funcStr = func2str(newFunctionH{i}); % Wandelt den Funktions-Handle in eine Zeichenkette um
    fprintf(file_id, '\tH{%d} = %s;\n', i, funcStr);
end

fprintf(file_id, 'end\n');
fclose(file_id);

%% CalPolyZeilee1_n 
file_name = sprintf('CalPolyZeilee1_%d.m', n);
file_id = fopen(file_name, 'w');

fprintf(file_id, 'function H = CalPolyZeilee1_%d(', n);
for L = BDF-1:-1:0
    for h = 0:Mod-1
        fprintf(file_id, 'a%d_%d,', L, h);
    end
end
for L = BDF-1:-1:0
    for h = 0:Mod-1
        fprintf(file_id, 'b%d_%d,', L, h);
    end
end
fprintf(file_id, 'deltaT,Zeilee,Mod)\n');

fprintf(file_id, '\tH = cell(2*Mod,1);\n');

for i = 1:length(newFunctionH)
    funcStr = func2str(newFunctionH{i}); % Wandelt den Funktions-Handle in eine Zeichenkette um
    fprintf(file_id, '\tH{%d} = %s;\n', i, funcStr);
end
fprintf(file_id, '\n\tJ = cell(1,1);\n');
fprintf(file_id, '\tfor i=0:Mod*2\n\t\tif Zeilee == i\n\t\t\t J = H{i};\n\t\t\tbreak;\n\t\tend\n\tend\n');
fprintf(file_id, 'end\n');
fclose(file_id);

%% Numerical Integration 1
file_name = 'NumIntegration1.m';
file_id = fopen(file_name, 'w');
fprintf(file_id, 'function HH = NumIntegration1(A11,A00,B11,B00,DeltaT)\n');
fprintf(file_id, "\tMod=length(A11);\n\tZU=CalPoly1_%d(", n);
for i = 1:Mod
    fprintf(file_id, "A11(%d),",i);
end
for i = 1:Mod
    fprintf(file_id, "A00(%d),",i);
end
for i = 1:Mod
    fprintf(file_id, "B11(%d),",i);
end
for i = 1:Mod
    fprintf(file_id, "B00(%d),",i);
end
fprintf(file_id, "DeltaT,Mod);\n\tHH=zeros(2*Mod,1);\n");
fprintf(file_id, "\tparfor ii = 1:2*Mod\n\t\tHH(ii)=integral2(ZU{ii},-1,1,0,2*pi,'AbsTol',10^(-12));\n\tend\n");

fprintf(file_id, 'end\n');
fclose(file_id);

%% Numerical Integration 1 Zeilee
file_name = 'NumIntegration1_Zeilee.m';
file_id = fopen(file_name, 'w');
fprintf(file_id, 'function HH = NumIntegration1_Zeilee(A11,A00,B11,B00,DeltaT,Zeilee)\n');
fprintf(file_id, "\tMod=length(A11);\n\tDenom = Zeilee/(2*Mod);\n\tisaninteger = @(x)isfinite(x) & x==floor(x);");
fprintf(file_id, "\n\tif 1==isaninteger(Denom)\n\t\tZeile = 2*Mod;\n\telse\n\t\tZeile=rem(Zeilee,2*Mod);\n\tend");
fprintf(file_id, "\n\tZU=CalPoly1_%d(", n);
for i = 1:Mod
    fprintf(file_id, "A11(%d),",i);
end
for i = 1:Mod
    fprintf(file_id, "A00(%d),",i);
end
for i = 1:Mod
    fprintf(file_id, "B11(%d),",i);
end
for i = 1:Mod
    fprintf(file_id, "B00(%d),",i);
end
fprintf(file_id, "DeltaT,Mod);\n");
fprintf(file_id, "\tHH=integral2(ZU{Zeile},-1,1,0,2*pi,'AbsTol',10^(-12));\n\tend\n");
fclose(file_id);

%% Einheitscektor
file_name = 'Einheitsvektor.m';
file_id = fopen(file_name, 'w');
fprintf(file_id, 'function E = Einheitvektor(Zeilee, Mod)\n');
fprintf(file_id, "\tDenom = Zeilee/(2*Mod);\n");
fprintf(file_id, "\tisaninteger = @(x)isfinite(x) & x==floor(x);");
fprintf(file_id, "\tif 1==isaninteger(Denom)\n\t\tSpalte = Denom;\n\telse\n\t\tSpalte=fix(Denom)+1;\n\tend\n");
fprintf(file_id, "\tE_vektor_Speicher=zeros(Mod,2*Mod);\n");
fprintf(file_id, "\tfor i=1:Mod\n");
fprintf(file_id, "\t\tE_vektor_Speicher(i,2*i)=1;\n\t\tE_vektor_Speicher(i,2*i-1)=1;\n");
fprintf(file_id, "\tend\n");
fprintf(file_id, "\tE= E_vektor_Speicher(:,Spalte);\n");
fprintf(file_id, 'end\n');
fclose(file_id);

%% Resfunction
file_name = 'Resfunction.m';
file_id = fopen(file_name, 'w');
fprintf(file_id, 'function Res = Resfunction(Residum,Zeilee,Mod)\n');
fprintf(file_id, "\tDenom = Zeilee/(2*Mod);\n");
fprintf(file_id, "\tisaninteger = @(x)isfinite(x) & x==floor(x);");
fprintf(file_id, "\tif 1==isaninteger(Denom)\n\t\tZeile1 = Mod*2;\n\telse\n\t\tZeile1=rem(Zeilee,2*Mod);\n\tend\n");
fprintf(file_id, "\tRes= Residum(Zeile1);\n");
fprintf(file_id, 'end\n');
fclose(file_id);

%% Spaltenfunction
file_name = 'Spaltenfunction.m';
file_id = fopen(file_name, 'w');
fprintf(file_id, 'function Spalte1 = Spaltenfunction(Zeilee,Mod)\n');
fprintf(file_id, "\tDenom = Zeilee/(2*Mod);\n");
fprintf(file_id, "\tisaninteger = @(x)isfinite(x) & x==floor(x);");
fprintf(file_id, "\tif 1==isaninteger(Denom)\n\t\tSpalte1 = Denom;\n\telse\n\t\tSpalte1=fix(Denom)+1;\n\tend\n");
fprintf(file_id, 'end\n');
fclose(file_id);

%% Write To Text-File
file_name = 'WriteToTextfile.m';
file_id = fopen(file_name, 'w');
fprintf(file_id, 'Name = {');
for i = 1:2*Mod
    if i < 2*Mod
        fprintf(file_id, "'%d.txt'", i);
        fprintf(file_id, ",");
    else
        fprintf(file_id, "'%d.txt'", i);
    end
end
fprintf(file_id, '};\n');
fprintf(file_id, 'comma = 0;\n');
fprintf(file_id, 'for i = 1:numel(Name)\n\tcomma = comma + sum(Name{i} == ",");\nend\ncomma = comma + 1;\n');
fprintf(file_id, "for k = 1:comma\n\tdiary (Name{k});\n\tFunctionH{k};\n\tdiary off;\nend\n");
fclose(file_id);
% end
