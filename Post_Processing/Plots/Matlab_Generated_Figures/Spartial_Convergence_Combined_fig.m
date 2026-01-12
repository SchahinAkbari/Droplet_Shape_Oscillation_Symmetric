%% Postprocessing;
%% 15.09.2025
%% Akbari && Noori
%% Spartial Convergence
%% Initialisierung
%% Naming, Colors and Shapes
% Load Name of Value
TimeStep = 'DeltaT_0_001';
TimeSteppScheme = 'BDF_2' ;
CutOffDegree        = {'14','12','10','8','6'};

All_Amplitude           = {...
                          {               '40','50', '60', '70'      }, ...
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
TIMESTEP = formatTimeStep('DeltaT_0_00055');
s1 = 'Spartial_Convergence_';
s2 = ['_' Initial_Deformation '_'];
s3 = date;
 % Figure on 
hold on
k_all  = nan(length(Amplitude),1); % Slopes
R2_all = nan(length(Amplitude),1);
%% Files Loading Path
for amplitude = 1:length(Amplitude)
    base_path_1 = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
    base_path_2 = '..\..\Data\Vector_Storages\';
    Zeros   = load([base_path_1, '\Int_', CutOffDegree{1} '_' Initial_Deformation ,'_',TimeSteppScheme,'_',TimeStep,'_Zeros.txt']);
    nameTag = [CutOffDegree{1} '_' Initial_Deformation '_'  Amplitude{amplitude} ];
    full_path = fullfile(base_path_2,'\', TimeSteppScheme, '\', TimeStep,'\',nameTag ); % Kombiniere den Pfad mit der Name_ID
    A_14_ = load([full_path,'\', nameTag, '_VectorSpeicherA.txt']);
    %########################################
    nameTag = [CutOffDegree{2} '_' Initial_Deformation '_'  Amplitude{amplitude} ];
    full_path = fullfile(base_path_2,'\', TimeSteppScheme, '\', TimeStep,'\',nameTag ); % Kombiniere den Pfad mit der Name_ID
    A_12_ = load([full_path,'\', nameTag, '_VectorSpeicherA.txt']);
        % If less than 15 Rows -> Fill with zeros
     numRows = size(A_12_,1);
    if numRows < 15
        numCols = size(A_12_,2); % Spaltenanzahl beibehalten
        A_12_(end+1:15, 1:numCols) = 0;
    end
    %########################################
    nameTag = [CutOffDegree{3} '_' Initial_Deformation '_'  Amplitude{amplitude} ];
    full_path = fullfile(base_path_2,'\', TimeSteppScheme, '\', TimeStep,'\',nameTag ); % Kombiniere den Pfad mit der Name_ID
    A_10_ = load([full_path,'\',nameTag, '_VectorSpeicherA.txt']);
    numRows = size(A_10_,1);
    % If less than 15 Rows -> Fill with zeros
    if numRows < 15
        numCols = size(A_10_,2); % Spaltenanzahl beibehalten
        A_10_(end+1:15, 1:numCols) = 0;
    end
    %########################################
    nameTag = [CutOffDegree{4} '_' Initial_Deformation '_'  Amplitude{amplitude} ];
    full_path = fullfile(base_path_2,'\', TimeSteppScheme, '\', TimeStep,'\',nameTag ); % Kombiniere den Pfad mit der Name_ID
    A_8_ = load([full_path,'\',nameTag, '_VectorSpeicherA.txt']);
    numRows = size(A_8_,1);
    % If less than 15 Rows -> Fill with zeros
    if numRows < 15
        numCols = size(A_8_,2); % Spaltenanzahl beibehalten
        A_8_(end+1:15, 1:numCols) = 0;
    end
    %########################################
    nameTag = [CutOffDegree{5} '_' Initial_Deformation '_'  Amplitude{amplitude} ];
    full_path = fullfile(base_path_2,'\', TimeSteppScheme, '\', TimeStep,'\',nameTag ); % Kombiniere den Pfad mit der Name_ID
    A_6_ = load([full_path,'\',nameTag, '_VectorSpeicherA.txt']);
    numRows = size(A_6_,1);
    % If less than 15 Rows -> Fill with zeros
    if numRows < 15
        numCols = size(A_6_,2); % Spaltenanzahl beibehalten
        A_6_(end+1:15, 1:numCols) = 0;
    end
    %########################################
    diff_14_12 = zeros(1,length(A_14_));
    diff_14_10 = zeros(1,length(A_14_));
    diff_14_8  = zeros(1,length(A_14_));
    diff_14_6  = zeros(1,length(A_14_));
    norm_14    = zeros(1,length(A_14_));

    for Zeitschritt = 1:1:Zeros(amplitude,5) 
        %########################################
        %##########################################        
        for i = 0:eval(['length(A_14_(:,1))'])-1
            eval(['a14_' num2str(i) ' = A_14_(' num2str(i+1) ', Zeitschritt);']);
        end
        Radius_14 =  @(zetaa)  (7186705221432913.*2.^(1./2).*a14_0)./36028797018963968 + (35933526107164565.*2.^(1./2).*a14_12.*(33.*zetaa.^10.*(zetaa.^2 - 1) + (231.*(zetaa.^2 - 1).^6)./1024 + (2079.*zetaa.^2.*(zetaa.^2 - 1).^5)./128 + (17325.*zetaa.^4.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^6.*(zetaa.^2 - 1).^3)./4 + (1485.*zetaa.^8.*(zetaa.^2 - 1).^2)./8 + zetaa.^12))./36028797018963968 + (21560115664298739.*2.^(1./2).*a14_4.*(3.*zetaa.^2.*(zetaa.^2 - 1) + (3.*(zetaa.^2 - 1).^2)./8 + zetaa.^4))./36028797018963968 - (7186705221432913.*2.^(1./2).*23.^(1./2).*a14_11.*((693.*zetaa.*(zetaa.^2 - 1).^5)./256 + (55.*zetaa.^9.*(zetaa.^2 - 1))./2 + (5775.*zetaa.^3.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^5.*(zetaa.^2 - 1).^3)./8 + (495.*zetaa.^7.*(zetaa.^2 - 1).^2)./4 + zetaa.^11))./36028797018963968 + (7186705221432913.*2.^(1./2).*5.^(1./2).*a14_2.*((3.*zetaa.^2)./2 - 1./2))./36028797018963968 + (7186705221432913.*2.^(1./2).*29.^(1./2).*a14_14.*((91.*zetaa.^12.*(zetaa.^2 - 1))./2 + (429.*(zetaa.^2 - 1).^7)./2048 + (21021.*zetaa.^2.*(zetaa.^2 - 1).^6)./1024 + (63063.*zetaa.^4.*(zetaa.^2 - 1).^5)./256 + (105105.*zetaa.^6.*(zetaa.^2 - 1).^4)./128 + (15015.*zetaa.^8.*(zetaa.^2 - 1).^3)./16 + (3003.*zetaa.^10.*(zetaa.^2 - 1).^2)./8 + zetaa.^14))./36028797018963968 - (7186705221432913.*2.^(1./2).*19.^(1./2).*a14_9.*((315.*zetaa.*(zetaa.^2 - 1).^4)./128 + 18.*zetaa.^7.*(zetaa.^2 - 1) + (105.*zetaa.^3.*(zetaa.^2 - 1).^3)./4 + (189.*zetaa.^5.*(zetaa.^2 - 1).^2)./4 + zetaa.^9))./36028797018963968 - (7186705221432913.*2.^(1./2).*15.^(1./2).*a14_7.*((35.*zetaa.*(zetaa.^2 - 1).^3)./16 + (21.*zetaa.^5.*(zetaa.^2 - 1))./2 + (105.*zetaa.^3.*(zetaa.^2 - 1).^2)./8 + zetaa.^7))./36028797018963968 + (7186705221432913.*2.^(1./2).*21.^(1./2).*a14_10.*((45.*zetaa.^8.*(zetaa.^2 - 1))./2 + (63.*(zetaa.^2 - 1).^5)./256 + (1575.*zetaa.^2.*(zetaa.^2 - 1).^4)./128 + (525.*zetaa.^4.*(zetaa.^2 - 1).^3)./8 + (315.*zetaa.^6.*(zetaa.^2 - 1).^2)./4 + zetaa.^10))./36028797018963968 - (7186705221432913.*2.^(1./2).*11.^(1./2).*a14_5.*((15.*zetaa.*(zetaa.^2 - 1).^2)./8 + 5.*zetaa.^3.*(zetaa.^2 - 1) + zetaa.^5))./36028797018963968 + (7186705221432913.*2.^(1./2).*17.^(1./2).*a14_8.*(14.*zetaa.^6.*(zetaa.^2 - 1) + (35.*(zetaa.^2 - 1).^4)./128 + (35.*zetaa.^2.*(zetaa.^2 - 1).^3)./4 + (105.*zetaa.^4.*(zetaa.^2 - 1).^2)./4 + zetaa.^8))./36028797018963968 - (7186705221432913.*2.^(1./2).*7.^(1./2).*a14_3.*((3.*zetaa.*(zetaa.^2 - 1))./2 + zetaa.^3))./36028797018963968 - (21560115664298739.*2.^(1./2).*3.^(1./2).*a14_13.*((3003.*zetaa.*(zetaa.^2 - 1).^6)./1024 + 39.*zetaa.^11.*(zetaa.^2 - 1) + (9009.*zetaa.^3.*(zetaa.^2 - 1).^5)./128 + (45045.*zetaa.^5.*(zetaa.^2 - 1).^4)./128 + (2145.*zetaa.^7.*(zetaa.^2 - 1).^3)./4 + (2145.*zetaa.^9.*(zetaa.^2 - 1).^2)./8 + zetaa.^13))./36028797018963968 + (7186705221432913.*2.^(1./2).*13.^(1./2).*a14_6.*((15.*zetaa.^4.*(zetaa.^2 - 1))./2 + (5.*(zetaa.^2 - 1).^3)./16 + (45.*zetaa.^2.*(zetaa.^2 - 1).^2)./8 + zetaa.^6))./36028797018963968 - (7186705221432913.*2.^(1./2).*3.^(1./2).*a14_1.*zetaa)./36028797018963968;
        %########################################
        %##########################################        
        for i = 0:eval(['length(A_12_(:,1))'])-1
            eval(['a12_' num2str(i) ' = A_12_(' num2str(i+1) ', Zeitschritt);']);
        end
        Radius_12 =  @(zetaa)  (7186705221432913.*2.^(1./2).*a12_0)./36028797018963968 + (35933526107164565.*2.^(1./2).*a12_12.*(33.*zetaa.^10.*(zetaa.^2 - 1) + (231.*(zetaa.^2 - 1).^6)./1024 + (2079.*zetaa.^2.*(zetaa.^2 - 1).^5)./128 + (17325.*zetaa.^4.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^6.*(zetaa.^2 - 1).^3)./4 + (1485.*zetaa.^8.*(zetaa.^2 - 1).^2)./8 + zetaa.^12))./36028797018963968 + (21560115664298739.*2.^(1./2).*a12_4.*(3.*zetaa.^2.*(zetaa.^2 - 1) + (3.*(zetaa.^2 - 1).^2)./8 + zetaa.^4))./36028797018963968 - (7186705221432913.*2.^(1./2).*23.^(1./2).*a12_11.*((693.*zetaa.*(zetaa.^2 - 1).^5)./256 + (55.*zetaa.^9.*(zetaa.^2 - 1))./2 + (5775.*zetaa.^3.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^5.*(zetaa.^2 - 1).^3)./8 + (495.*zetaa.^7.*(zetaa.^2 - 1).^2)./4 + zetaa.^11))./36028797018963968 + (7186705221432913.*2.^(1./2).*5.^(1./2).*a12_2.*((3.*zetaa.^2)./2 - 1./2))./36028797018963968 + (7186705221432913.*2.^(1./2).*29.^(1./2).*a12_14.*((91.*zetaa.^12.*(zetaa.^2 - 1))./2 + (429.*(zetaa.^2 - 1).^7)./2048 + (21021.*zetaa.^2.*(zetaa.^2 - 1).^6)./1024 + (63063.*zetaa.^4.*(zetaa.^2 - 1).^5)./256 + (105105.*zetaa.^6.*(zetaa.^2 - 1).^4)./128 + (15015.*zetaa.^8.*(zetaa.^2 - 1).^3)./16 + (3003.*zetaa.^10.*(zetaa.^2 - 1).^2)./8 + zetaa.^14))./36028797018963968 - (7186705221432913.*2.^(1./2).*19.^(1./2).*a12_9.*((315.*zetaa.*(zetaa.^2 - 1).^4)./128 + 18.*zetaa.^7.*(zetaa.^2 - 1) + (105.*zetaa.^3.*(zetaa.^2 - 1).^3)./4 + (189.*zetaa.^5.*(zetaa.^2 - 1).^2)./4 + zetaa.^9))./36028797018963968 - (7186705221432913.*2.^(1./2).*15.^(1./2).*a12_7.*((35.*zetaa.*(zetaa.^2 - 1).^3)./16 + (21.*zetaa.^5.*(zetaa.^2 - 1))./2 + (105.*zetaa.^3.*(zetaa.^2 - 1).^2)./8 + zetaa.^7))./36028797018963968 + (7186705221432913.*2.^(1./2).*21.^(1./2).*a12_10.*((45.*zetaa.^8.*(zetaa.^2 - 1))./2 + (63.*(zetaa.^2 - 1).^5)./256 + (1575.*zetaa.^2.*(zetaa.^2 - 1).^4)./128 + (525.*zetaa.^4.*(zetaa.^2 - 1).^3)./8 + (315.*zetaa.^6.*(zetaa.^2 - 1).^2)./4 + zetaa.^10))./36028797018963968 - (7186705221432913.*2.^(1./2).*11.^(1./2).*a12_5.*((15.*zetaa.*(zetaa.^2 - 1).^2)./8 + 5.*zetaa.^3.*(zetaa.^2 - 1) + zetaa.^5))./36028797018963968 + (7186705221432913.*2.^(1./2).*17.^(1./2).*a12_8.*(14.*zetaa.^6.*(zetaa.^2 - 1) + (35.*(zetaa.^2 - 1).^4)./128 + (35.*zetaa.^2.*(zetaa.^2 - 1).^3)./4 + (105.*zetaa.^4.*(zetaa.^2 - 1).^2)./4 + zetaa.^8))./36028797018963968 - (7186705221432913.*2.^(1./2).*7.^(1./2).*a12_3.*((3.*zetaa.*(zetaa.^2 - 1))./2 + zetaa.^3))./36028797018963968 - (21560115664298739.*2.^(1./2).*3.^(1./2).*a12_13.*((3003.*zetaa.*(zetaa.^2 - 1).^6)./1024 + 39.*zetaa.^11.*(zetaa.^2 - 1) + (9009.*zetaa.^3.*(zetaa.^2 - 1).^5)./128 + (45045.*zetaa.^5.*(zetaa.^2 - 1).^4)./128 + (2145.*zetaa.^7.*(zetaa.^2 - 1).^3)./4 + (2145.*zetaa.^9.*(zetaa.^2 - 1).^2)./8 + zetaa.^13))./36028797018963968 + (7186705221432913.*2.^(1./2).*13.^(1./2).*a12_6.*((15.*zetaa.^4.*(zetaa.^2 - 1))./2 + (5.*(zetaa.^2 - 1).^3)./16 + (45.*zetaa.^2.*(zetaa.^2 - 1).^2)./8 + zetaa.^6))./36028797018963968 - (7186705221432913.*2.^(1./2).*3.^(1./2).*a12_1.*zetaa)./36028797018963968;
        %########################################
        %##########################################
        for i = 0:eval(['length(A_10_(:,1))'])-1
            eval(['a10_' num2str(i) ' = A_10_(' num2str(i+1) ', Zeitschritt);']);
        end
        Radius_10 =  @(zetaa)  (7186705221432913.*2.^(1./2).*a10_0)./36028797018963968 + (35933526107164565.*2.^(1./2).*a10_12.*(33.*zetaa.^10.*(zetaa.^2 - 1) + (231.*(zetaa.^2 - 1).^6)./1024 + (2079.*zetaa.^2.*(zetaa.^2 - 1).^5)./128 + (17325.*zetaa.^4.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^6.*(zetaa.^2 - 1).^3)./4 + (1485.*zetaa.^8.*(zetaa.^2 - 1).^2)./8 + zetaa.^12))./36028797018963968 + (21560115664298739.*2.^(1./2).*a10_4.*(3.*zetaa.^2.*(zetaa.^2 - 1) + (3.*(zetaa.^2 - 1).^2)./8 + zetaa.^4))./36028797018963968 - (7186705221432913.*2.^(1./2).*23.^(1./2).*a10_11.*((693.*zetaa.*(zetaa.^2 - 1).^5)./256 + (55.*zetaa.^9.*(zetaa.^2 - 1))./2 + (5775.*zetaa.^3.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^5.*(zetaa.^2 - 1).^3)./8 + (495.*zetaa.^7.*(zetaa.^2 - 1).^2)./4 + zetaa.^11))./36028797018963968 + (7186705221432913.*2.^(1./2).*5.^(1./2).*a10_2.*((3.*zetaa.^2)./2 - 1./2))./36028797018963968 + (7186705221432913.*2.^(1./2).*29.^(1./2).*a10_14.*((91.*zetaa.^12.*(zetaa.^2 - 1))./2 + (429.*(zetaa.^2 - 1).^7)./2048 + (21021.*zetaa.^2.*(zetaa.^2 - 1).^6)./1024 + (63063.*zetaa.^4.*(zetaa.^2 - 1).^5)./256 + (105105.*zetaa.^6.*(zetaa.^2 - 1).^4)./128 + (15015.*zetaa.^8.*(zetaa.^2 - 1).^3)./16 + (3003.*zetaa.^10.*(zetaa.^2 - 1).^2)./8 + zetaa.^14))./36028797018963968 - (7186705221432913.*2.^(1./2).*19.^(1./2).*a10_9.*((315.*zetaa.*(zetaa.^2 - 1).^4)./128 + 18.*zetaa.^7.*(zetaa.^2 - 1) + (105.*zetaa.^3.*(zetaa.^2 - 1).^3)./4 + (189.*zetaa.^5.*(zetaa.^2 - 1).^2)./4 + zetaa.^9))./36028797018963968 - (7186705221432913.*2.^(1./2).*15.^(1./2).*a10_7.*((35.*zetaa.*(zetaa.^2 - 1).^3)./16 + (21.*zetaa.^5.*(zetaa.^2 - 1))./2 + (105.*zetaa.^3.*(zetaa.^2 - 1).^2)./8 + zetaa.^7))./36028797018963968 + (7186705221432913.*2.^(1./2).*21.^(1./2).*a10_10.*((45.*zetaa.^8.*(zetaa.^2 - 1))./2 + (63.*(zetaa.^2 - 1).^5)./256 + (1575.*zetaa.^2.*(zetaa.^2 - 1).^4)./128 + (525.*zetaa.^4.*(zetaa.^2 - 1).^3)./8 + (315.*zetaa.^6.*(zetaa.^2 - 1).^2)./4 + zetaa.^10))./36028797018963968 - (7186705221432913.*2.^(1./2).*11.^(1./2).*a10_5.*((15.*zetaa.*(zetaa.^2 - 1).^2)./8 + 5.*zetaa.^3.*(zetaa.^2 - 1) + zetaa.^5))./36028797018963968 + (7186705221432913.*2.^(1./2).*17.^(1./2).*a10_8.*(14.*zetaa.^6.*(zetaa.^2 - 1) + (35.*(zetaa.^2 - 1).^4)./128 + (35.*zetaa.^2.*(zetaa.^2 - 1).^3)./4 + (105.*zetaa.^4.*(zetaa.^2 - 1).^2)./4 + zetaa.^8))./36028797018963968 - (7186705221432913.*2.^(1./2).*7.^(1./2).*a10_3.*((3.*zetaa.*(zetaa.^2 - 1))./2 + zetaa.^3))./36028797018963968 - (21560115664298739.*2.^(1./2).*3.^(1./2).*a10_13.*((3003.*zetaa.*(zetaa.^2 - 1).^6)./1024 + 39.*zetaa.^11.*(zetaa.^2 - 1) + (9009.*zetaa.^3.*(zetaa.^2 - 1).^5)./128 + (45045.*zetaa.^5.*(zetaa.^2 - 1).^4)./128 + (2145.*zetaa.^7.*(zetaa.^2 - 1).^3)./4 + (2145.*zetaa.^9.*(zetaa.^2 - 1).^2)./8 + zetaa.^13))./36028797018963968 + (7186705221432913.*2.^(1./2).*13.^(1./2).*a10_6.*((15.*zetaa.^4.*(zetaa.^2 - 1))./2 + (5.*(zetaa.^2 - 1).^3)./16 + (45.*zetaa.^2.*(zetaa.^2 - 1).^2)./8 + zetaa.^6))./36028797018963968 - (7186705221432913.*2.^(1./2).*3.^(1./2).*a10_1.*zetaa)./36028797018963968;
        %##########################################
        %##########################################
        for i = 0:eval(['length(A_8_(:,1))'])-1
            eval(['a8_' num2str(i) ' = A_8_(' num2str(i+1) ', Zeitschritt);']);
        end
        Radius_8 =  @(zetaa)  (7186705221432913.*2.^(1./2).*a8_0)./36028797018963968 + (35933526107164565.*2.^(1./2).*a8_12.*(33.*zetaa.^10.*(zetaa.^2 - 1) + (231.*(zetaa.^2 - 1).^6)./1024 + (2079.*zetaa.^2.*(zetaa.^2 - 1).^5)./128 + (17325.*zetaa.^4.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^6.*(zetaa.^2 - 1).^3)./4 + (1485.*zetaa.^8.*(zetaa.^2 - 1).^2)./8 + zetaa.^12))./36028797018963968 + (21560115664298739.*2.^(1./2).*a8_4.*(3.*zetaa.^2.*(zetaa.^2 - 1) + (3.*(zetaa.^2 - 1).^2)./8 + zetaa.^4))./36028797018963968 - (7186705221432913.*2.^(1./2).*23.^(1./2).*a8_11.*((693.*zetaa.*(zetaa.^2 - 1).^5)./256 + (55.*zetaa.^9.*(zetaa.^2 - 1))./2 + (5775.*zetaa.^3.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^5.*(zetaa.^2 - 1).^3)./8 + (495.*zetaa.^7.*(zetaa.^2 - 1).^2)./4 + zetaa.^11))./36028797018963968 + (7186705221432913.*2.^(1./2).*5.^(1./2).*a8_2.*((3.*zetaa.^2)./2 - 1./2))./36028797018963968 + (7186705221432913.*2.^(1./2).*29.^(1./2).*a8_14.*((91.*zetaa.^12.*(zetaa.^2 - 1))./2 + (429.*(zetaa.^2 - 1).^7)./2048 + (21021.*zetaa.^2.*(zetaa.^2 - 1).^6)./1024 + (63063.*zetaa.^4.*(zetaa.^2 - 1).^5)./256 + (105105.*zetaa.^6.*(zetaa.^2 - 1).^4)./128 + (15015.*zetaa.^8.*(zetaa.^2 - 1).^3)./16 + (3003.*zetaa.^10.*(zetaa.^2 - 1).^2)./8 + zetaa.^14))./36028797018963968 - (7186705221432913.*2.^(1./2).*19.^(1./2).*a8_9.*((315.*zetaa.*(zetaa.^2 - 1).^4)./128 + 18.*zetaa.^7.*(zetaa.^2 - 1) + (105.*zetaa.^3.*(zetaa.^2 - 1).^3)./4 + (189.*zetaa.^5.*(zetaa.^2 - 1).^2)./4 + zetaa.^9))./36028797018963968 - (7186705221432913.*2.^(1./2).*15.^(1./2).*a8_7.*((35.*zetaa.*(zetaa.^2 - 1).^3)./16 + (21.*zetaa.^5.*(zetaa.^2 - 1))./2 + (105.*zetaa.^3.*(zetaa.^2 - 1).^2)./8 + zetaa.^7))./36028797018963968 + (7186705221432913.*2.^(1./2).*21.^(1./2).*a8_10.*((45.*zetaa.^8.*(zetaa.^2 - 1))./2 + (63.*(zetaa.^2 - 1).^5)./256 + (1575.*zetaa.^2.*(zetaa.^2 - 1).^4)./128 + (525.*zetaa.^4.*(zetaa.^2 - 1).^3)./8 + (315.*zetaa.^6.*(zetaa.^2 - 1).^2)./4 + zetaa.^10))./36028797018963968 - (7186705221432913.*2.^(1./2).*11.^(1./2).*a8_5.*((15.*zetaa.*(zetaa.^2 - 1).^2)./8 + 5.*zetaa.^3.*(zetaa.^2 - 1) + zetaa.^5))./36028797018963968 + (7186705221432913.*2.^(1./2).*17.^(1./2).*a8_8.*(14.*zetaa.^6.*(zetaa.^2 - 1) + (35.*(zetaa.^2 - 1).^4)./128 + (35.*zetaa.^2.*(zetaa.^2 - 1).^3)./4 + (105.*zetaa.^4.*(zetaa.^2 - 1).^2)./4 + zetaa.^8))./36028797018963968 - (7186705221432913.*2.^(1./2).*7.^(1./2).*a8_3.*((3.*zetaa.*(zetaa.^2 - 1))./2 + zetaa.^3))./36028797018963968 - (21560115664298739.*2.^(1./2).*3.^(1./2).*a8_13.*((3003.*zetaa.*(zetaa.^2 - 1).^6)./1024 + 39.*zetaa.^11.*(zetaa.^2 - 1) + (9009.*zetaa.^3.*(zetaa.^2 - 1).^5)./128 + (45045.*zetaa.^5.*(zetaa.^2 - 1).^4)./128 + (2145.*zetaa.^7.*(zetaa.^2 - 1).^3)./4 + (2145.*zetaa.^9.*(zetaa.^2 - 1).^2)./8 + zetaa.^13))./36028797018963968 + (7186705221432913.*2.^(1./2).*13.^(1./2).*a8_6.*((15.*zetaa.^4.*(zetaa.^2 - 1))./2 + (5.*(zetaa.^2 - 1).^3)./16 + (45.*zetaa.^2.*(zetaa.^2 - 1).^2)./8 + zetaa.^6))./36028797018963968 - (7186705221432913.*2.^(1./2).*3.^(1./2).*a8_1.*zetaa)./36028797018963968;
        %##########################################
        %##########################################
        for i = 0:eval(['length(A_6_(:,1))'])-1
            eval(['a6_' num2str(i) ' = A_6_(' num2str(i+1) ', Zeitschritt);']);
        end
        Radius_6 =  @(zetaa)  (7186705221432913.*2.^(1./2).*a6_0)./36028797018963968 + (35933526107164565.*2.^(1./2).*a6_12.*(33.*zetaa.^10.*(zetaa.^2 - 1) + (231.*(zetaa.^2 - 1).^6)./1024 + (2079.*zetaa.^2.*(zetaa.^2 - 1).^5)./128 + (17325.*zetaa.^4.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^6.*(zetaa.^2 - 1).^3)./4 + (1485.*zetaa.^8.*(zetaa.^2 - 1).^2)./8 + zetaa.^12))./36028797018963968 + (21560115664298739.*2.^(1./2).*a6_4.*(3.*zetaa.^2.*(zetaa.^2 - 1) + (3.*(zetaa.^2 - 1).^2)./8 + zetaa.^4))./36028797018963968 - (7186705221432913.*2.^(1./2).*23.^(1./2).*a6_11.*((693.*zetaa.*(zetaa.^2 - 1).^5)./256 + (55.*zetaa.^9.*(zetaa.^2 - 1))./2 + (5775.*zetaa.^3.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^5.*(zetaa.^2 - 1).^3)./8 + (495.*zetaa.^7.*(zetaa.^2 - 1).^2)./4 + zetaa.^11))./36028797018963968 + (7186705221432913.*2.^(1./2).*5.^(1./2).*a6_2.*((3.*zetaa.^2)./2 - 1./2))./36028797018963968 + (7186705221432913.*2.^(1./2).*29.^(1./2).*a6_14.*((91.*zetaa.^12.*(zetaa.^2 - 1))./2 + (429.*(zetaa.^2 - 1).^7)./2048 + (21021.*zetaa.^2.*(zetaa.^2 - 1).^6)./1024 + (63063.*zetaa.^4.*(zetaa.^2 - 1).^5)./256 + (105105.*zetaa.^6.*(zetaa.^2 - 1).^4)./128 + (15015.*zetaa.^8.*(zetaa.^2 - 1).^3)./16 + (3003.*zetaa.^10.*(zetaa.^2 - 1).^2)./8 + zetaa.^14))./36028797018963968 - (7186705221432913.*2.^(1./2).*19.^(1./2).*a6_9.*((315.*zetaa.*(zetaa.^2 - 1).^4)./128 + 18.*zetaa.^7.*(zetaa.^2 - 1) + (105.*zetaa.^3.*(zetaa.^2 - 1).^3)./4 + (189.*zetaa.^5.*(zetaa.^2 - 1).^2)./4 + zetaa.^9))./36028797018963968 - (7186705221432913.*2.^(1./2).*15.^(1./2).*a6_7.*((35.*zetaa.*(zetaa.^2 - 1).^3)./16 + (21.*zetaa.^5.*(zetaa.^2 - 1))./2 + (105.*zetaa.^3.*(zetaa.^2 - 1).^2)./8 + zetaa.^7))./36028797018963968 + (7186705221432913.*2.^(1./2).*21.^(1./2).*a6_10.*((45.*zetaa.^8.*(zetaa.^2 - 1))./2 + (63.*(zetaa.^2 - 1).^5)./256 + (1575.*zetaa.^2.*(zetaa.^2 - 1).^4)./128 + (525.*zetaa.^4.*(zetaa.^2 - 1).^3)./8 + (315.*zetaa.^6.*(zetaa.^2 - 1).^2)./4 + zetaa.^10))./36028797018963968 - (7186705221432913.*2.^(1./2).*11.^(1./2).*a6_5.*((15.*zetaa.*(zetaa.^2 - 1).^2)./8 + 5.*zetaa.^3.*(zetaa.^2 - 1) + zetaa.^5))./36028797018963968 + (7186705221432913.*2.^(1./2).*17.^(1./2).*a6_8.*(14.*zetaa.^6.*(zetaa.^2 - 1) + (35.*(zetaa.^2 - 1).^4)./128 + (35.*zetaa.^2.*(zetaa.^2 - 1).^3)./4 + (105.*zetaa.^4.*(zetaa.^2 - 1).^2)./4 + zetaa.^8))./36028797018963968 - (7186705221432913.*2.^(1./2).*7.^(1./2).*a6_3.*((3.*zetaa.*(zetaa.^2 - 1))./2 + zetaa.^3))./36028797018963968 - (21560115664298739.*2.^(1./2).*3.^(1./2).*a6_13.*((3003.*zetaa.*(zetaa.^2 - 1).^6)./1024 + 39.*zetaa.^11.*(zetaa.^2 - 1) + (9009.*zetaa.^3.*(zetaa.^2 - 1).^5)./128 + (45045.*zetaa.^5.*(zetaa.^2 - 1).^4)./128 + (2145.*zetaa.^7.*(zetaa.^2 - 1).^3)./4 + (2145.*zetaa.^9.*(zetaa.^2 - 1).^2)./8 + zetaa.^13))./36028797018963968 + (7186705221432913.*2.^(1./2).*13.^(1./2).*a6_6.*((15.*zetaa.^4.*(zetaa.^2 - 1))./2 + (5.*(zetaa.^2 - 1).^3)./16 + (45.*zetaa.^2.*(zetaa.^2 - 1).^2)./8 + zetaa.^6))./36028797018963968 - (7186705221432913.*2.^(1./2).*3.^(1./2).*a6_1.*zetaa)./36028797018963968; 
        Diff_14_12_ = @(zetaa) (Radius_14(zetaa) - Radius_12(zetaa)).^2;
        Diff_14_10_ = @(zetaa) (Radius_14(zetaa) - Radius_10(zetaa)).^2;
        Diff_14_8_  = @(zetaa) (Radius_14(zetaa) - Radius_8(zetaa)).^2;
        Diff_14_6_  = @(zetaa) (Radius_14(zetaa) - Radius_6(zetaa)).^2;
        Norm_14_     = @(zetaa) (Radius_14(zetaa)).^2;

        diff_14_12(Zeitschritt) = integral(Diff_14_12_,-1,1);
        diff_14_10(Zeitschritt) = integral(Diff_14_10_,-1,1);
        diff_14_8(Zeitschritt)  = integral(Diff_14_8_,-1,1);
        diff_14_6(Zeitschritt)  = integral(Diff_14_6_,-1,1);
        norm_14(Zeitschritt)    = integral(Norm_14_,-1,1);
    end
%% Error
    % Figure Data
        % --- X- und Y-Vektoren aufbauen (L = 12,10,8,6 relativ zu Referenz L=14)
        % Achtung Error mit Sqrt berechnen!
        L_values  = str2double(CutOffDegree(2:5));
        err_values = [sqrt(sum(diff_14_12)/sum(norm_14)), ...
                      sqrt(sum(diff_14_10)/sum(norm_14)), ...
                      sqrt(sum(diff_14_8 )/sum(norm_14)), ...
                      sqrt(sum(diff_14_6 )/sum(norm_14))];  
        % Optional sauber sortieren (z.B. aufsteigend 6,8,10,12):
        [L_values, sortIdx] = sort(L_values, 'ascend');
        err_values = err_values(sortIdx)*100/Zeros(amplitude,5);   
%% Slopes
% ===== Exponentiellen Fit: err ~ C * exp(-k*L) =====
mask = isfinite(err_values) & err_values > 0;

Lfit = L_values(mask);
Efit = err_values(mask);

p = polyfit(Lfit, log(Efit), 1);   % log(E) = p1*L + p2
k_fit = -p(1);
C_fit = exp(p(2));

% R^2 im log-Raum (optional, aber gut zur Kontrolle)
yhat = polyval(p, Lfit);
SSres = sum((log(Efit) - yhat).^2);
SStot = sum((log(Efit) - mean(log(Efit))).^2);
R2_log = 1 - SSres/SStot;

% speichern
k_all(amplitude)  = k_fit;
R2_all(amplitude) = R2_log;

%% Legend
        handVisibility = 'off';
        %%
        if amplitude == 1 || amplitude == 6
        h(amplitude) = plot(L_values, err_values, Makers{amplitude}, 'Color', Colors{amplitude}, 'MarkerSize', 15, 'LineWidth', 2);
        % Proxy für Legende (entspricht Optik von amplitude==1 && 6)
        else
            % --- Linie (dick, ohne Marker) ---
            plot(L_values, err_values, '-', ...
                'Color', Colors{amplitude}, 'LineWidth', 2, ...
                'HandleVisibility', 'off');  % Linie selbst nicht in Legende
        
            % --- Marker (dünner Rand im Plot) ---
            plot(L_values, err_values, Makers{amplitude}, ...
                'MarkerEdgeColor', [0 0 0], ...
                'MarkerFaceColor', Colors{amplitude}, ...
                'MarkerSize', 12, ...
                'LineWidth', 1, ...           % Dünner Marker-Rand
                'Color', 'none', ...          % Keine Linienverbindung
                'HandleVisibility', handVisibility);
        
            % --- Dummy-Handle für Legende (Linie + Marker, dünner Rand) ---
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
%% Calculate Mean Slope (exponential)
% ===== Globaler Mittelwert der Steigung =====
k_mean   = mean(k_all, 'omitnan');
% ---- Referenzlinie mit gefittetem k zeichnen (auf deinem Achsensetup)
x_ref = linspace(min(L_values), max(L_values), 200);
y_ref = C_fit * exp(-k_fit * x_ref)/100;
% Zeichnen im loglog-Plot
h_ref = loglog(x_ref, y_ref, 'k-', 'LineWidth', 2.0);

%% Plot Size and Saving as esp. Config
set(gca,'yscal','log')
%set(gca,'xscal','log')
ylabl = ylabel('$\mathcal{E}_{L}$ in $\%$','FontSize',14, 'Interpreter','latex');
xlabl = xlabel('$L$','FontSize',14, 'Interpreter','latex');
Titl = title('a) Spatial convergence','FontSize',14,'Interpreter','latex');
% lgd = legend(legendEntries, 'Location', 'NorthEast');
grid on
grid minor
