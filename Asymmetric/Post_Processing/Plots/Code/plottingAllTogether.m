%% Postprocessing;
%% 12.11.2024
%% Akbari && Noori
%% Zeichnung der Energie und Volume: 
%% Initialisierung
clc
clear all
%% Naming, Colors and Shapes
m = 4;   % Number of Plots
Name_ID = ['6_5_50_44';'6_6_50_99';'6_7_50_99';'6_8_50_92']; 
shape = ['--', '--', '--', '--', '--'];
colors = [[0 157 129]/255; [157 0 129]/255; [129 157 0]/255; [230, 159, 0]/255; [129 0 157]/255;];
%% Files Loading Path
base_path = '..\Numerical\Post_Processing\Data\Energy_Volume_Area_Center_Of_Mass';
cd(base_path); % Verzeichniswechsel
%% TimeStep
deltaT = 0.01;
%% Figure
figure
sgtitle('Amplitude = 50', 'FontSize', 24, 'Interpreter', 'latex');
for i = 1:m
    E_Ges_Rel = load(['E_Ges_Rel_Num_', Name_ID(i,:), '.txt']);
    subplot(3,2,i);
    hold on
    plot(0:deltaT:(length(E_Ges_Rel)*deltaT)-deltaT,E_Ges_Rel(1:length(E_Ges_Rel)), shape(i), 'color', colors(i,:), 'MarkerSize', 15, 'LineWidth', 2.5);
    grid on;
    grid minor;
    xlim([0, length(E_Ges_Rel)*deltaT]);
    ylim([-2, 2]);
    xlabl = xlabel('$t$', 'FontSize', 20);
    ylabl = ylabel('${E}_{Fehler}\%$', 'FontSize', 20);
    set(gca, 'FontSize', 20);
    set(ylabl, 'Interpreter', 'latex');
    set(xlabl, 'Interpreter', 'latex');
    power = i-3;
    TitleName = strcat('Energie Fehler',{' '},['$a_2^{' num2str(power) '}$']); 
    Titl = title(TitleName, 'FontSize', 20, 'Interpreter', 'latex');
    x0=0; 
    y0=0;
    width=1000;
    height=400;
    set(gcf,'position',[x0,y0,width,height])
end

    % cd '..\export_fig-master'
    s1 = 'Energy_';
    s2 = date;
    s3 = Name_ID;
    s = strcat(s1,s2,'-',s3);
    % print2eps(s,gcf())