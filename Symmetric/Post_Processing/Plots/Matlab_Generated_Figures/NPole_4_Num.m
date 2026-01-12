%% Postprocessing;
%% 27.11.2024
%% Akbari && Noori
%% North Pole time Behaviour
%% Initialisierung
clc 
clear all
%% Files Loading Path
base_path = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
cd(base_path); % Verzeichniswechsel

TimeStep = 'DeltaT_0_001';
TimeSteppScheme = 'BDF_2' ;

NPol_12_4_35 = load(['Nord_Pol_Rel_Num_12_4_35_',TimeSteppScheme,'_',TimeStep,'.txt']);
NPol_12_4_24 = load(['Nord_Pol_Rel_Num_12_4_24_',TimeSteppScheme,'_',TimeStep,'.txt']);
load('Z_and_B_2022.mat');
load('L_and_M_1988.mat');
% Loading Time Steps
Zeitschritte_   = load(['..\Vector_Storages\','\',TimeSteppScheme,'\',TimeStep,'\12_4_24\12_4_24_GesamtZeitschritt_Speicher1.txt']);
t               = [0 cumsum(Zeitschritte_(1:end-1))];
% Entdimensionalisierung
Volumen_abs_4_24= load(['Volumen_Abs_Num_12_4_24_',TimeSteppScheme,'_',TimeStep,'.txt']);
R0              = 1/(sqrt(pi)*2); % Non-dimensionalisation
t_star_4_24     =  sqrt((0.07275)/(R0^3))';
Volumen_abs_4_35= load(['Volumen_Abs_Num_12_4_24_',TimeSteppScheme,'_',TimeStep,'.txt']);
t_star_4_35     =  sqrt((0.07275)/(R0^3))';
% Funktion zur Nullstellenberechnung (Zeichenwechsel)
zci = @(v) find(v(1:end-1) .* v(2:end) <= 0);
% Berechnung der Nullstellen
zeros = zci(NPol_12_4_35); % Nullstellen der aktuellen Datei
% Naming for plots
s1 = 'NPole_4_Num_';
s2 = 'all_';
s3 = date;
%% Plots
figure
hold on
plot(L_and_M_1988(:,1)/sqrt(2),L_and_M_1988(:,2)*0.3,'-.','Color',[201 212 0]/255,'LineWidth',2)
plot(t*t_star_4_24, NPol_12_4_35,'--','color',[114 16 133]/255,'linewidth',2)
plot(Z_and_B_2022(:,1),Z_and_B_2022(:,2),':','color',[0 0 0]/255,'linewidth',2)
plot(t*t_star_4_35, NPol_12_4_24,'-','color',[245 163 0]/255,'linewidth',2)
plot(t(zeros(1))*t_star_4_35,NPol_12_4_35(zeros(1)),'x','color',[0 0 0]/255,'MarkerSize',15,'LineWidth',2)
plot(t(zeros(2))*t_star_4_35,NPol_12_4_35(zeros(2)),'+','color',[0 0 0]/255,'MarkerSize',15,'LineWidth',2)
plot(t(zeros(3))*t_star_4_35,NPol_12_4_35(zeros(3)),'*','color',[0 0 0]/255,'MarkerSize',15,'LineWidth',2)
plot(t(474)*t_star_4_35,NPol_12_4_35(474),'h','color',[0 0 0]/255,'MarkerSize',15,'LineWidth',2)

plot([t(zeros(1))*t_star_4_35 t(zeros(1))*t_star_4_35],[NPol_12_4_35(zeros(1)) -0.80],'-','color',[0 0 0]/255,'LineWidth',2)
plot([t(zeros(3))*t_star_4_35 t(zeros(3))*t_star_4_35],[NPol_12_4_35(zeros(3)) -0.80],'-','color',[0 0 0]/255,'LineWidth',2)
plot([t(zeros(1))*t_star_4_35 t(zeros(3))*t_star_4_35],[-0.7 -0.7],'-','color',[0 0 0]/255,'LineWidth',2)
txt_min_5 = '$\tau_{(4)}$';
text((t(zeros(1))*t_star_4_35+t(zeros(3))*t_star_4_35)/2+0.10,-0.78,txt_min_5,'Interpreter','latex','FontSize',18,'HorizontalAlignment','right','color',[0 0 0]/255)

plot([t(zeros(2))*t_star_4_35 t(zeros(2))*t_star_4_35],[NPol_12_4_35(zeros(3)) -0.55],'-','color',[0 0 0]/255,'LineWidth',2)
plot([t(zeros(2))*t_star_4_35 t(zeros(3))*t_star_4_35],[-0.45 -0.45],'-','color',[0 0 0]/255,'LineWidth',2)
txt_min_5 = '$\tau^{P}_{(4)}$';
text(t(zeros(2))*t_star_4_35+t(zeros(3))*t_star_4_35*1/3,-0.55,txt_min_5,'Interpreter','latex','FontSize',17,'HorizontalAlignment','right','color',[0 0 0]/255)
grid on
grid minor
%% Plot Settings
xlabl = xlabel('$t$','FontSize',14);
ylabl = ylabel('$\mathcal{N}$','FontSize',14);
set(gca,'Fontsize',14); 
set(xlabl,'Interpreter','latex')
set(ylabl,'Interpreter','latex')
lgd = legend({'L and M (1988), ($a_4(0) \approx 0.35$)','GNLT ($a_4(0)=0.35$)','Z and B (2021), ($a_4(0) \approx 0.24$)','GNLT ($a_4(0)=0.24$)','$t_{1}$','$t_{2}$','$t_{3}$','$t^{M}$'},'Location','SouthEast','NumColumns',2);
set(lgd,'Interpreter','latex')
lgd.FontSize = 14;
xlim([0 5.5])
ylim([-0.9 0.6])
%% Plot Size and Saving as esp
x0=0; 
y0=0;
width=1000;
height=400;
set(gcf,'position',[x0,y0,width,height])

cd '..\..\Plots\Code'
s0 = '..\Figures\';
s = strcat(s0,s1,s2,TimeSteppScheme,'_',TimeStep,'_',s3);
print2eps(s,gcf())