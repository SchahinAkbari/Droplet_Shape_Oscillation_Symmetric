%% Postprocessing;
%% 27.11.2024
%% Akbari && Noori
%% Relative Volume Deviation
%% Initialisierung
clc 
clear all
%% Files Loading Path
base_path = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
cd(base_path); % Verzeichniswechsel
%% Naming, Colors and Shapes
% Load Name of Value
Name_of_Value = 'Volumen_Rel_Num_';
Name_of_Vol_Abs   = 'Volumen_Abs_Num_';
TimeStep = 'DeltaT_0_001';
TimeSteppScheme = 'BDF_2' ;
Init_Deformations = {'Init_2', 'Init_3', 'Init_4', 'Init_5', 'Init_6'};     % Namen für Zeros-Matrizen
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
legendEntries1 = {}; % Array für Legendentexte
legendEntries2 = {}; % Array für Legendentexte
% Naming for plots
s1 = 'Volume_Num_';
s2 = 'all_';
s3 = date;
%% Files Loading Path
base_path = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
cd(base_path); % Verzeichniswechsel
% Figure on 
figure; hold on
%% Iteriere über alle Gruppen und speichere Zeros mit passendem Namen
for groupIdx = 1:length(Names_Groups)
    currentGroup = Names_Groups{groupIdx};
    s0 = currentGroup{1};              % z.B. '12_2_80'
    p0 = split(s0, '_');               % -> string array ["12","2","80"]
    Init_Def = char(p0(1) + "_" + p0(2));  % -> '12_2'
    zeros_= load(['Int_',Init_Def, '_', TimeSteppScheme,'_',TimeStep, '_Zeros', '.txt']); 
    % Vertauschen der Zeilen
    % Mal 0.88 weil Zeroes zeigen 2.25 Oszillationen
    zeros = round(zeros_(end:-1:1, :)*0.88);
    % Initialisiere Matrix für Volumen
    numFiles = length(currentGroup);
    % Schleife für jede Datei in der aktuellen Gruppe
    for fileIdx = 1:numFiles
        % Lade Daten für die aktuelle Datei Relative Volumen Änderung
        Vol_Rel_Num_ = load([Name_of_Value, currentGroup{fileIdx},'_', TimeSteppScheme, '_', TimeStep, '.txt']);
        parts = split(currentGroup{fileIdx}, '_'); % Teile den String anhand von '_'
        Ampitude = str2double(parts{end});  % Letzte zwei Ziffern extrahieren und in Amplitude umwandeln

        %% Max Volumen Deviation innerhalb von zwei Oszillationen Deswegen mal 0.88 weil
        %% Zeroes zeigen 2,25 Oszillationen
        % Maximalwert und zugehörige Indizes finden
        [MaxDeviation, Position_Max_Deviation] = max(abs(Vol_Rel_Num_(1:zeros(fileIdx,5))));
        MaxDeviation = -1*MaxDeviation; % ACHTUNGGG MAX DEVIATION ist negativ
        if fileIdx == 1
        subplot(1,2,1);         hold on
        %% Entdimensionalisierung
        Volumen_abs     = load([Name_of_Vol_Abs, currentGroup{fileIdx},'_',TimeSteppScheme,'_',TimeStep, '.txt']);
        R0              = 1/(sqrt(pi)*2); % Non-dimensionalisation
        t_star          =  sqrt((0.07275)/(R0^3))';

        %% Loading Time Steps
        Zeitschritte_   = load(['..\Vector_Storages\', TimeSteppScheme,'\',TimeStep ,'\', currentGroup{fileIdx}, '\', currentGroup{fileIdx},   '_GesamtZeitschritt_Speicher1.txt']);
        t               = [0 cumsum(Zeitschritte_(1:end-1))];
        %% LinePLots
        plot(t(1:zeros(fileIdx,5)).*t_star,Vol_Rel_Num_(1:zeros(fileIdx,5)),Format{groupIdx},'color',Colors{groupIdx},'linewidth',2)
        xlabl = xlabel('$t$','FontSize',14 , 'Interpreter','latex');
        ylabl = ylabel('$\mathcal{E}_{V}$ in $\%$','FontSize',14, 'Interpreter','latex');
        Init_Def_Mode = parts{2};  % Mittlere Ziffern für  Inital Deformation Mode
        % Füge einen neuen Legendentext hinzu
        legendEntries1{end+1} = ['$a_', Init_Def_Mode, '(0)=', num2str(Ampitude/100), '$'];
        % Achtung! Fallunterscheidung für 2er Mode weil Marker anders ist
            if groupIdx == 1
            plot(t(Position_Max_Deviation).*t_star,MaxDeviation,Makers{groupIdx}, ...
            'color',Colors{groupIdx},'MarkerSize',15,'LineWidth',2.5, 'HandleVisibility', 'off')
            else
            plot(t(Position_Max_Deviation).*t_star,MaxDeviation,Makers{groupIdx},'MarkerEdgeColor',...
            [0 0 0]/255,'MarkerFaceColor',Colors{groupIdx},'MarkerSize',10, 'HandleVisibility', 'off')    
            end
        end
        %% MarkerPLots
        subplot(1,2,2);         hold on
            if fileIdx==1
            handVisibility = 'on';
            else
            handVisibility = 'off';
            end

            if groupIdx == 1
            plot(Ampitude/100,MaxDeviation,Makers{groupIdx}, ...
            'color',Colors{groupIdx},'MarkerSize',15,'LineWidth',2.5, 'HandleVisibility', handVisibility)
            else
            plot(Ampitude/100,MaxDeviation,Makers{groupIdx},'MarkerEdgeColor',...
            [0 0 0]/255,'MarkerFaceColor',Colors{groupIdx},'MarkerSize',10, 'HandleVisibility', handVisibility)    
            end
         ylabl = ylabel('$\mathcal{E}_{V,\max}$ in $\%$','FontSize',14, 'Interpreter','latex');
    end
    legendEntries2{end+1} = ['$\ell=', Init_Def_Mode, '$'];
end
%% Erstelle die Legende nach der Schleife und weitere Einstellungen
subplot(1,2,1);         
hold on
Titl = title('(a)','FontSize',14,'Interpreter','latex');
lgd = legend(legendEntries1, 'Location', 'SouthEast', 'NumColumns', 1, 'Interpreter', 'latex');
set(gca,'Fontsize',14); 
ylim([-0.0015 0.00015])
xlim([0 5])
grid on
grid minor
subplot(1,2,2);         
hold on
% Erstelle die Legende nach der Schleife und mehr
lgd = legend(legendEntries2, 'Location', 'SouthEast', 'NumColumns', 1, 'Interpreter', 'latex');
Titl = title('(b)','FontSize',14,'Interpreter','latex');
xlabel('$a_{\ell}(0)$','FontSize',14,'Interpreter','latex');
set(gca,'Fontsize',14); 
grid on
grid minor
ylim([-0.0015 0.00015])
xlim([0 0.8])
%% Plot Size and Saving as esp
x0=0; 
y0=0;
width=1000;
height=400;
set(gcf,'position',[x0,y0,width,height])

cd '..\..\Plots\Code'
s0 = '..\Figures\';
s = strcat(s0,s1,s2,'_',TimeSteppScheme,'_' , TimeStep,'_',s3);
print2eps(s,gcf())