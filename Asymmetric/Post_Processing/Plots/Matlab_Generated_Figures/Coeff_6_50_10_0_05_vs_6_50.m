%% Postprocessing;
%% 26.05.2025
%% Berechnung der Tropfenkenngroesseen: 
%% Radius, Volumen, Oberflaeche, und Schwerpunkt, Energie
%% Initialisierung
% Laden der Daten
clc
clear all
%% Naming and Load Files
base_path = '..\..\Data\Vector_Storages\L6\';
TimeStep = 'DeltaT_0_01';
deltaT = 0.01;
A00=1/(2*sqrt(pi));      % Normalization  

% % Finde ersten Eintrag der == 0 ist.
% % Trimme die Matritzen A und B!
% firstZeroIndex = find(A(1,:) == 0, 1)-1;
% A = A(:, 1:firstZeroIndex);
% B = B(:, 1:firstZeroIndex);

full_path = fullfile(base_path,'\',TimeStep,'\', '6_6_50_10_0_05'); % Kombiniere den Pfad mit der Name_ID
cd(full_path); % Verzeichniswechsel 

A_coupled  = load(['6_10_1_118', 'VectorSpeicherA.txt'])/A00; 
firstZeroIndex = find(A_coupled(1,:) == 0, 1)-1;
A_coupled = A_coupled(:, 1:firstZeroIndex);

T_coupled      = 0:deltaT:(length(A_coupled(1,:))-1)*deltaT;

Volumen_coupled     = load(['..\..\..\..\Energy_Volume_Area_Center_Of_Mass\Volumen_Abs_Num_','6_6_50_10_0_05', '.txt']);
R0                  = ((3*Volumen_coupled(1))/(4*pi))^(1/3);
t_star              =  sqrt((0.07275)/(R0^3))';
T_coupled_star      =  T_coupled*t_star;



full_path = fullfile('..\', '6_6_50_193'); % Kombiniere den Pfad mit der Name_ID
cd(full_path); % Verzeichniswechsel 
A_single = load(['6_6_50_193', 'VectorSpeicherA.txt'])/A00; 
firstZeroIndex = find(A_single(1,:) == 0, 1)-1;
A_single = A_single(:, 1:firstZeroIndex);

T_single      = 0:deltaT:(length(A_single(1,:))-1)*deltaT;
Volumen_single     = load(['..\..\..\..\Energy_Volume_Area_Center_Of_Mass\Volumen_Abs_Num_','6_6_50_193', '.txt']);
R0                  = ((3*Volumen_single(1))/(4*pi))^(1/3);
t_star              =  sqrt((0.07275)/(R0^3))';
T_single_star =  T_single*t_star;

Colors = {[114 16 133]/255, [0 157 129]/255, [230 0 26]/255, [245 163 0]/255,[0 0 0]/255}; % Farben
%% Naming for plots
s1 = 'Coeffs_';
coeff = 10;
s2 = ['Comparison_6_50_10_0_05_a' num2str(coeff) '_'];
s3 = date;
%% Plot
figure    
set(gca,'Fontsize',20); 
hold on
plot(T_coupled_star,A_coupled(coeff,:),'-.','color','k','LineWidth',2)
plot(T_single_star,A_single(coeff,:),'--','color',Colors{1},'LineWidth',2)
grid on
grid minor

xlabl = xlabel('$t$','FontSize',14);
set(xlabl,'Interpreter','latex')

ylabl = ylabel('$a_2^{-1}(t)$','FontSize',14);
set(ylabl,'Interpreter','latex')

set(gca,'Fontsize',20); 
legendEntry = [{'$(a_2^{-1}(0)=0.5, a_3^{-3}(0)=0.05)$'},{'$a_2^{-1}(0)=0.5$'}];
lgd = legend(legendEntry,'Location','SouthEast','Interpreter','latex','FontSize',14 );
x0=0;
y0=0;
width=1000;
height=300;
set(gcf,'position',[x0,y0,width,height])         
%% Saving Pictures
cd '..\..\..\..\..\Plots\Code'
s0 = '..\Figures\';
s = strcat(s0,s1,s2,TimeStep,'_',s3);
print2eps(s,gcf())
