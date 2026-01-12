%% Postprocessing;
%% 12.11.2024
%% Discrete Fourier Transformation 
%% Initialisierung
% Laden der Daten
clc
clear all 
%% Naming, Colors and Shapes
% Load Name of Value
Name_ID = '12_2_60_5_5'; % Name ID
base_path = '..\..\Data\Vector_Storages';
TimeStep = 'DeltaT_0_001';
TimeSteppScheme = 'BDF_2' ;

full_path = fullfile(base_path,'\', TimeSteppScheme, '\', TimeStep,'\', Name_ID); % Kombiniere den Pfad mit der Name_ID
cd(full_path); % Verzeichniswechsel
A = load([Name_ID, '_VectorSpeicherA.txt']); 
color = 'k';
% Naming for plots
s1 = 'DFT_';
s2 = 'Amplitude_2_60_5_5';
s3 = date;
%% Entdimensionalisierung
Volumen_abs     = load(['..\..\..\..\Energy_Volume_Area_Center_Of_Mass\Volumen_Abs_Num_',Name_ID,'_',TimeSteppScheme, '_',TimeStep, '.txt']);
%R0              = ((3*Volumen_abs(1))/(4*pi))^(1/3);
R0 = 1/(sqrt(pi)*2); % Non-dimensionalisation
t_star          =  sqrt((0.07275)/(R0^3))';
%% Time Steps [[Attention]] Not like below
% Zeitschritte_   = load(['..\Vector_Storages\', currentGroup{fileIdx}, '\', currentGroup{fileIdx},   'GesamtZeitschritt_Speicher1.txt']);
% Since, way too complicated to implement it with DFT and also no real
% uasage since      
A_star = A*sqrt(pi)*2;    % Normalization    
CutOff = 6964;     % Cut Off, after 5 Oscillation 
EndTime = CutOff*0.001;   %%%%% 0.001 = Zeitschritt
T   = 0:0.001:EndTime-0.001;
T_star = T*t_star;   %%%%%%entdimensionierte Zeit
%% Rayleigh Frequency  --->  Funktioniert fuer kleine Daten
h = @(l) sqrt((0.07275*l*(l+2)*(l-1))/(R0)^3);       
H=[h(2) h(3) h(4) h(5) h(6) h(7) h(8) h(9) h(10) h(11) h(12)];
H= H/(t_star*2*pi);
for i = [3 6]
    figure    
    set(gca,'Fontsize',20); 
    hold on
    plot(T_star(20:20:CutOff),A_star(i,20:20:CutOff),'-.','color',color,'LineWidth',2)
    grid on
    grid minor
    set(gca,'Fontsize',20); 
    legendEntry = ['$a_', num2str(i-1), '^*(t)$'];
    lgd = legend(legendEntry,'Location','NorthEastOutside','Interpreter','latex','FontSize',14 );
    xlim([0 12.5])
    x0=0;
    y0=0;
    width=1000;
    height=300;
    set(gcf,'position',[x0,y0,width,height])         
    %% DFT
    figure 
    Fs = 1000;            % Sampling frequency   weil Zeitschrittweite = 1/1000                    
    T = 1/Fs;             % Sampling period  
    L= length(A_star(i,10:CutOff)) ; %
    t = (0:L-1)*T;        % Time vector
    S = A_star(i,10:CutOff); % 
    Y = fft(S);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    h=stem(f(1:(end-1)/50)/t_star,P1(1:(end-1)/50),'filled','color',color);  %%%% stem fuer Plot    50 weil nur kleine Frequnzen benoetigt
    hb = get(h,'Baseline');
    set(hb,'Visible','off')
    %set(gca,'yscal','log')
    xticks([0 H(1) 0.7 2*H(1) 3*H(1) 1.6 H(4) 5*H(1) 2.5])
    xticklabels({'$0$','$f_2^R$', '$0.7$', '$2\,f_2^R$', '$3\,f_2^R$', '$1.6$', '$f_5^R$', '$5\,f_2^R$', '$2.5$'})
    xlim([0 0.45*H(11)])
        if i==3
        yticks([0 0.5])
        yticklabels({'$0$','$0.5$'})
        else i==6
        yticks([0 0.02])
        yticklabels({'$0$','$0.02$'})
        ylim([0 0.04])
        end
    set(gca,"TickLabelInterpreter",'latex')
    grid on
    grid minor
    legendEntry2 = ['$a_', num2str(i-1), '(t) \quad (a_2(0)=0.6 , a_5(0)=0.05)$'];
    lgd = legend(legendEntry2,'Location','NorthEast','Interpreter','latex');
    set(gca,'Fontsize',20); 
    ax = gca;
    properties(ax)
    k = .01;
      ax.TickLength = [k, k]; % Make tick marks longer.
      ax.LineWidth = 100*k; % Make tick marks thicker.
    x0=0;
    y0=0;
    width=1000;
    height=400;
    set(gcf,'position',[x0,y0,width,height])         
if i == 3
cd '..\..\..\..\..\Plots\Code'
end
s0 = '..\Figures\';
subbplot = ['a_', num2str(i-1)];
s = strcat(s0,s1,s2,'_',subbplot,'_log_off_',TimeSteppScheme,'_',TimeStep,'_',s3);
print2eps(s,gcf())
end
