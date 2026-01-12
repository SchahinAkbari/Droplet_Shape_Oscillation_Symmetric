%% Postprocessing;
%% 23.09.2025
%% Akbari && Noori
%% BDF2-Energie Convergence Spatial
%% Initialisierung
clc 
clear all
%% Files Loading Path
base_path = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
cd(base_path); % Verzeichniswechsel
%% Naming, Colors and Shapes
% Load Name of Value
Name_of_Value       = 'E_Ges_Rel_Num_';
Name_of_Vol_Abs     = 'Volumen_Abs_Num_'; % Nötig um Zeit zu entdimensionieren!!!
TimeStep            = 'DeltaT_0_001';
TimeSteppScheme     = 'BDF_2' ;
CutOffDegree        = {'14','12','10','8','6'};
All_Amplitude       = {...
                     %{          '30','40','50', '60', '70', '80'}, ...
                      {               '40','50', '60', '70'      }, ...
                      {'10','20','30','40','50'                  }, ...
                      {'10','20','30'                            }, ...
                      {'10','20'                                 }, ...
                      {'10'                                      } ...
};

Initial_Deformation = '2';
amplitude_column    = 4;
Amplitude = All_Amplitude{str2double(Initial_Deformation)-1};

Colors = {[114 16 133]/255, [0 157 129]/255, [230 0 26]/255, [245 163 0]/255,[0 0 0]/255}; % Farben
Format = {'-', '-.',':','--',':'};
Makers = {'x','o','p','s','^'};
% Initialisierung für Legende
legendEntries1 = {}; % Array für Legendentexte
legendEntries2 = {}; % Array für Legendentexte
% Naming for plots
s1 = 'Energy_Convergence_Spatial_BDF2_';
s3 = date;
%% Files Loading Path
% Figure on 
figure; hold on
%% Iteriere über alle Gruppen und speichere Zeros mit passendem Namen
    for cutoff = 1: length(CutOffDegree)
    base_path_1 = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
    base_path_2 = '..\..\Data\Vector_Storages\';

    Init_2_Zeros   = load([base_path_1, '\Int_', CutOffDegree{cutoff},'_',Initial_Deformation ,'_',TimeSteppScheme,'_',TimeStep,'_Zeros.txt']);
    nameTag = [CutOffDegree{cutoff} '_' Initial_Deformation '_'  Amplitude{amplitude_column}];
    full_path = fullfile(base_path_2,'\', TimeSteppScheme, '\', TimeStep,'\',nameTag ); % Kombiniere den Pfad mit der Name_ID
    A_12_ = load([full_path,'\', nameTag, '_VectorSpeicherA.txt']);
    Energy_Rel_Num_ = load([Name_of_Value, nameTag,'_',TimeSteppScheme, '_', TimeStep, '.txt']);
    %% Entdimensionalisierung
    Volumen_abs     = load([Name_of_Vol_Abs, nameTag,'_',TimeSteppScheme, '_', TimeStep, '.txt']);
    %R0              = ((3*Volumen_abs(1))/(4*pi))^(1/3);
    R0              = 1/(2*sqrt(pi));
    t_star          =  sqrt((0.07275)/(R0^3))';
    %% Loading Time Steps
    Zeitschritte_   = load(['..\Vector_Storages\', TimeSteppScheme, '\', TimeStep ,'\', nameTag, '\', nameTag,   '_GesamtZeitschritt_Speicher1.txt']);
    t               = [0 cumsum(Zeitschritte_(1:end-1))];
    %% LinePLots
    plot(t(1:Init_2_Zeros(amplitude_column,5)).*t_star,Energy_Rel_Num_(1:Init_2_Zeros(amplitude_column,5)),Format{cutoff},'color',Colors{cutoff},'linewidth',2)
    legendEntries1{end+1} = ['$L = ', CutOffDegree{cutoff}, '$'];
    end
%% Erstelle die Legende nach der Schleife und weitere Einstellungen     
hold on
% Erstelle die Legende nach der Schleife
Titl = title(['$a_', Initial_Deformation, '(0)=', num2str(str2double(Amplitude{amplitude_column})/100), '$'],'FontSize',14,'Interpreter','latex'); 
lgd = legend(legendEntries1, 'Location', 'SouthWest', 'NumColumns', 1, 'Interpreter', 'latex');
xlabl = xlabel('$t$','FontSize',14 , 'Interpreter','latex');
ylabl = ylabel('$\mathcal{E}_{E}(t)$ in $\%$','FontSize',14, 'Interpreter','latex');
xlim([0 4.7])   % Beschränkt die x-Achse von 0 bis 5
set(gca,'Fontsize',14); 
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
s = strcat(s0,s1,TimeStep,'_',Initial_Deformation, '_'  ,Amplitude{amplitude_column},'_',s3);
print2eps(s,gcf())