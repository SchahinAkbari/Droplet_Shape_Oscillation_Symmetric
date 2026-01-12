%% Postprocessing;
%% 23.09.2025
%% Akbari && Noori
%% BDF1 vs BDF2
%% Initialisierung
clc 
clear all
%% Files Loading Path
base_path = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
cd(base_path); % Verzeichniswechsel
%% Naming, Colors and Shapes
% Load Name of Value
Name_of_Value = 'E_Ges_Rel_Num_';
Name_of_Vol_Abs   = 'Volumen_Abs_Num_'; % Nötig um Zeit zu entdimensionieren!!!
TimeStep = 'DeltaT_0_001';
TimeSteppScheme = {'BDF_1','BDF_2'} ;
Init_Deformations = {'Init_2', 'Init_3', 'Init_4', 'Init_5', 'Init_6'}; % Namen für Zeros-Matrizen
Names_Groups = {...
    {'12_2_80','12_2_70','12_2_60', '12_2_50', '12_2_40',                                 }, ...
    {                               '12_3_50', '12_3_40', '12_3_30' , '12_3_20', '12_3_10'}, ...
    {                                                     '12_4_30' , '12_4_20', '12_4_10'}, ...
    {                                                                 '12_5_20', '12_5_10'}, ...
    {                                                                            '12_6_10'} ...
};
Colors = {[114 16 133]/255, [0 157 129]/255, [230 0 26]/255, [245 163 0]/255,[0 0 0]/255}; % Farben
Format = {'-', '-.',':','--',':'};
Makers = {'x','o','p','s','^'};
% Initialisierung für Legende
legendEntries1 = {}; % Array für Legendentexte
legendEntries2 = {}; % Array für Legendentexte
% Naming for plots
s1 = 'BDF1_vs_BDF2_Energy_';
s3 = date;
%% Files Loading Path
base_path = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
cd(base_path); % Verzeichniswechsel
% Figure on 
figure; hold on
%% Iteriere über alle Gruppen und speichere Zeros mit passendem Namen
for Scheme = 1:length(TimeSteppScheme)
    subplot(1,2,Scheme)
        hold on
    for groupIdx = 1:length(Names_Groups)
        currentGroup = Names_Groups{groupIdx};
        currentName = Init_Deformations{groupIdx}; % Name der Initialdeformation
        zeros_= load([currentName, '_', TimeSteppScheme{Scheme},'_',TimeStep, '_Zeros', '.txt']); 
        % Vertauschen der Zeilen
        % Mal 0.88 weil Zeroes zeigen 2.25 Oszillationen
        zeros = round(zeros_(end:-1:1, :)*0.88);
        % Initialisiere Matrix für Volumen
        numFiles = length(currentGroup);
        % Larges Amiplitude for respective Initial Deformation Mode
        fileIdx = 1;
        % Lade Daten für die aktuelle Datei Relative Volumen Änderung
        Energy_Rel_Num_ = load([Name_of_Value, currentGroup{fileIdx},'_', TimeSteppScheme{Scheme}, '_', TimeStep, '.txt']);
        parts = split(currentGroup{fileIdx}, '_'); % Teile den String anhand von '_'
        Ampitude = str2double(parts{end});  % Letzte zwei Ziffern extrahieren und in Amplitude umwandeln   
        %% Entdimensionalisierung
        Volumen_abs     = load([Name_of_Vol_Abs, currentGroup{fileIdx},'_',TimeSteppScheme{Scheme},'_',TimeStep, '.txt']);
        %R0              = ((3*Volumen_abs(1))/(4*pi))^(1/3);
        R0 = 1/(sqrt(pi)*2); % Non-dimensionalisation
        t_star          =  sqrt((0.07275)/(R0^3))';
        %% Loading Time Steps
        if Scheme == 1
            % Erst den Zahlenteil rausziehen:
            numStr = extractAfter(TimeStep, 'DeltaT_');   % ergibt '0_001'
            % Unterstriche in Punkt umwandeln:
            numStr = strrep(numStr, '_', '.');            % ergibt '0.001'
            % In Zahl umwandeln:
            dT = str2double(numStr);
            Zeitschritte_ = dT * ones(1,length(Volumen_abs));
        else
            Zeitschritte_   = load(['..\Vector_Storages\', TimeSteppScheme{Scheme}, '\', TimeStep ,'\', currentGroup{fileIdx}, '\', currentGroup{fileIdx},   '_GesamtZeitschritt_Speicher1.txt']);
        end
        t               = [0 cumsum(Zeitschritte_(1:end-1))];
        %% LinePLots
        plot(t(1:zeros(fileIdx,5)).*t_star,Energy_Rel_Num_(1:zeros(fileIdx,5)),Format{groupIdx},'color',Colors{groupIdx},'linewidth',2)
        xlabl = xlabel('$t$','FontSize',14 , 'Interpreter','latex');
        ylabl = ylabel('$\mathcal{E}$ in $\%$','FontSize',14, 'Interpreter','latex');
        Init_Def_Mode = parts{2};  % Mittlere Ziffern für  Inital Deformation Mode
        % Füge einen neuen Legendentext hinzu
        legendEntries1{end+1} = ['$a_', Init_Def_Mode, '(0)=', num2str(Ampitude/100), '$'];
        % Achtung! Fallunterscheidung für 2er Mode weil Marker anders ist
     end
end
%% Erstelle die Legende nach der Schleife und weitere Einstellungen
subplot(1,2,1);        
hold on
Titl = title('(BDF 1)','FontSize',14,'Interpreter','latex');
set(gca,'Fontsize',14); 
%ylim([-35 1])
grid on
grid minor
xlabel('$t$','FontSize',14,'Interpreter','latex');
subplot(1,2,2);         
hold on
% Erstelle die Legende nach der Schleife
Titl = title('(BDF 2)','FontSize',14,'Interpreter','latex');
lgd = legend(legendEntries1, 'Location', 'NorthEast', 'NumColumns', 1, 'Interpreter', 'latex');
xlabel('$t$','FontSize',14,'Interpreter','latex');
set(gca,'Fontsize',14); 
grid on
grid minor
%ylim([-1 2])
%% Plot Size and Saving as esp
x0=0; 
y0=0;
width=1000;
height=400;
set(gcf,'position',[x0,y0,width,height])

cd '..\..\Plots\Code'
s0 = '..\Figures\';
s = strcat(s0,s1,TimeStep,'_',s3);
print2eps(s,gcf())