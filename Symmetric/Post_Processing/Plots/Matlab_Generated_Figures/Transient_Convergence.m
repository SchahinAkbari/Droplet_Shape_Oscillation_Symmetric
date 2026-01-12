%% Postprocessing;
%% 15.09.2025
%% Akbari && Noori
%% Time Convergence
%% Initialisierung
clc 
clear all
%% Naming, Colors and Shapes
% Load Name of Value
CutOffDegree        = {'12','10','8','6'};
TimeStep            = {'DeltaT_0_0005','DeltaT_0_001', 'DeltaT_0_002', 'DeltaT_0_004'};
TimeStepLegende     = {'$0.0005$','$0.001$', '$0.002$', '$0.004$'};
TimeSteppScheme     = 'BDF_2' ;

All_Amplitude           = {...
%                          {          '30','40','50', '60', '70', '80'}, ...
                          {                '40','50', '60', '70'     }, ...
                          {'10','20','30','40','50'                  }, ...
                          {'10','20','30'                            }, ...
                          {'10','20'                                 }, ...
                          {'10'                                      } ...
};

Initial_Deformation = '2';
Amplitude = All_Amplitude{str2double(Initial_Deformation)-1};

Colors = {[114 16 133]/255, [0 157 129]/255, [230 0 26]/255, [245 163 0]/255,[201 212 0]/255,[0 0 0]/255}; % Farben
Makers = {'-x','-o','-p','-s','-^','-*'};

% Initialisierung für Legende
 h = gobjects(length(Amplitude),1);   % Proxy-Handles für die Legende
 legendEntries = cell(1,length(Amplitude));
% Naming for plots
s1 = 'Transient_Convergence_';
s2 = [Initial_Deformation '_'];
s3 = date;
 % Figure on 
 figure; hold on
 %%
base_path_1 = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
base_path_2 = '..\..\Data\Vector_Storages\';

% --- KONVERGENZ: Vorbereitung ---
R0 = 1/(sqrt(pi)*2);
t_non_dimension = sqrt((0.07275)/(R0^3));
dt_values = [0.001, 0.002, 0.004]./t_non_dimension;          % global verfügbar

Err  = nan(length(Amplitude), numel(dt_values));
P12  = nan(length(Amplitude),1);   % zwischen dt1 und dt2
P23  = nan(length(Amplitude),1);   % zwischen dt2 und dt3
Preg = nan(length(Amplitude),1);   % Regression über alle dt
R2   = nan(length(Amplitude),1);   % optional: Fit-Qualität

for amplitude = 1:length(Amplitude)
nameTag = [CutOffDegree{1} '_' Initial_Deformation '_'  Amplitude{amplitude} ];
full_path = fullfile(base_path_2,'\', TimeSteppScheme, '\', TimeStep{1},'\',nameTag ); % Kombiniere den Pfad mit der Name_ID
A_12_0_0005 = load([full_path,'\', nameTag, '_VectorSpeicherA.txt']);
t_12_0_0005 = load([full_path,'\', nameTag, '_GesamtZeitschritt_Speicher1.txt']);
full_path = fullfile(base_path_2,'\', TimeSteppScheme, '\', TimeStep{2},'\',nameTag ); % Kombiniere den Pfad mit der Name_ID
A_12_0_001 = load([full_path,'\', nameTag, '_VectorSpeicherA.txt']);
t_12_0_001 = load([full_path,'\', nameTag, '_GesamtZeitschritt_Speicher1.txt']);
full_path = fullfile(base_path_2,'\', TimeSteppScheme, '\', TimeStep{3},'\',nameTag ); % Kombiniere den Pfad mit der Name_ID
A_12_0_002 = load([full_path,'\', nameTag, '_VectorSpeicherA.txt']);
t_12_0_002 = load([full_path,'\', nameTag, '_GesamtZeitschritt_Speicher1.txt']);
full_path = fullfile(base_path_2,'\', TimeSteppScheme, '\', TimeStep{4},'\',nameTag ); % Kombiniere den Pfad mit der Name_ID
A_12_0_004 = load([full_path,'\', nameTag, '_VectorSpeicherA.txt']);
t_12_0_004 = load([full_path,'\', nameTag, '_GesamtZeitschritt_Speicher1.txt']);

diff_0_0005_0_001 = zeros(1,length(A_12_0_002));
diff_0_0005_0_002 = zeros(1,length(A_12_0_002));
diff_0_0005_0_004 = zeros(1,length(A_12_0_002));
norm_0_0005    = zeros(1,length(A_12_0_002));

    Init_2_Zeros_0_004   = load([base_path_1, '\Int_', CutOffDegree{1},'_',Initial_Deformation ,'_',TimeSteppScheme,'_',TimeStep{4},'_Zeros.txt']);
%% Testing Field
    for Zeitschritt = 1:Init_2_Zeros_0_004(amplitude,5)

        for i = 0:eval(['length(A_12_0_004(:,1))'])-1
            eval(['a12_dt_0_004_' num2str(i) ' = A_12_0_004(' num2str(i+1) ', Zeitschritt);']);
        end
        Radius_12_0_004 =  @(zetaa)  (7186705221432913.*2.^(1./2).*a12_dt_0_004_0)./36028797018963968 + (35933526107164565.*2.^(1./2).*a12_dt_0_004_12.*(33.*zetaa.^10.*(zetaa.^2 - 1) + (231.*(zetaa.^2 - 1).^6)./1024 + (2079.*zetaa.^2.*(zetaa.^2 - 1).^5)./128 + (17325.*zetaa.^4.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^6.*(zetaa.^2 - 1).^3)./4 + (1485.*zetaa.^8.*(zetaa.^2 - 1).^2)./8 + zetaa.^12))./36028797018963968 + (21560115664298739.*2.^(1./2).*a12_dt_0_004_4.*(3.*zetaa.^2.*(zetaa.^2 - 1) + (3.*(zetaa.^2 - 1).^2)./8 + zetaa.^4))./36028797018963968 - (7186705221432913.*2.^(1./2).*23.^(1./2).*a12_dt_0_004_11.*((693.*zetaa.*(zetaa.^2 - 1).^5)./256 + (55.*zetaa.^9.*(zetaa.^2 - 1))./2 + (5775.*zetaa.^3.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^5.*(zetaa.^2 - 1).^3)./8 + (495.*zetaa.^7.*(zetaa.^2 - 1).^2)./4 + zetaa.^11))./36028797018963968 + (7186705221432913.*2.^(1./2).*5.^(1./2).*a12_dt_0_004_2.*((3.*zetaa.^2)./2 - 1./2))./36028797018963968 - (7186705221432913.*2.^(1./2).*19.^(1./2).*a12_dt_0_004_9.*((315.*zetaa.*(zetaa.^2 - 1).^4)./128 + 18.*zetaa.^7.*(zetaa.^2 - 1) + (105.*zetaa.^3.*(zetaa.^2 - 1).^3)./4 + (189.*zetaa.^5.*(zetaa.^2 - 1).^2)./4 + zetaa.^9))./36028797018963968 - (7186705221432913.*2.^(1./2).*15.^(1./2).*a12_dt_0_004_7.*((35.*zetaa.*(zetaa.^2 - 1).^3)./16 + (21.*zetaa.^5.*(zetaa.^2 - 1))./2 + (105.*zetaa.^3.*(zetaa.^2 - 1).^2)./8 + zetaa.^7))./36028797018963968 + (7186705221432913.*2.^(1./2).*21.^(1./2).*a12_dt_0_004_10.*((45.*zetaa.^8.*(zetaa.^2 - 1))./2 + (63.*(zetaa.^2 - 1).^5)./256 + (1575.*zetaa.^2.*(zetaa.^2 - 1).^4)./128 + (525.*zetaa.^4.*(zetaa.^2 - 1).^3)./8 + (315.*zetaa.^6.*(zetaa.^2 - 1).^2)./4 + zetaa.^10))./36028797018963968 - (7186705221432913.*2.^(1./2).*11.^(1./2).*a12_dt_0_004_5.*((15.*zetaa.*(zetaa.^2 - 1).^2)./8 + 5.*zetaa.^3.*(zetaa.^2 - 1) + zetaa.^5))./36028797018963968 + (7186705221432913.*2.^(1./2).*17.^(1./2).*a12_dt_0_004_8.*(14.*zetaa.^6.*(zetaa.^2 - 1) + (35.*(zetaa.^2 - 1).^4)./128 + (35.*zetaa.^2.*(zetaa.^2 - 1).^3)./4 + (105.*zetaa.^4.*(zetaa.^2 - 1).^2)./4 + zetaa.^8))./36028797018963968 - (7186705221432913.*2.^(1./2).*7.^(1./2).*a12_dt_0_004_3.*((3.*zetaa.*(zetaa.^2 - 1))./2 + zetaa.^3))./36028797018963968 + (7186705221432913.*2.^(1./2).*13.^(1./2).*a12_dt_0_004_6.*((15.*zetaa.^4.*(zetaa.^2 - 1))./2 + (5.*(zetaa.^2 - 1).^3)./16 + (45.*zetaa.^2.*(zetaa.^2 - 1).^2)./8 + zetaa.^6))./36028797018963968 - (7186705221432913.*2.^(1./2).*3.^(1./2).*a12_dt_0_004_1.*zetaa)./36028797018963968;          
        time = sum(t_12_0_004(1:Zeitschritt));

        [idx_low, idx_high, exact_pos, local_frac] = findPosition(t_12_0_0005, time);
        %Linear Interpolieren
        A_low  = A_12_0_0005(:, idx_low);
        A_high = A_12_0_0005(:, idx_high);
        A_12_0_0005_ = A_low + local_frac * (A_high - A_low);   % linear zwischen low und high
        for i = 0:eval(['length(A_12_0_0005_)'])-1
            eval(['a12_dt_0_0005_' num2str(i) ' = A_12_0_0005_(' num2str(i+1) ');'])

        end
        Radius_12_0_0005 =  @(zetaa)  (7186705221432913.*2.^(1./2).*a12_dt_0_0005_0)./36028797018963968 + (35933526107164565.*2.^(1./2).*a12_dt_0_0005_12.*(33.*zetaa.^10.*(zetaa.^2 - 1) + (231.*(zetaa.^2 - 1).^6)./1024 + (2079.*zetaa.^2.*(zetaa.^2 - 1).^5)./128 + (17325.*zetaa.^4.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^6.*(zetaa.^2 - 1).^3)./4 + (1485.*zetaa.^8.*(zetaa.^2 - 1).^2)./8 + zetaa.^12))./36028797018963968 + (21560115664298739.*2.^(1./2).*a12_dt_0_0005_4.*(3.*zetaa.^2.*(zetaa.^2 - 1) + (3.*(zetaa.^2 - 1).^2)./8 + zetaa.^4))./36028797018963968 - (7186705221432913.*2.^(1./2).*23.^(1./2).*a12_dt_0_0005_11.*((693.*zetaa.*(zetaa.^2 - 1).^5)./256 + (55.*zetaa.^9.*(zetaa.^2 - 1))./2 + (5775.*zetaa.^3.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^5.*(zetaa.^2 - 1).^3)./8 + (495.*zetaa.^7.*(zetaa.^2 - 1).^2)./4 + zetaa.^11))./36028797018963968 + (7186705221432913.*2.^(1./2).*5.^(1./2).*a12_dt_0_0005_2.*((3.*zetaa.^2)./2 - 1./2))./36028797018963968 - (7186705221432913.*2.^(1./2).*19.^(1./2).*a12_dt_0_0005_9.*((315.*zetaa.*(zetaa.^2 - 1).^4)./128 + 18.*zetaa.^7.*(zetaa.^2 - 1) + (105.*zetaa.^3.*(zetaa.^2 - 1).^3)./4 + (189.*zetaa.^5.*(zetaa.^2 - 1).^2)./4 + zetaa.^9))./36028797018963968 - (7186705221432913.*2.^(1./2).*15.^(1./2).*a12_dt_0_0005_7.*((35.*zetaa.*(zetaa.^2 - 1).^3)./16 + (21.*zetaa.^5.*(zetaa.^2 - 1))./2 + (105.*zetaa.^3.*(zetaa.^2 - 1).^2)./8 + zetaa.^7))./36028797018963968 + (7186705221432913.*2.^(1./2).*21.^(1./2).*a12_dt_0_0005_10.*((45.*zetaa.^8.*(zetaa.^2 - 1))./2 + (63.*(zetaa.^2 - 1).^5)./256 + (1575.*zetaa.^2.*(zetaa.^2 - 1).^4)./128 + (525.*zetaa.^4.*(zetaa.^2 - 1).^3)./8 + (315.*zetaa.^6.*(zetaa.^2 - 1).^2)./4 + zetaa.^10))./36028797018963968 - (7186705221432913.*2.^(1./2).*11.^(1./2).*a12_dt_0_0005_5.*((15.*zetaa.*(zetaa.^2 - 1).^2)./8 + 5.*zetaa.^3.*(zetaa.^2 - 1) + zetaa.^5))./36028797018963968 + (7186705221432913.*2.^(1./2).*17.^(1./2).*a12_dt_0_0005_8.*(14.*zetaa.^6.*(zetaa.^2 - 1) + (35.*(zetaa.^2 - 1).^4)./128 + (35.*zetaa.^2.*(zetaa.^2 - 1).^3)./4 + (105.*zetaa.^4.*(zetaa.^2 - 1).^2)./4 + zetaa.^8))./36028797018963968 - (7186705221432913.*2.^(1./2).*7.^(1./2).*a12_dt_0_0005_3.*((3.*zetaa.*(zetaa.^2 - 1))./2 + zetaa.^3))./36028797018963968 + (7186705221432913.*2.^(1./2).*13.^(1./2).*a12_dt_0_0005_6.*((15.*zetaa.^4.*(zetaa.^2 - 1))./2 + (5.*(zetaa.^2 - 1).^3)./16 + (45.*zetaa.^2.*(zetaa.^2 - 1).^2)./8 + zetaa.^6))./36028797018963968 - (7186705221432913.*2.^(1./2).*3.^(1./2).*a12_dt_0_0005_1.*zetaa)./36028797018963968;

        [idx_low, idx_high, exact_pos, local_frac] = findPosition(t_12_0_001, time);
        %Linear Interpolieren
        A_low  = A_12_0_001(:, idx_low);
        A_high = A_12_0_001(:, idx_high);
        A_12_0_001_ = A_low + local_frac * (A_high - A_low);   % linear zwischen low und high
        for i = 0:eval(['length(A_12_0_001_)'])-1
            eval(['a12_dt_0_001_' num2str(i) ' = A_12_0_001_(' num2str(i+1) ');']);
        end
        Radius_12_0_001 =  @(zetaa)  (7186705221432913.*2.^(1./2).*a12_dt_0_001_0)./36028797018963968 + (35933526107164565.*2.^(1./2).*a12_dt_0_001_12.*(33.*zetaa.^10.*(zetaa.^2 - 1) + (231.*(zetaa.^2 - 1).^6)./1024 + (2079.*zetaa.^2.*(zetaa.^2 - 1).^5)./128 + (17325.*zetaa.^4.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^6.*(zetaa.^2 - 1).^3)./4 + (1485.*zetaa.^8.*(zetaa.^2 - 1).^2)./8 + zetaa.^12))./36028797018963968 + (21560115664298739.*2.^(1./2).*a12_dt_0_001_4.*(3.*zetaa.^2.*(zetaa.^2 - 1) + (3.*(zetaa.^2 - 1).^2)./8 + zetaa.^4))./36028797018963968 - (7186705221432913.*2.^(1./2).*23.^(1./2).*a12_dt_0_001_11.*((693.*zetaa.*(zetaa.^2 - 1).^5)./256 + (55.*zetaa.^9.*(zetaa.^2 - 1))./2 + (5775.*zetaa.^3.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^5.*(zetaa.^2 - 1).^3)./8 + (495.*zetaa.^7.*(zetaa.^2 - 1).^2)./4 + zetaa.^11))./36028797018963968 + (7186705221432913.*2.^(1./2).*5.^(1./2).*a12_dt_0_001_2.*((3.*zetaa.^2)./2 - 1./2))./36028797018963968 - (7186705221432913.*2.^(1./2).*19.^(1./2).*a12_dt_0_001_9.*((315.*zetaa.*(zetaa.^2 - 1).^4)./128 + 18.*zetaa.^7.*(zetaa.^2 - 1) + (105.*zetaa.^3.*(zetaa.^2 - 1).^3)./4 + (189.*zetaa.^5.*(zetaa.^2 - 1).^2)./4 + zetaa.^9))./36028797018963968 - (7186705221432913.*2.^(1./2).*15.^(1./2).*a12_dt_0_001_7.*((35.*zetaa.*(zetaa.^2 - 1).^3)./16 + (21.*zetaa.^5.*(zetaa.^2 - 1))./2 + (105.*zetaa.^3.*(zetaa.^2 - 1).^2)./8 + zetaa.^7))./36028797018963968 + (7186705221432913.*2.^(1./2).*21.^(1./2).*a12_dt_0_001_10.*((45.*zetaa.^8.*(zetaa.^2 - 1))./2 + (63.*(zetaa.^2 - 1).^5)./256 + (1575.*zetaa.^2.*(zetaa.^2 - 1).^4)./128 + (525.*zetaa.^4.*(zetaa.^2 - 1).^3)./8 + (315.*zetaa.^6.*(zetaa.^2 - 1).^2)./4 + zetaa.^10))./36028797018963968 - (7186705221432913.*2.^(1./2).*11.^(1./2).*a12_dt_0_001_5.*((15.*zetaa.*(zetaa.^2 - 1).^2)./8 + 5.*zetaa.^3.*(zetaa.^2 - 1) + zetaa.^5))./36028797018963968 + (7186705221432913.*2.^(1./2).*17.^(1./2).*a12_dt_0_001_8.*(14.*zetaa.^6.*(zetaa.^2 - 1) + (35.*(zetaa.^2 - 1).^4)./128 + (35.*zetaa.^2.*(zetaa.^2 - 1).^3)./4 + (105.*zetaa.^4.*(zetaa.^2 - 1).^2)./4 + zetaa.^8))./36028797018963968 - (7186705221432913.*2.^(1./2).*7.^(1./2).*a12_dt_0_001_3.*((3.*zetaa.*(zetaa.^2 - 1))./2 + zetaa.^3))./36028797018963968 + (7186705221432913.*2.^(1./2).*13.^(1./2).*a12_dt_0_001_6.*((15.*zetaa.^4.*(zetaa.^2 - 1))./2 + (5.*(zetaa.^2 - 1).^3)./16 + (45.*zetaa.^2.*(zetaa.^2 - 1).^2)./8 + zetaa.^6))./36028797018963968 - (7186705221432913.*2.^(1./2).*3.^(1./2).*a12_dt_0_001_1.*zetaa)./36028797018963968;

        [idx_low, idx_high, exact_pos, local_frac] = findPosition(t_12_0_002, time);
        %Linear Interpolieren
        A_low  = A_12_0_002(:, idx_low);
        A_high = A_12_0_002(:, idx_high);
        A_12_0_002_ = A_low + local_frac * (A_high - A_low);   % linear zwischen low und high
        for i = 0:eval(['length(A_12_0_002_)'])-1
            eval(['a12_dt_0_002_' num2str(i) ' = A_12_0_002_(' num2str(i+1) ');']);
        end
        Radius_12_0_002 =  @(zetaa)  (7186705221432913.*2.^(1./2).*a12_dt_0_002_0)./36028797018963968 + (35933526107164565.*2.^(1./2).*a12_dt_0_002_12.*(33.*zetaa.^10.*(zetaa.^2 - 1) + (231.*(zetaa.^2 - 1).^6)./1024 + (2079.*zetaa.^2.*(zetaa.^2 - 1).^5)./128 + (17325.*zetaa.^4.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^6.*(zetaa.^2 - 1).^3)./4 + (1485.*zetaa.^8.*(zetaa.^2 - 1).^2)./8 + zetaa.^12))./36028797018963968 + (21560115664298739.*2.^(1./2).*a12_dt_0_002_4.*(3.*zetaa.^2.*(zetaa.^2 - 1) + (3.*(zetaa.^2 - 1).^2)./8 + zetaa.^4))./36028797018963968 - (7186705221432913.*2.^(1./2).*23.^(1./2).*a12_dt_0_002_11.*((693.*zetaa.*(zetaa.^2 - 1).^5)./256 + (55.*zetaa.^9.*(zetaa.^2 - 1))./2 + (5775.*zetaa.^3.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^5.*(zetaa.^2 - 1).^3)./8 + (495.*zetaa.^7.*(zetaa.^2 - 1).^2)./4 + zetaa.^11))./36028797018963968 + (7186705221432913.*2.^(1./2).*5.^(1./2).*a12_dt_0_002_2.*((3.*zetaa.^2)./2 - 1./2))./36028797018963968 - (7186705221432913.*2.^(1./2).*19.^(1./2).*a12_dt_0_002_9.*((315.*zetaa.*(zetaa.^2 - 1).^4)./128 + 18.*zetaa.^7.*(zetaa.^2 - 1) + (105.*zetaa.^3.*(zetaa.^2 - 1).^3)./4 + (189.*zetaa.^5.*(zetaa.^2 - 1).^2)./4 + zetaa.^9))./36028797018963968 - (7186705221432913.*2.^(1./2).*15.^(1./2).*a12_dt_0_002_7.*((35.*zetaa.*(zetaa.^2 - 1).^3)./16 + (21.*zetaa.^5.*(zetaa.^2 - 1))./2 + (105.*zetaa.^3.*(zetaa.^2 - 1).^2)./8 + zetaa.^7))./36028797018963968 + (7186705221432913.*2.^(1./2).*21.^(1./2).*a12_dt_0_002_10.*((45.*zetaa.^8.*(zetaa.^2 - 1))./2 + (63.*(zetaa.^2 - 1).^5)./256 + (1575.*zetaa.^2.*(zetaa.^2 - 1).^4)./128 + (525.*zetaa.^4.*(zetaa.^2 - 1).^3)./8 + (315.*zetaa.^6.*(zetaa.^2 - 1).^2)./4 + zetaa.^10))./36028797018963968 - (7186705221432913.*2.^(1./2).*11.^(1./2).*a12_dt_0_002_5.*((15.*zetaa.*(zetaa.^2 - 1).^2)./8 + 5.*zetaa.^3.*(zetaa.^2 - 1) + zetaa.^5))./36028797018963968 + (7186705221432913.*2.^(1./2).*17.^(1./2).*a12_dt_0_002_8.*(14.*zetaa.^6.*(zetaa.^2 - 1) + (35.*(zetaa.^2 - 1).^4)./128 + (35.*zetaa.^2.*(zetaa.^2 - 1).^3)./4 + (105.*zetaa.^4.*(zetaa.^2 - 1).^2)./4 + zetaa.^8))./36028797018963968 - (7186705221432913.*2.^(1./2).*7.^(1./2).*a12_dt_0_002_3.*((3.*zetaa.*(zetaa.^2 - 1))./2 + zetaa.^3))./36028797018963968 + (7186705221432913.*2.^(1./2).*13.^(1./2).*a12_dt_0_002_6.*((15.*zetaa.^4.*(zetaa.^2 - 1))./2 + (5.*(zetaa.^2 - 1).^3)./16 + (45.*zetaa.^2.*(zetaa.^2 - 1).^2)./8 + zetaa.^6))./36028797018963968 - (7186705221432913.*2.^(1./2).*3.^(1./2).*a12_dt_0_002_1.*zetaa)./36028797018963968;
            
        %% Calculate Diff!
        diff_0_0005_0_001_ = @(zetaa) (Radius_12_0_0005(zetaa) - Radius_12_0_001(zetaa)).^2;
        diff_0_0005_0_002_  = @(zetaa) (Radius_12_0_0005(zetaa) - Radius_12_0_002(zetaa)).^2;
        diff_0_0005_0_004_  = @(zetaa) (Radius_12_0_0005(zetaa) - Radius_12_0_004(zetaa)).^2;
        norm_0_0005_  = @(zetaa) (Radius_12_0_0005(zetaa)).^2;

        diff_0_0005_0_001(Zeitschritt) =  integral(diff_0_0005_0_001_,-1,1);
        diff_0_0005_0_002(Zeitschritt)  = integral(diff_0_0005_0_002_,-1,1);
        diff_0_0005_0_004(Zeitschritt)  = integral(diff_0_0005_0_004_,-1,1);

        norm_0_0005(Zeitschritt)    = integral(norm_0_0005_,-1,1);
    end
        err_values = [sqrt(sum(diff_0_0005_0_001)/sum(norm_0_0005)), ...
                      sqrt(sum(diff_0_0005_0_002)/sum(norm_0_0005)), ...
                      sqrt(sum(diff_0_0005_0_004)/sum(norm_0_0005))] *100/Init_2_Zeros_0_004(amplitude,5);       %% WICHTIG! Devide by the number of Timesteps and mutiply with 100%
%% Calculation of Slope
        % ----- Fehler sichern -----
Err(amplitude,:) = err_values(:).';   % 1x3

% ----- Paarweise Ordnungen (nur Potenzgesetz!) -----
dt1 = dt_values(1); dt2 = dt_values(2); dt3 = dt_values(3);
e1  = err_values(1); e2  = err_values(2); e3  = err_values(3);

if all([e1 e2 e3] > 0) && all(isfinite([e1 e2 e3]))
    P12(amplitude) = log(e2/e1) / log(dt2/dt1);   % p zwischen 0.001 und 0.002
    P23(amplitude) = log(e3/e2) / log(dt3/dt2);   % p zwischen 0.002 und 0.004

    % ----- Regression über alle dt: log(E) = a + p*log(dt) -----
    pfit = polyfit(log(dt_values), log(err_values), 1);
    Preg(amplitude) = pfit(1);

    % optional: R^2 im loglog-Raum
    yhat = polyval(pfit, log(dt_values));
    SSres = sum((log(err_values) - yhat).^2);
    SStot = sum((log(err_values) - mean(log(err_values))).^2);
    R2(amplitude) = 1 - SSres/SStot;
end

%% Legend
    % Figure Data
    % Vektoren der x- und y-Werte. Attention. Sqrt of Error Values Needed!
        handVisibility = 'off';
        if amplitude == 1 || amplitude == 6
        plot(dt_values, err_values, Makers{amplitude}, 'Color', Colors{amplitude}, 'MarkerSize', 15, 'LineWidth', 2);
        % Proxy für Legende (entspricht Optik von amplitude==1 && 6)
        h(amplitude) = plot(NaN, NaN, Makers{amplitude}, 'Color', Colors{amplitude}, 'MarkerSize', 15, 'LineWidth', 2, 'DisplayName', ['Amplitude = ', num2str(str2double(Amplitude{amplitude})/100)]);
        else
        % % Proxy für Legende (entspricht Optik der gefüllten Marker)
        % --- Linie (dick, ohne Marker) ---
        plot(dt_values, err_values, '-', ...
                'Color', Colors{amplitude}, 'LineWidth', 2, ...
                'HandleVisibility', 'off');  % Linie selbst nicht in Legende
        
        % --- Marker (dünner Rand im Plot) ---
        plot(dt_values, err_values, Makers{amplitude}, ...
                'MarkerEdgeColor', [0 0 0], ...
                'MarkerFaceColor', Colors{amplitude}, ...
                'MarkerSize', 12, ...
                'LineWidth', 1, ...           % Dünner Marker-Rand
                'Color', 'none', ...          % Keine Linienverbindung
                'HandleVisibility', handVisibility);
        
        % --- Dummy-Handle für Legende (gleicher Stil mit dünnem Rand) ---
        h(amplitude) = plot(NaN, NaN, Makers{amplitude}, ...
                'Color', Colors{amplitude}, ...  % Linie sichtbar in Legende
                'LineStyle','-', ...             % Verbindungslinie zeigen
                'MarkerEdgeColor', [0 0 0], ...
                'MarkerFaceColor', Colors{amplitude}, ...
                'MarkerSize', 15, ...
                'LineWidth', 1.5, ...            % Linie bleibt moderat dick, Marker-Rand dünn
                'DisplayName', ['Amplitude = ', Amplitude{amplitude}]);
        end
        legendEntries{amplitude} = ['$a_', Initial_Deformation,'(0) = ' , num2str(str2double(Amplitude{amplitude})/100),'$'];
end
p_mean   = mean(Preg, 'omitnan');
%% Add Convergence Slope
% ---- Referenzlinie: y = y0*(x/x0)^p_mean ----
x0 = dt_values(1);
y0 = 8e-5/7;

p_ref = p_mean;    % oder p_median

x_ref = linspace(min(dt_values), max(dt_values), 200);
y_ref = y0 * (x_ref/x0).^p_ref;

h_ref = loglog(x_ref, y_ref, 'k-', 'LineWidth', 1.5);

%legendEntriesRef = [legendEntries, {sprintf('$O((\Delta t)^{%.2f})$', p_ref)}];
%% Plot Size and Saving as esp. Config
x0=0;  
y0=0;
width=1000;
height=400;
set(gca,'yscal','log')
set(gca,'xscal','log')
ylabl = ylabel('$\mathcal{E}_{\Delta t}$ in $\%$','FontSize',14, 'Interpreter','latex');
xlabl = xlabel('$\Delta t$','FontSize',14, 'Interpreter','latex');
Titl = title('L = 12','FontSize',14,'Interpreter','latex');
%lgd = legend([h; h_ref], legendEntriesRef, 'Location','southeastoutside','FontSize',14,'Interpreter','latex');
lgd = legend(h, legendEntries, 'Location','southeastoutside','FontSize',14,'Interpreter','latex');
grid on
grid minor
set(gcf,'position',[x0,y0,width,height])
cd '..\..\Plots\Code'
s0 = '..\Figures\';
s = strcat(s0,s1,s2,TimeSteppScheme,'_',s3);
print2eps(s,gcf())