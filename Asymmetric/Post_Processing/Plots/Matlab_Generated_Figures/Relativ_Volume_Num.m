%% Postprocessing;
%% 12.11.2024
%% Akbari && Noori
%% Energy plot: 
%% Initialisierung
clc
clear all
%% Naming, Colors and Shapes
% Load Name of Value
Name_of_Value = 'Volumen_Rel_Num_';
Name_of_Vol_Abs_Num = 'Volumen_Abs_Num_';
Name_ID = {'6_5_50_127';'6_6_50_99';'6_7_50_99';'6_8_50_92';'6_9_50_11'}; 
m = length(Name_ID(:,1));  % Number of PLots
shape = ['--', '--', '--', '--', '--'];
colors = [[0 157 129]/255; [157 0 129]/255; [129 157 0]/255; [230, 159, 0]/255; [129 0 157]/255;];
% Naming for plots
s1 = 'Volume_Num_';
s2 = 'Amplitude_50_';
s3 = date;
%% Files Loading Path
base_path = '..\..\Data\Energy_Volume_Area_Center_Of_Mass';
cd(base_path); % Verzeichniswechsel
%% TimeStep
deltaT = 0.01;
%% Figure
figure
sgtitle('Volume Deviation [Amplitude = 50, numerical]', 'FontSize', 24, 'Interpreter', 'latex');
for i = 1:m
    %% Entdimensionalisierung
    Volumen_abs     = load([Name_of_Vol_Abs_Num, Name_ID{i,:}, '.txt']);
    R0              = ((3*Volumen_abs(1))/(4*pi))^(1/3);
    t_star          =  sqrt((0.07275)/(R0^3))';
    %% Plot
    V_Ges_Rel = load([Name_of_Value, Name_ID{i,:}, '.txt']);
    subplot(3,2,i);
    hold on
    plot((0:deltaT:(length(V_Ges_Rel)*deltaT)-deltaT)*t_star,V_Ges_Rel(1:length(V_Ges_Rel)), shape(i), 'color', colors(i,:), 'MarkerSize', 15, 'LineWidth', 2.5);
    grid on;
    grid minor;
    xlim([0, length(V_Ges_Rel)*deltaT*t_star]);
    ylim([-0.02, 0]);
    xlabl = xlabel('$t$', 'FontSize', 20, 'Interpreter', 'latex');
    ylabl = ylabel('${V}_{Dev}\%$', 'FontSize', 20, 'Interpreter', 'latex');
    set(gca, 'FontSize', 20);
    power = i-3;
    TitleName = strcat('Initial Deformation',{' '},['$\mathcal{I}_2^{' num2str(power) '}$']); 
    Titl = title(TitleName, 'FontSize', 20, 'Interpreter', 'latex');
end
%% Plot Size and Saving as esp
x0=0; 
y0=0;
width=1000;
height=800;
set(gcf,'position',[x0,y0,width,height])

cd '..\..\Plots\Code'
s0 = '..\Figures\';
s = strcat(s0,s1,s2,s3);
print2eps(s,gcf())