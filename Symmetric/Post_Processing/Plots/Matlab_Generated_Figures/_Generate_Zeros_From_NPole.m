%% Postprocessing;
%% 12.11.2024
%% Akbari && Noori
%% Oscillation plots
%% Initialisierung
clc 
clear all
%% Naming
% Load Name of Value
Name_of_Value = 'Nord_Pol_Rel_Num_';
TimeStep = '_DeltaT_0_001';
% Names_Groups = {...
%     {'12_2_30', '12_2_40', '12_2_50', '12_2_60', '12_2_70', '12_2_80'}, ...
%     {'12_3_10', '12_3_20', '12_3_30', '12_3_40', '12_3_50'}, ...
%     {'12_4_10', '12_4_20', '12_4_30'}, ...
%     {'12_5_10', '12_5_20'}, ...
%     {'12_6_10'} ...
% };

Names_Groups = {...
    {'12_2_30', '12_2_40', '12_2_50', '12_2_60'}, ...
    {'12_3_10', '12_3_20', '12_3_30', '12_3_40', '12_3_50'}, ...
    {'12_4_10', '12_4_20', '12_4_30'}, ...
    {'12_5_10', '12_5_20'}, ...
    {'12_6_10'} ...
};


Init_Deformations = {'Init_2', 'Init_3', 'Init_4', 'Init_5', 'Init_6'}; % Namen für Zeros-Matrizen

% Maximale Anzahl Nullstellen pro Zeile
maxZeros = 5; % Beispielwert

%% Files Loading Path
base_path = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
cd(base_path); % Verzeichniswechsel

% Funktion zur Nullstellenberechnung (Zeichenwechsel)
zci = @(v) find(v(1:end-1) .* v(2:end) <= 0);

%% Iteriere über alle Gruppen und speichere Zeros mit passendem Namen
for groupIdx = 1:length(Names_Groups)
    currentGroup = Names_Groups{groupIdx};
    currentName = Init_Deformations{groupIdx}; % Name der Initialdeformation
    
    % Initialisiere Matrix für Nullstellen
    numFiles = length(currentGroup);
    Zeros = zeros(numFiles, maxZeros);
    
    % Schleife für jede Datei in der aktuellen Gruppe
    for fileIdx = 1:numFiles
        % Lade Daten für die aktuelle Datei North Pole
        fileName = [Name_of_Value, currentGroup{fileIdx}, TimeStep, '.txt'];
        Nord_Pol_Rel_Num_ = load(fileName); 
        % Berechnung der Nullstellen
        zx = zci(Nord_Pol_Rel_Num_); % Nullstellen der aktuellen Datei
        numZeros = min(length(zx), maxZeros); % Begrenze auf maximale Nullstellen
        Zeros(fileIdx, 1:numZeros) = zx(1:numZeros); % Speichere Nullstellen
    end
    % Speichere die Zeros-Matrix in einer Variable mit dynamischem Namen
    eval([currentName, '_Zeros = Zeros;']);
    
    % Optional: Speichere die Matrix auch in einer Datei
    outputFileName = [currentName, '_Zeros.txt'];
    save(outputFileName, 'Zeros', '-ascii');
end