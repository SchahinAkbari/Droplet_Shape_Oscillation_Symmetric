%% Postprocessing;
%% 04.04.2025
%% Coefficients Time Behaviour
%% Initialisierung
% Laden der Daten
clc
clear all
%% Naming and Load Files
base_path = '..\..\Data\Vector_Storages';
TimeStep = 'DeltaT_0_001';
TimeSteppScheme = 'BDF_2' ;

A00=60/(200*sqrt(pi));      % Normalization  

full_path = fullfile(base_path,'\', TimeSteppScheme, '\', TimeStep,'\', '12_2_60_5_5'); % Kombiniere den Pfad mit der Name_ID
cd(full_path); % Verzeichniswechsel 
A_12_2_60_5_5_star = load(['12_2_60_5_5_', 'VectorSpeicherA.txt'])/A00; 
T_12_2_60_5_5      = load(['12_2_60_5_5_', 'GesamtZeitschritt_Speicher1.txt']);
Volumen_abs_12_2_60_5_5     = load(['..\..\..\..\Energy_Volume_Area_Center_Of_Mass\Volumen_Abs_Num_','12_2_60_5_5','_',TimeSteppScheme, '_',TimeStep, '.txt']);
%R0                  = ((3*Volumen_abs_12_2_60_5_5(1))/(4*pi))^(1/3);
R0 = 1/(sqrt(pi)*2); % Non-dimensionalisation
t_star              =  sqrt((0.07275)/(R0^3))';
T_12_2_60_5_5_star = cumsum(T_12_2_60_5_5*t_star);

full_path = fullfile('..\', '12_2_60'); % Kombiniere den Pfad mit der Name_ID
cd(full_path); % Verzeichniswechsel 
A_12_2_60_star = load(['12_2_60', '_VectorSpeicherA.txt'])/A00; 
T_12_2_60      = load(['12_2_60', '_GesamtZeitschritt_Speicher1.txt']);
Volumen_abs_12_2_60     = load(['..\..\..\..\Energy_Volume_Area_Center_Of_Mass\Volumen_Abs_Num_','12_2_60','_',TimeSteppScheme, '_',TimeStep, '.txt']);
%R0                  = ((3*Volumen_abs_12_2_60(1))/(4*pi))^(1/3);
R0 = 1/(sqrt(pi)*2); % Non-dimensionalisation
t_star              =  sqrt((0.07275)/(R0^3))';
T_12_2_60_star = cumsum(T_12_2_60*t_star);

full_path = fullfile('..\', '12_5_5'); % Kombiniere den Pfad mit der Name_ID
cd(full_path); % Verzeichniswechsel 
A_12_5_5_star = load(['12_5_5', '_VectorSpeicherA.txt'])/A00; 
T_12_5_5      = load(['12_5_5', '_GesamtZeitschritt_Speicher1.txt']);
Volumen_abs_12_5_5     = load(['..\..\..\..\Energy_Volume_Area_Center_Of_Mass\Volumen_Abs_Num_','12_5_5','_',TimeSteppScheme, '_',TimeStep, '.txt']);
%R0                  = ((3*Volumen_abs_12_5_5(1))/(4*pi))^(1/3);
R0 = 1/(sqrt(pi)*2); % Non-dimensionalisation
t_star              =  sqrt((0.07275)/(R0^3))';
T_12_5_5_star = cumsum(T_12_5_5*t_star);

Colors = {[114 16 133]/255, [0 157 129]/255, [230 0 26]/255, [245 163 0]/255,[0 0 0]/255}; % Farben
%% Naming for plots
s1 = 'Coeffs_';
s2 = 'Comparison_2_60_5_5_a2_';
s3 = date;
%% Plot
figure    
set(gca,'Fontsize',20); 
hold on
CutOff = length(A_12_2_60_star(1,:))-25000;     % Cut Off, after 5 Oscillation 
plot(T_12_2_60_5_5_star(1:10:CutOff),A_12_2_60_5_5_star(3,1:10:CutOff),'-.','color','k','LineWidth',2)
plot(T_12_2_60_star(1:10:CutOff),A_12_2_60_star(3,1:10:CutOff),'--','color',Colors{1},'LineWidth',2)
plot(T_12_5_5_star(1:10:CutOff),A_12_5_5_star(3,1:10:CutOff),'-','color',Colors{2},'LineWidth',2)
grid on
grid minor

xlabl = xlabel('$t$','FontSize',14);
set(xlabl,'Interpreter','latex')

ylabl = ylabel('$a_2^{*}(t)$','FontSize',14);
set(ylabl,'Interpreter','latex')

set(gca,'Fontsize',20); 
legendEntry = [{'$(a_2(0)=0.60, a_5(0)=0.05)$'},{'$a_2(0)=0.60$'},{'$a_5(0)=0.05$'}];
lgd = legend(legendEntry,'Location','SouthEast','Interpreter','latex','FontSize',14 );
x0=0;
y0=0;
width=1000;
height=300;
set(gcf,'position',[x0,y0,width,height])         
%% Saving Pictures
cd '..\..\..\..\..\Plots\Code'
s0 = '..\Figures\';
s = strcat(s0,s1,s2,'_',TimeSteppScheme,'_',TimeStep,'_',s3);
print2eps(s,gcf())

