%% Postprocessing;
%% 28.11.2024
%% Akbari && Noori
%% Oscillation plots For all
%% Initialisierung
clc 
clear all
%% Files Loading Path
base_path = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
cd(base_path); % Verzeichniswechsel
%% Naming, Colors and Shapes
% Load Name of Value
Name_of_Value   = 'Nord_Pol_Rel_Num_';
TimeStep = 'DeltaT_0_001';
Cuffoff_degree = '12';
TimeSteppScheme = 'BDF_2' ;
Name_of_Volume  = 'Volumen_Abs_Num_';
Init_Deformations = {'2', '3', '4', '5', '6'}; % Namen für Zeros-Matrizen
Names_Groups = {...
    {'12_2_80','12_2_70','12_2_60', '12_2_50', '12_2_40', '12_2_30'                       }, ...
    {                               '12_3_50', '12_3_40', '12_3_30' , '12_3_20', '12_3_10'}, ...
    {                                                     '12_4_30' , '12_4_20', '12_4_10'}, ...
    {                                                                 '12_5_20', '12_5_10'}, ...
    {                                                                            '12_6_10'} ...
};
Colors = {[114 16 133]/255, [0 157 129]/255, [230 0 26]/255, [245 163 0]/255,[0 0 0]/255}; % Farben
Format = {'-', '-.',':','--',':'};
Makers = {'x','o','p','s','^'};
% Initialisierung für Legende
legendEntries = {}; % Array für Legendentexte
% Naming for plots
s1 = 'Frequency_Shift_Prolongated_';
s2 = 'all_';
s3 = date;
% Load Data from Zrinic and Brenn
load(['Prolate_and_Fre_Shift_2_ALL_Literatur.mat']);
%% Funktion zur Nullstellenberechnung (Zeichenwechsel)
zci = @(v) find(v(1:end-1) .* v(2:end) <= 0);
%% Iteriere über alle Gruppen und speichere Zeros mit passendem Namen
for groupIdx = 1:length(Names_Groups)
    currentGroup = Names_Groups{groupIdx};
    currentName = Init_Deformations{groupIdx}; % Name der Initialdeformation
    zeros= load(['Int', '_' , Cuffoff_degree,'_',currentName,'_',TimeSteppScheme,'_', TimeStep,'_Zeros', '.txt']); 
    % Initialisiere Matrix für Volumen
    numFiles = length(currentGroup);
    % Schleife für jede Datei in der aktuellen Gruppe
    % Loading Time Steps
    Zeitschritte_   = load(['..\Vector_Storages\',TimeSteppScheme,'\',TimeStep,'\',currentGroup{1},'\',currentGroup{1} ,'_GesamtZeitschritt_Speicher1.txt']);
    t               = [0 cumsum(Zeitschritte_(1:end-1))];
    %% Calculate Frequency Shift and Prolongate Time
    h = @(l) sqrt((0.07275*l*(l+2)*(l-1))/(1/(2*sqrt(pi)))^3);  % Reighleigh Frequency
    % Initialisierung für Frequency Shift
    Frequency_with_dim_S = zeros(length(zeros(:,1)),2);
    % Initialisierung für Prologate Time
    Prolongate_Time = zeros(length(zeros(:,1)),2);
    for Spalte=1:2 % Zwei Oscillationen
        for Zeile=1:length(zeros(:,1))
        Frequency_with_dim_S(Zeile,Spalte) = t(zeros(Zeile,2*Spalte+1)) - t(zeros(Zeile,2*Spalte-1));
            if false == ~rem(groupIdx,2)
            Prolongate_Time(Zeile,Spalte) = (t(zeros(Zeile,2*Spalte+1)) - t(zeros(Zeile,2*Spalte)))./Frequency_with_dim_S(Zeile,Spalte);
            else
            Prolongate_Time(Zeile,Spalte) = (t(zeros(Zeile,2*Spalte)) - t(zeros(Zeile,2*Spalte-1)))./Frequency_with_dim_S(Zeile,Spalte);
            end
        end
    end
    Frequency_Shift = (2*pi/h(groupIdx+1)-Frequency_with_dim_S)./Frequency_with_dim_S;
    % Statistics
    Frequency_Shift_Mean = flip(mean(Frequency_Shift'));
    Frequency_Shift_Std = flip(std(Frequency_Shift'));
    Prolongate_Time_mean = flip(mean(Prolongate_Time'));
    Prolongate_Time_std = flip(std(Prolongate_Time'));
    for fileIdx = 1:numFiles
        parts = split(currentGroup{fileIdx}, '_'); % Teile den String anhand von '_'
        Ampitude = str2double(parts{end});  % Letzte zwei Ziffern extrahieren und in Amplitude umwandeln    
        Init_Def_Mode = parts{2};  % Mittlere Ziffern für  Inital Deformation Mode
        subplot(1,2,1)
        hold on
            if fileIdx==1
            handVisibility = 'on';
            else
            handVisibility = 'off';
            end
            if groupIdx == 1
            plot(Ampitude/100,Frequency_Shift_Mean(fileIdx)*100,Makers{groupIdx}, ...
            'color',Colors{groupIdx},'MarkerSize',15,'LineWidth',2.5, 'HandleVisibility', handVisibility)
            else
            plot(Ampitude/100,Frequency_Shift_Mean(fileIdx)*100,Makers{groupIdx},'MarkerEdgeColor',...
            [0 0 0]/255,'MarkerFaceColor',Colors{groupIdx},'MarkerSize',10, 'HandleVisibility', handVisibility)    
            end
            subplot(1,2,2)
            hold on
            if groupIdx == 1
            plot(Ampitude/100,Prolongate_Time_mean(fileIdx)*100,Makers{groupIdx}, ...
            'color',Colors{groupIdx},'MarkerSize',15,'LineWidth',2.5, 'HandleVisibility', handVisibility)
            else
            plot(Ampitude/100,Prolongate_Time_mean(fileIdx)*100,Makers{groupIdx},'MarkerEdgeColor',...
            [0 0 0]/255,'MarkerFaceColor',Colors{groupIdx},'MarkerSize',10, 'HandleVisibility', handVisibility)    
            end
    end
    subplot(1,2,2)
    legendEntries{end+1} = ['GNLT $\ell=', Init_Def_Mode, '$'];
    set(gca,'Fontsize',14); 
end
%% Add data of Zrinic and Brenn
% ============================================================
% Conversion factors between Legendre polynomials P_l(cosθ)
% and spherical harmonics Y_l^0(θ,φ)
%
% General formula:
%   Y_l^0(θ,φ) = sqrt((2*l + 1) / (4*pi)) * P_l(cosθ)
%
% or equivalently:
%   P_l(cosθ)  = sqrt((4*pi) / (2*l + 1)) * Y_l^0(θ,φ)
%
% ------------------------------------------------------------
% For l = 2:
%   Factor = sqrt(5 / (4*pi))  ≈ 0.630
%
% For l = 3:
%   Factor = sqrt(7 / (4*pi))  ≈ 0.748
%
% For l = 4:
%   Factor = sqrt(9 / (4*pi))  ≈ 0.848
%
% Therefore:
%   Y_2^0 = 0.630 * P_2(cosθ)
%   Y_3^0 = 0.748 * P_3(cosθ)
%   Y_4^0 = 0.848 * P_4(cosθ)
subplot(1,2,1)
hold on
plot(m2MeanWithSDDevEta0(:,1)/sqrt(5 / (4*pi)),m2MeanWithSDDevEta0(:,2)*100,'-','color',[114 16 133]/255,'Linewidth',1.5)                       %Dino Mean
plot(m3MeanWithSDDevEta0(:,1)/sqrt(7 / (4*pi)),m3MeanWithSDDevEta0(:,2)*100,'-','color', [0 157 129]/255,'Linewidth',1.5)                       %Dino Mean
plot(m4MeanWithSDDevEta0(:,1)/sqrt(9 / (4*pi)),m4MeanWithSDDevEta0(:,2)*100,'-','color',[230 0 26]/255,'Linewidth',1.5)                       %Dino Mean
subplot(1,2,2)
hold on
plot(m2prolateTwithEta0(:,1)/sqrt(5 / (4*pi)),m2prolateTwithEta0(:,2),'-','color',[114 16 133]/255,'Linewidth',1.5)                       %Dino Mean
plot(m3prolateTwithEta0(:,1)/sqrt(7 / (4*pi)),m3prolateTwithEta0(:,2),'-','color', [0 157 129]/255,'Linewidth',1.5)                       %Dino Mean
plot(m4prolateTwithEta0(1:31,1)/sqrt(9 / (4*pi)),m4prolateTwithEta0(1:31,2),'-','color',[230 0 26]/255,'Linewidth',1.5)                         %Dino Mean
legendEntries{end+1} = 'WNLT $\ell=2$';
legendEntries{end+1} = 'WNLT $\ell=3$';
legendEntries{end+1} = 'WNLT $\ell=4$';
legendEntries{end+1} = ' ';
legendEntries{end+1} = ' ';
% %% Dummy Legend Entries 
% % Anzahl der Dummy-Zeilen für zweite Spalte
% dummyCount = 2;
% 
% % Erzeuge unsichtbare Dummy-Handles
% dummyHandles = gobjects(dummyCount,1);
% for k = 1:dummyCount
%     dummyHandles(k) = plot(nan, nan, 'HandleVisibility', 'off');
% end
% 
% % Dummy-Texte (werden ignoriert)
% dummyTexts = repmat({''}, dummyCount, 1);
% 
% % Neue Legendeneintragsliste erstellen
% legendHandles = [lgdHandles; dummyHandles];   % lgdHandles = echte Handles! Siehe unten
% legendTexts   = [legendEntries(:); dummyTexts];

%% Erstelle die Legende nach der Schleife und weitere Einstellungen
% lgd = legend(legendEntries, 'Location', 'NorthEast', 'NumColumns', 2, 'Interpreter', 'latex');
lgd = legend(legendEntries, 'Location', 'NorthEast', 'NumColumns', 2, 'Interpreter', 'latex');
title('(b)','FontSize',14,'Interpreter','latex');
xlabel('$a_{\ell}(0)$','FontSize',14,'Interpreter','latex');
ylabel('$\mathcal{P}$ in  $\%$','FontSize',14,'Interpreter','latex');
set(gca,'Fontsize',14); 
ylim([50 80])
xlim([0 1])
grid on
grid minor
subplot(1,2,1)
title('(a)','FontSize',14,'Interpreter','latex');
xlabel('$a_{\ell}(0)$','FontSize',14,'Interpreter','latex');
ylabel('$\Delta \omega_{\ell}$ in $\%$','FontSize',14,'Interpreter','latex');
set(gca,'Fontsize',14); 
ylim([-30 5])
xlim([0 1])
grid on
grid minor
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