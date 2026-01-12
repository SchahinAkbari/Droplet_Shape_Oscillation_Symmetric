%% Postprocessing;
%% 12.11.2024
%% Update 07.10.2025
%% Akbari && Noori
%% Zeroes from Northpole Postion
%% Initialisierung
 clc 
 clear all
%% Naming
% Load Name of Value
Name_of_Value = 'Nord_Pol_Rel_Num_';
TimeStep = '_DeltaT_0_001';
TimeSteppScheme = '_BDF_2' ;
CutOffDegree = {'14'};

All_Amplitude = {...
    {               '40','50', '60', '70'      }, ...
    {'10','20','30','40', '50'                 }, ...
    {'10','20','30'                            }, ...
    {'10','20'                                 }, ...
    {'10'                                      } ...
};

Initial_Deformation = {'2','3','4','5','6'};
Amplitude = All_Amplitude{str2double(Initial_Deformation)-1};


% Maximale Anzahl Nullstellen pro Zeile
maxZeros = 5; % Beispielwert

%% Files Loading Path
base_path = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
cd(base_path); % Verzeichniswechsel

% Funktion zur Nullstellenberechnung (Zeichenwechsel)
zci = @(v) find(v(1:end-1) .* v(2:end) <= 0);

%% Iteriere über alle Gruppen und speichere Zeros mit passendem Namen
for groupIdx = 1:length(All_Amplitude)
    currentGroup = All_Amplitude{groupIdx};
    currentName = ['Int_' CutOffDegree{1} '_' Initial_Deformation{groupIdx}]; % Name der Initialdeformation
    
    % Initialisiere Matrix für Nullstellen
    numFiles = length(currentGroup);
    Zeros = zeros(numFiles, maxZeros);
    
    % Schleife für jede Datei in der aktuellen Gruppe
    for fileIdx = 1:numFiles
        % Lade Daten für die aktuelle Datei North Pole
        fileName = [Name_of_Value, CutOffDegree{1}, '_', Initial_Deformation{groupIdx}, '_', currentGroup{fileIdx}, TimeSteppScheme, TimeStep, '.txt'];
        Nord_Pol_Rel_Num_ = load(fileName); 
        % Berechnung der Nullstellen
        zx = zci(Nord_Pol_Rel_Num_); % Nullstellen der aktuellen Datei
        numZeros = min(length(zx), maxZeros); % Begrenze auf maximale Nullstellen
        Zeros(fileIdx, 1:numZeros) = zx(1:numZeros); % Speichere Nullstellen
    end
    % Speichere die Zeros-Matrix in einer Variable mit dynamischem Namen
    eval([currentName, TimeSteppScheme, TimeStep, '_Zeros = Zeros;']);
    % %Speichere die Zeros-Matrix in einer Variable mit dynamischem Namen
    % eval([currentName,'_',TimeSteppScheme,'_',TimeStep, '_Zeros = Zeros;']);

    % Optional: Speichere die Matrix auch in einer Datei
    outputFileName = [currentName, TimeSteppScheme, TimeStep, '_Zeros.txt'];
    % % Optional: Speichere die Matrix auch in einer Datei
    %outputFileName = [currentName,'_',TimeSteppScheme,'_', TimeStep, '_Zeros.txt'];

    save(outputFileName, 'Zeros', '-ascii');
end