%% Initialization
%% Schahin Akbari 
%% 28/11/2024
%% 15:35
clc
clear all
n=6;
Mod = (n+1)^2;
YLM  = cell(Mod,1);
BDF = 2;
%% Creat Spherical Harmonics
 for L=0:n           % L = degree
     for m= -L:L        % M = Order
          YLM{L^2+L+m+1} = SphericalHarmonics(L,m);    % Single Spherical Harmonics
     end
 end
%% Variables and assignmens
syms zetaa
syms phii
syms deltaT 
syms wn
syms C
AA2=cell(length(YLM),1);AA1=cell(length(YLM),1);AA0=cell(length(YLM),1);
BB2=cell(length(YLM),1);BB1=cell(length(YLM),1);BB0=cell(length(YLM),1);
for i = 0:2 
    for j = 0:Mod-1
     syms(['a', num2str(i), '_', num2str(j)]);
     syms(['b', num2str(i), '_',num2str(j)]); 
    end
end
for k = 1:Mod
        AA0{k} = eval(['a', num2str(0), '_',num2str((k-1))]);
        AA1{k} = eval(['a', num2str(1), '_',num2str((k-1))]);
        AA2{k} = eval(['a', num2str(2), '_',num2str((k-1))]);
        BB0{k} = eval(['b', num2str(0), '_',num2str((k-1))]);
        BB1{k} = eval(['b', num2str(1), '_',num2str((k-1))]);
        BB2{k} = eval(['b', num2str(2), '_',num2str((k-1))]);
 end

H = zeros(2*Mod,1);
%% Create R and q and timederrivates R_dot and q_dot 
R0=0;R1=0;R2=0;
q0=0;q1=0;q2=0;
Rdot1=0;Rdot2=0;

for i=1:length(YLM)     % Constructing Polynomials
    R2= AA2{i}*YLM{i}+R2;        
    % Rdot2= (((3*AA2{i}-4*AA1{i}+1*AA0{i})*YLM{i})/(2*deltaT))+Rdot2; %Rdot with BDF2
    Rdot2= ((((1+2*wn)*AA2{i}-(1+wn)*(1+wn)*AA1{i}+wn*wn*AA0{i})*YLM{i})/((1+wn)*deltaT))+Rdot2; %Rdot with BDF2
    q2= BB2{i}*YLM{i}+q2;                           
    %%%%%%%%%%%%%%%%%%%%%
    R1= AA1{i}*YLM{i}+R1;
    Rdot1= (((AA1{i}-AA0{i})*YLM{i})/deltaT)+Rdot1; %Rdot with BDF1
    q1= BB1{i}*YLM{i}+q1; 
    %%%%%%%%%%%%%%%%%%%%%%
    R0= AA0{i}*YLM{i}+R0;
    q0= BB0{i}*YLM{i}+q0; 
end
%% Zeitschritt 0
dA0 =  sqrt(-R0^2*(diff(R0,zetaa)^2*zetaa^4 - 2*diff(R0,zetaa)^2*zetaa^2 - R0^2*zetaa^2 + diff(R0,zetaa)^2 + R0^2 + diff(R0,phii)^2)/(zetaa^2 - 1)); % Tropfenoberfäche  % Bestätigung
dV0 = (R0^3)/3;                                                    % Tropfenvolumen              % Bestätigung
%% Zeitschritt 1
dA1 =  sqrt(-R1^2*(diff(R1,zetaa)^2*zetaa^4 - 2*diff(R1,zetaa)^2*zetaa^2 - R1^2*zetaa^2 + diff(R1,zetaa)^2 + R1^2 + diff(R1,phii)^2)/(zetaa^2 - 1)); % Tropfenoberfäche  % Bestätigung
dV1 = (R1^3)/3;                                                    % Tropfenvolumen              % Bestätigung
dE_Kin1  = q1*Rdot1*R1^2;                                          % Kinetische Energie          % Bestätigung
%% Zeitschritt 2 und danach
dA2 =  sqrt(-R2^2*(diff(R2,zetaa)^2*zetaa^4 - 2*diff(R2,zetaa)^2*zetaa^2 - R2^2*zetaa^2 + diff(R2,zetaa)^2 + R2^2 + diff(R2,phii)^2)/(zetaa^2 - 1)); % Tropfenoberfäche  % Bestätigung
dV2 = (R2^3)/3;                                                      % Tropfenvolumen              % Bestätigung
dE_Kin2  = q2*Rdot2*R2^2;                                              % Kinetische Energie          % Bestätigung
% dS_X= R^4*sqrt(1-zetaa^2)*cos(phii)/4;                           % Schwerpunkt in X Achse      % Bestätigung
% dS_Y= R^4*sqrt(1-zetaa^2)*sin(phii)/4;                           % Schwerpunkt in Y Achse      % Bestätigung
% dS_Z= R^4*zetaa/4;                                               % Schwerpunkt in Z Achse      % Bestätigung
%% 
da0=char(dA0);da1=char(dA1);da2=char(dA2);
dv0=char(dV0);dv1=char(dV1);dv2=char(dV2);
de_Kin1=char(dE_Kin1);de_Kin2=char(dE_Kin2);

da0 = StringManipulator(da0); 
da1 = StringManipulator(da1);
da2 = StringManipulator(da2);

dv0 = StringManipulator(dv0);
dv1 = StringManipulator(dv1);
dv2 = StringManipulator(dv2);

de_Kin1 = StringManipulator(de_Kin1);
de_Kin2 = StringManipulator(de_Kin2);

