%% Postprocessing;
%% 02.10.2025
%% Akbari
%% BDF2-Coeff Convergence
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
All_Amplitude           = {...
    {          '40','50', '60', '70'           }, ...
    {'10','20','30','40','50'                  }, ...
    {'10','20','30'                            }, ...
    {'10','20'                                 }, ...
    {'10'                                      } ...
};

Initial_Deformation = '3';
amplitude_column    = 5;
Amplitude = All_Amplitude{str2double(Initial_Deformation)-1};


h = gobjects(length(CutOffDegree),1);   % Proxy-Handles für die Legende
Colors = {[114 16 133]/255, [0 157 129]/255, [230 0 26]/255, [245 163 0]/255,[0 0 0]/255}; % Farben
Format = {'-', '-.',':','--',':'};
Makers = {'x','o','p','s','^'};
% Initialisierung für Legende
legendEntries = {}; % Array für Legendentexte
% Naming for plots
s1 = 'Coeff_Convergence_BDF2_';
s3 = date;
%% Files Loading Path
% Figure on 
figure; hold on
%% Iteriere über alle Gruppen und speichere Zeros mit passendem Namen
%for amplitude = 1:length(Amplitude)
    for cutoff = 1: length(CutOffDegree)
    base_path_1 = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
    base_path_2 = '..\..\Data\Vector_Storages\';

    Init_2_Zeros   = load([base_path_1, '\Int_',CutOffDegree{cutoff},'_', Initial_Deformation ,'_',TimeSteppScheme,'_',TimeStep,'_Zeros.txt']);
    nameTag = [CutOffDegree{cutoff} '_' Initial_Deformation '_'  Amplitude{amplitude_column}];
    full_path = fullfile(base_path_2,'\', TimeSteppScheme, '\', TimeStep,'\',nameTag ); % Kombiniere den Pfad mit der Name_ID
    A_Cuff_Off = load([full_path,'\', nameTag, '_VectorSpeicherA.txt']);
    %% Marker Plots
    for coeff = 3 : length(A_Cuff_Off(:,1))
        if mod(coeff, 2) == 0 &&  mod(str2double(Initial_Deformation),2) == 0
            fisch = 1;
        else
           integral_weight = (A_Cuff_Off(coeff,Init_2_Zeros(amplitude_column,5)).^2);
           handVisibility = 'off';
            if cutoff == 1
                p1 = plot(coeff-1, integral_weight, Makers{cutoff}, ...
                'Color', Colors{cutoff}, 'MarkerSize', 15, 'LineWidth', 2.5, 'HandleVisibility', handVisibility);
                % Proxy für Legende
                h(cutoff) = plot(NaN, NaN, Makers{cutoff}, 'Color', Colors{cutoff}, ...
                 'MarkerSize', 15, 'LineWidth', 2.5, 'DisplayName', ['Amplitude = ', Amplitude{amplitude_column}]);
            else
                p1 = plot(coeff-1, integral_weight, Makers{cutoff}, ...
                'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', Colors{cutoff}, 'MarkerSize', 10, 'HandleVisibility', handVisibility);
                % Proxy für Legende
                h(cutoff) = plot(NaN, NaN, Makers{cutoff}, 'MarkerEdgeColor', [0 0 0], ...
                 'MarkerFaceColor', Colors{cutoff}, 'MarkerSize', 10, ...
                 'DisplayName', ['Amplitude = ', Amplitude{amplitude_column}]);
            end
        end
    hold on
    end
    legendEntries{cutoff} = ['$L = ', CutOffDegree{cutoff}, '$'];
    % plot(t(1:Init_2_Zeros(amplitude,5)).*t_star,Energy_Rel_Num_(1:Init_2_Zeros(amplitude,5)),Format{cutoff},'color',Colors{cutoff},'linewidth',2)
    % legendEntries1{end+1} = ['$L = ', CutOffDegree{cutoff}, '$'];
    end
%% Erstelle die Legende nach der Schleife und weitere Einstellungen     
hold on
% Erstelle die Legende nach der Schleife
Titl = title(['Convergence of weight functions  for $a_', Initial_Deformation, '(0)=', Amplitude{amplitude_column}, '$'],'FontSize',14,'Interpreter','latex');
set(gca,'yscal','log')
lgd = legend(h, legendEntries, 'Location', 'southwest','FontSize',14,'Interpreter','latex');
xlabl = xlabel('$a_{\ell}$','FontSize',14 , 'Interpreter','latex');
ylabl = ylabel('$\sum_{i=1}^{N} (a_{\ell}(t_i))^2$', 'FontSize',14, 'Interpreter','latex', 'Rotation',0);
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
s = strcat(s0,s1,TimeStep,'_',nameTag,'_',s3);
print2eps(s,gcf())