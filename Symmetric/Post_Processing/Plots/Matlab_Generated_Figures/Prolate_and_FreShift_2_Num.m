%% Postprocessing;
%% 27.11.2024
%% Akbari && Noori
%% Frequency Shift! For Init 2
%% Initialisierung
clc 
clear all
%% Files Loading Path
base_path = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
TimeStep = 'DeltaT_0_001';
TimeSteppScheme = 'BDF_2' ;
cd(base_path); % Verzeichniswechsel
% Definiere die Werte, die in den Dateinamen vorkommen
X_values = [30, 40, 50, 60, 70, 80];
% Initialisiere eine leere Matrix
Init_2_Ratios = [];
% Schleife zum Laden und direktes Zusammenfügen
for x = X_values
    filename = sprintf('Ratio_12_2_%d_BDF_2_DeltaT_0_001.txt', x);
    Init_2_Ratios = [Init_2_Ratios; load(filename)];
end
Init_2_Zeros   = load(['Init_2_',TimeSteppScheme,'_',TimeStep,'_Zeros.txt']);
load('Prolate_and_Fre_Shift_2_ALL_Literatur.mat');
% Loading Time Steps
Zeitschritte_   = load(['..\Vector_Storages','\',TimeSteppScheme,'\', TimeStep,'\12_4_24\12_4_24_GesamtZeitschritt_Speicher1.txt']);
t               = [0 cumsum(Zeitschritte_(1:end-1))];
% Naming for plots
s1 = 'Frequency_Shift_Prolongated_';
s2 = '2_';
s3 = date;
%% Calculate Frequency Shift and Prolongate Time
h = @(l) sqrt((0.07275*l*(l+2)*(l-1))/(1/(2*sqrt(pi)))^3);  % Reighleigh Frequency
% Initialisierung für Frequency Shift
Frequency_with_dim_S = zeros(length(Init_2_Zeros(:,1)),2);
% Initialisierung für Prologate Time
Prolongate_Time = zeros(length(Init_2_Zeros(:,1)),2);
for Spalte=1:2 % Zwei Oscillationen
    for Zeile=1:length(Init_2_Zeros(:,1))
    Frequency_with_dim_S(Zeile,Spalte) = t(Init_2_Zeros(Zeile,2*Spalte+1)) - t(Init_2_Zeros(Zeile,2*Spalte-1));
    Prolongate_Time(Zeile,Spalte) = (t(Init_2_Zeros(Zeile,2*Spalte+1)) - t(Init_2_Zeros(Zeile,2*Spalte)))./Frequency_with_dim_S(Zeile,Spalte);
    end
end
Frequency_Shift = (2*pi/h(2)-Frequency_with_dim_S)./Frequency_with_dim_S;
% Statistics
Frequency_Shift_Mean = mean(Frequency_Shift');
Frequency_Shift_Std = std(Frequency_Shift');
Prolongate_Time_mean = mean(Prolongate_Time');
Prolongate_Time_std = std(Prolongate_Time');
%% Plot sublplot 1
figure
subplot(1,2,1)
hold on
plot(Init_2_Ratios,100*Frequency_Shift_Mean,'-s','color',[114 16 133]/255,'linewidth',2,'MarkerSize',7)    %GNT 10 Mean
plot(meanWithSDevLW(:,1),meanWithSDevLW(:,2)*100,'-<','color',[0 157 129]/255,'MarkerSize',7)                   %Dino Mean
plot(meanWithSDevLWTsamopBrown(:,1),meanWithSDevLWTsamopBrown(:,2)*100,'-x','color',[166 0 132]/255,'MarkerSize',5) %TB Mean
plot(F_S_Basaran_1992_Asp(:,1),F_S_Basaran_1992_Asp(:,2),'h','color',[0 131 204]/255,'MarkerSize',10)          %Basaran Mean
plot(F_S_Patzek_1991_Asp(:,1),F_S_Patzek_1991_Asp(:,2),'*','color',[166 0 132]/255,'MarkerSize',10)             %Patzek
plot(F_S_Merajin_2001_Asp(:,1),F_S_Merajin_2001_Asp(:,2),'-','color',[153 192 0]/255,'linewidth',2)             %Meradji
plot(F_S_Wang_1982_Asp(:,1),F_S_Wang_1982_Asp(:,2),'v','color',[0 90 169]/255,'linewidth',3)                    %Wang1992
grid on
grid minor
xlabl = xlabel('L/W','FontSize',14);
ylabl = ylabel('$\Delta \omega_{2}$ in $\%$','FontSize',14);
set(gca,'Fontsize',14); 
set(xlabl,'Interpreter','latex')
set(ylabl,'Interpreter','latex')
Tabl = title('(a)','FontSize',14);
set(Tabl,'Interpreter','latex')
%% Plot subplot 2
subplot(1,2,2)
hold on
plot(Init_2_Ratios,100*Prolongate_Time_mean,'-s','color',[114 16 133]/255,'linewidth',2,'MarkerSize',7)    %GNT 10 Mean
plot(prolateTwithLW(:,1),prolateTwithLW(:,2),'-<','color',[0 157 129]/255,'MarkerSize',7)                       %Dino Mean
plot(prolateTwithLWTsamopBrown(:,1),prolateTwithLWTsamopBrown(:,2),'-x','color',[166 0 132]/255,'MarkerSize',5) %TB Mean
plot(P_T_Basaran_1992_Asp(:,1),P_T_Basaran_1992_Asp(:,2),'h','color',[0 131 204]/255,'MarkerSize',10)          %Basaran Mean
plot(P_T_Patzek_1991_Asp(:,1),P_T_Patzek_1991_Asp(:,2),'*','color',[166 0 132]/255,'MarkerSize',10)             %Patzek
plot(P_T_Foote_1973_Asp(:,1),P_T_Foote_1973_Asp(:,2),':','color',[253 202 0]/255,'linewidth',3)                 %Foote
plot(P_T_Merajin_2001_Asp(:,1),P_T_Merajin_2001_Asp(:,2),'-','color',[153 192 0]/255,'linewidth',2)             %Meradji
plot(P_T_Wang_1982_Asp(:,1),P_T_Wang_1982_Asp(:,2),'v','color',[0 90 169]/255,'linewidth',3)                    %Wang1992
grid on
grid minor
ylabl = ylabel('$\mathcal{P}$ in  $\%$','FontSize',14);
set(gca,'Fontsize',14); 
xlabl = xlabel('L/W','FontSize',16);
set(ylabl,'Interpreter','latex')
set(xlabl,'Interpreter','latex')
Tabl = title('(b)','FontSize',14);
set(Tabl,'Interpreter','latex')
lgd = legend('GNLT','Z and B (2021)','T and B (1983)','Basaran (1992)','Patzek et al. (1991)','Foote (1973)','Meradji et al. (2001)','T and W (1982)','Location','SouthEast');
lgd.FontSize = 14;
% Setze zuerst die Legenden-Einheit auf Pixel
lgd.Units = 'pixels';
ldg_x0=770; 
ldg_y0=65;
ldg_width=200;
ldg_height=200;
lgd.Position = [ldg_x0, ldg_y0, ldg_width, ldg_height];
 xlim([1 4])
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