%% Postprocessing;
%% 12.11.2024
%% Akbari && Noori
%% Oscillation plots
%% Initialisierung
clc 
clear all
%% Naming, Colors and Shapes
% Load Name of Value
Name_of_Value = 'Nord_Pol_Rel_Num_';
Name = '12_3_50'; 
TimeStep = 'DeltaT_0_001';
TimeSteppScheme = 'BDF_2' ;
shape = ['-'];
colors = [0 0 0]/255;
% Naming for plots
s1 = 'Oscillation_Plots_Init_2_';
s2 = 'Amplitude_80_';
s3 = date;
%% Files Loading Path
base_path = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
cd(base_path); % Verzeichniswechsel
%% Find 2 Oscillation and Devide by 20
Nord_Pol_Rel_Num_ = load([Name_of_Value, Name,'_',TimeSteppScheme, '_', TimeStep, '.txt']);
% Lokale Maxima in jeder Zeile finden
localMax = islocalmax(Nord_Pol_Rel_Num_, 2);

% Indizes und Werte der lokalen Maxima ausgeben
[row, col] = find(localMax);
values = Nord_Pol_Rel_Num_(localMax);
for i = 1:length(values)
    % Mit Auge
    fprintf('Lokales Maximum: %d an Position (%d, %d)\n', values(i), row(i), col(i));
end
EndPosition = col(10);
% Runden, damit es durch 20 teilbar wird
EndPositionRounded = round(EndPosition / 20) * 20;
% Berechnung des Schritts
stepSize = EndPositionRounded / 20;
% Berechnung der Anzahl der Schritte basierend auf EndPositionRounded
numSteps = 20;
%% Plots Single Shapes
Zeitschritt = 1; 
%% Assign Coefficient
base_path = '..\Vector_Storages';
full_path = fullfile(base_path,'\', TimeSteppScheme,'\',TimeStep, Name); % Kombiniere den Pfad mit der Name_ID
% cd(full_path); % Verzeichniswechsel
A = load([full_path,'\',Name, '_VectorSpeicherA.txt']); 
% Anzahl Zeilen ermitteln
numRows = size(A,1);
% Falls weniger als 13 Zeilen vorhanden sind -> mit Nullen auffüllen
if numRows < 13
    numCols = size(A,2); % Spaltenanzahl beibehalten
    A(end+1:13, 1:numCols) = 0;
end
for i = 0:eval(['length(A(:,1))'])-1
    eval(['a2_' num2str(i) ' = A(' num2str(i+1) ', Zeitschritt);']);
end
%% Meshgrid 
zetaa = -1:0.004:1;                   % polar angle
phi = 0:pi/20:2*pi;                   % azimuth angle
[phi,zetaa] = meshgrid(phi,zetaa);    % define the grid
R_rho =(7186705221432913.*2.^(1./2).*a2_0)./36028797018963968 + (35933526107164565.*2.^(1./2).*a2_12.*(33.*zetaa.^10.*(zetaa.^2 - 1) + (231.*(zetaa.^2 - 1).^6)./1024 + (2079.*zetaa.^2.*(zetaa.^2 - 1).^5)./128 + (17325.*zetaa.^4.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^6.*(zetaa.^2 - 1).^3)./4 + (1485.*zetaa.^8.*(zetaa.^2 - 1).^2)./8 + zetaa.^12))./36028797018963968 + (21560115664298739.*2.^(1./2).*a2_4.*(3.*zetaa.^2.*(zetaa.^2 - 1) + (3.*(zetaa.^2 - 1).^2)./8 + zetaa.^4))./36028797018963968 - (7186705221432913.*2.^(1./2).*23.^(1./2).*a2_11.*((693.*zetaa.*(zetaa.^2 - 1).^5)./256 + (55.*zetaa.^9.*(zetaa.^2 - 1))./2 + (5775.*zetaa.^3.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^5.*(zetaa.^2 - 1).^3)./8 + (495.*zetaa.^7.*(zetaa.^2 - 1).^2)./4 + zetaa.^11))./36028797018963968 + (7186705221432913.*2.^(1./2).*5.^(1./2).*a2_2.*((3.*zetaa.^2)./2 - 1./2))./36028797018963968 - (7186705221432913.*2.^(1./2).*19.^(1./2).*a2_9.*((315.*zetaa.*(zetaa.^2 - 1).^4)./128 + 18.*zetaa.^7.*(zetaa.^2 - 1) + (105.*zetaa.^3.*(zetaa.^2 - 1).^3)./4 + (189.*zetaa.^5.*(zetaa.^2 - 1).^2)./4 + zetaa.^9))./36028797018963968 - (7186705221432913.*2.^(1./2).*15.^(1./2).*a2_7.*((35.*zetaa.*(zetaa.^2 - 1).^3)./16 + (21.*zetaa.^5.*(zetaa.^2 - 1))./2 + (105.*zetaa.^3.*(zetaa.^2 - 1).^2)./8 + zetaa.^7))./36028797018963968 + (7186705221432913.*2.^(1./2).*21.^(1./2).*a2_10.*((45.*zetaa.^8.*(zetaa.^2 - 1))./2 + (63.*(zetaa.^2 - 1).^5)./256 + (1575.*zetaa.^2.*(zetaa.^2 - 1).^4)./128 + (525.*zetaa.^4.*(zetaa.^2 - 1).^3)./8 + (315.*zetaa.^6.*(zetaa.^2 - 1).^2)./4 + zetaa.^10))./36028797018963968 - (7186705221432913.*2.^(1./2).*11.^(1./2).*a2_5.*((15.*zetaa.*(zetaa.^2 - 1).^2)./8 + 5.*zetaa.^3.*(zetaa.^2 - 1) + zetaa.^5))./36028797018963968 + (7186705221432913.*2.^(1./2).*17.^(1./2).*a2_8.*(14.*zetaa.^6.*(zetaa.^2 - 1) + (35.*(zetaa.^2 - 1).^4)./128 + (35.*zetaa.^2.*(zetaa.^2 - 1).^3)./4 + (105.*zetaa.^4.*(zetaa.^2 - 1).^2)./4 + zetaa.^8))./36028797018963968 - (7186705221432913.*2.^(1./2).*7.^(1./2).*a2_3.*((3.*zetaa.*(zetaa.^2 - 1))./2 + zetaa.^3))./36028797018963968 + (7186705221432913.*2.^(1./2).*13.^(1./2).*a2_6.*((15.*zetaa.^4.*(zetaa.^2 - 1))./2 + (5.*(zetaa.^2 - 1).^3)./16 + (45.*zetaa.^2.*(zetaa.^2 - 1).^2)./8 + zetaa.^6))./36028797018963968 - (7186705221432913.*2.^(1./2).*3.^(1./2).*a2_1.*zetaa)./36028797018963968;
y = R_rho.*sqrt(1-zetaa.^2);             % convert to Cartesian coordinates
x = R_rho.*zetaa;                        % convert to Cartesian coordinates
%% Plot
figure 
% Erstes großes Bild (2x2, oben links)
subplot(2, 12, [1, 2, 13, 14]); % Belegt 2 Zeilen und 2 Spalten
plot(y,x,'k',-y,x,'k','LineWidth',3);    % Line plot
PlotTitle={'(a)','(b)', '(c)', '(d)', '(e)',...
           '(f)', '(g)', '(h)', '(i)','(j)',...
           '(k)', '(l)', '(m)', '(n)','(o)',...
           '(p)', '(q)', '(r)', '(s)', '(t)', '(u)'};

axis([-0.45 0.45 -0.45 0.45])
light               % add a light
lighting gouraud    % preferred lighting for a curved surface
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
set(gca,'XTick',[])
set(gca,'YTick',[])
axis off
PlotNum = 1;
ylabl = title(PlotTitle{PlotNum},'FontSize',44);
pbaspect([1 1 1])
set(ylabl,'Interpreter','latex');
% Erstelle das erste großes Bild (ganz links, 2 Kästchen hoch)
plotPostion = 2;
for timestemp =1:stepSize:EndPositionRounded
    if plotPostion == 12 
            plotPostion = plotPostion +3;
    else
            plotPostion = plotPostion +1;
    end
    for i = 0:eval(['length(A(:,1))'])-1
            eval(['a2_' num2str(i) ' = A(' num2str(i+1) ', timestemp);']);
    end
    % R created with 
    R_rho =(7186705221432913.*2.^(1./2).*a2_0)./36028797018963968 + (35933526107164565.*2.^(1./2).*a2_12.*(33.*zetaa.^10.*(zetaa.^2 - 1) + (231.*(zetaa.^2 - 1).^6)./1024 + (2079.*zetaa.^2.*(zetaa.^2 - 1).^5)./128 + (17325.*zetaa.^4.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^6.*(zetaa.^2 - 1).^3)./4 + (1485.*zetaa.^8.*(zetaa.^2 - 1).^2)./8 + zetaa.^12))./36028797018963968 + (21560115664298739.*2.^(1./2).*a2_4.*(3.*zetaa.^2.*(zetaa.^2 - 1) + (3.*(zetaa.^2 - 1).^2)./8 + zetaa.^4))./36028797018963968 - (7186705221432913.*2.^(1./2).*23.^(1./2).*a2_11.*((693.*zetaa.*(zetaa.^2 - 1).^5)./256 + (55.*zetaa.^9.*(zetaa.^2 - 1))./2 + (5775.*zetaa.^3.*(zetaa.^2 - 1).^4)./128 + (1155.*zetaa.^5.*(zetaa.^2 - 1).^3)./8 + (495.*zetaa.^7.*(zetaa.^2 - 1).^2)./4 + zetaa.^11))./36028797018963968 + (7186705221432913.*2.^(1./2).*5.^(1./2).*a2_2.*((3.*zetaa.^2)./2 - 1./2))./36028797018963968 - (7186705221432913.*2.^(1./2).*19.^(1./2).*a2_9.*((315.*zetaa.*(zetaa.^2 - 1).^4)./128 + 18.*zetaa.^7.*(zetaa.^2 - 1) + (105.*zetaa.^3.*(zetaa.^2 - 1).^3)./4 + (189.*zetaa.^5.*(zetaa.^2 - 1).^2)./4 + zetaa.^9))./36028797018963968 - (7186705221432913.*2.^(1./2).*15.^(1./2).*a2_7.*((35.*zetaa.*(zetaa.^2 - 1).^3)./16 + (21.*zetaa.^5.*(zetaa.^2 - 1))./2 + (105.*zetaa.^3.*(zetaa.^2 - 1).^2)./8 + zetaa.^7))./36028797018963968 + (7186705221432913.*2.^(1./2).*21.^(1./2).*a2_10.*((45.*zetaa.^8.*(zetaa.^2 - 1))./2 + (63.*(zetaa.^2 - 1).^5)./256 + (1575.*zetaa.^2.*(zetaa.^2 - 1).^4)./128 + (525.*zetaa.^4.*(zetaa.^2 - 1).^3)./8 + (315.*zetaa.^6.*(zetaa.^2 - 1).^2)./4 + zetaa.^10))./36028797018963968 - (7186705221432913.*2.^(1./2).*11.^(1./2).*a2_5.*((15.*zetaa.*(zetaa.^2 - 1).^2)./8 + 5.*zetaa.^3.*(zetaa.^2 - 1) + zetaa.^5))./36028797018963968 + (7186705221432913.*2.^(1./2).*17.^(1./2).*a2_8.*(14.*zetaa.^6.*(zetaa.^2 - 1) + (35.*(zetaa.^2 - 1).^4)./128 + (35.*zetaa.^2.*(zetaa.^2 - 1).^3)./4 + (105.*zetaa.^4.*(zetaa.^2 - 1).^2)./4 + zetaa.^8))./36028797018963968 - (7186705221432913.*2.^(1./2).*7.^(1./2).*a2_3.*((3.*zetaa.*(zetaa.^2 - 1))./2 + zetaa.^3))./36028797018963968 + (7186705221432913.*2.^(1./2).*13.^(1./2).*a2_6.*((15.*zetaa.^4.*(zetaa.^2 - 1))./2 + (5.*(zetaa.^2 - 1).^3)./16 + (45.*zetaa.^2.*(zetaa.^2 - 1).^2)./8 + zetaa.^6))./36028797018963968 - (7186705221432913.*2.^(1./2).*3.^(1./2).*a2_1.*zetaa)./36028797018963968;
    y = R_rho.*sqrt(1-zetaa.^2);    % convert to Cartesian coordinates
    x = R_rho.*zetaa;               % convert to Cartesian coordinates
    PlotNum = 1 + PlotNum;
    subplot(2, 12, plotPostion); % Belegt 2 Zeilen und 2 Spalten
    plot(y,x,'k',-y,x,'k','LineWidth',3);    % Line plot
    Titl = title(PlotTitle{PlotNum},'FontSize',100);
    set(Titl,'Interpreter','latex')
    axis([-0.45 0.45 -0.45 0.45])
    light               % add a light
    lighting gouraud    % preferred lighting for a curved surface
    set(gca,'xticklabel',[])
    set(gca,'yticklabel',[])
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    axis off
    ylabl = title(PlotTitle{PlotNum},'FontSize',44);
    set(ylabl,'Interpreter','latex');
    pbaspect([1 1 1])
end
    % pbaspect([1 1 1])
x0=0;
y0=0;
width=2500;
height=700;
set(gcf,'position',[x0,y0,width,height])

cd '..\..\Plots\Code'
s0 = '..\Figures\';
s = strcat(s0,s1,s2,TimeSteppScheme,'_',TimeStep,'_',s3);
print2eps(s,gcf())