%% Animation Asymmetry
%% Schahin Akbari 24.07.2025
%% FDY Tu-Darmstadt
%% Load VectorStorages
clc
clear all
%% Anpassen
%% ####################
Name = '6_5_50_169'; % Name ID
InitialDeformation = 5;
%% ###########################
m = InitialDeformation-7;
base_path = '..\..\Data\Vector_Storages\L6\DeltaT_0_01';
full_path = fullfile(base_path, Name); % Kombiniere den Pfad mit der Name_ID
cd(full_path); % Verzeichniswechsel
A = load([Name, 'VectorSpeicherA.txt']); 
% Finde ersten Eintrag der == 0 ist.
% Trimme die Matritzen A 
firstZeroIndex = find(A(1,:) == 0, 1)-1;
A = A(:, 1:firstZeroIndex);
%% Equator 0, 45 ,90, 135, 180, 225, 270, 315
Equator_0 = zeros(1,firstZeroIndex+1);
Equator_45 = zeros(1,firstZeroIndex+1);
Equator_90 = zeros(1,firstZeroIndex+1);
Equator_135 = zeros(1,firstZeroIndex+1);
Equator_180 = zeros(1,firstZeroIndex+1);
Equator_225 = zeros(1,firstZeroIndex+1);
Equator_270 = zeros(1,firstZeroIndex+1);
Equator_315 = zeros(1,firstZeroIndex+1);
%% Naming for plots
s1 = 'Aquator_Position_';
s2 = Name;
s3 = date;
%% 
%%##########################
Volumen_abs     = load(['..\..\..\..\Energy_Volume_Area_Center_Of_Mass\Volumen_Abs_Num_',Name, '.txt']);
%R_sph                  = ((3*Volumen_abs(1))/(4*pi))^(1/3);
R_sph                  =  1/(sqrt(pi)*2); % Non-dimensionalisation
t_star              =  sqrt((0.07275)/(R_sph^3))';
dT                  = 0.01;
T                   = 0:dT:firstZeroIndex*dT;
T_star              = T*t_star;
%%##########################
Colors = {[230,0,26]/255,[0,90,169]/255,[245,163,0]/255, [114 16 133]/255, ...
          [0 157 129]/255,[230 0 26]/255,[253,202,0]/255,[0 0 0]/255}; % Farben
%% Running Timesteps
for Zeitschritt = 1:1:length(A(1,:)) % length()Safe every single timestep
%% Assign Coefficient
    for i = 0:eval('length(A(:,1))')-1
        eval(['a2_' num2str(i) ' = A(' num2str(i+1) ', Zeitschritt);']);
    end
    % R created with 
    R_rho = @(zetaa,phii) (7186705221432913.*2.^(1./2).*a2_0)./36028797018963968 + (21560115664298739.*2.^(1./2).*a2_20.*(3.*zetaa.^2.*(zetaa.^2 - 1) + (3.*(zetaa.^2 - 1).^2)./8 + zetaa.^4))./36028797018963968 + (7186705221432913.*2.^(1./2).*5.^(1./2).*a2_6.*((3.*zetaa.^2)./2 - 1./2))./36028797018963968 + (894211225725982185.*2.^(1./2).*a2_35.*cos(5.*phii).*(1 - zetaa.^2).^(5./2))./1926630427918425088 + (894211225725982185.*2.^(1./2).*a2_25.*sin(5.*phii).*(1 - zetaa.^2).^(5./2))./1926630427918425088 - (7186705221432913.*2.^(1./2).*11.^(1./2).*a2_30.*((15.*zetaa.*(zetaa.^2 - 1).^2)./8 + 5.*zetaa.^3.*(zetaa.^2 - 1) + zetaa.^5))./36028797018963968 - (7186705221432913.*2.^(1./2).*7.^(1./2).*a2_12.*((3.*zetaa.*(zetaa.^2 - 1))./2 + zetaa.^3))./36028797018963968 - (14891592839477698575.*2.^(1./2).*a2_48.*cos(6.*phii).*(zetaa.^2 - 1).^3)./30826086846694801408 + (7186705221432913.*2.^(1./2).*13.^(1./2).*a2_42.*((15.*zetaa.^4.*(zetaa.^2 - 1))./2 + (5.*(zetaa.^2 - 1).^3)./16 + (45.*zetaa.^2.*(zetaa.^2 - 1).^2)./8 + zetaa.^6))./36028797018963968 - (7186705221432913.*2.^(1./2).*3.^(1./2).*a2_2.*zetaa)./36028797018963968 - (14891592839477698575.*2.^(1./2).*a2_36.*sin(6.*phii).*(zetaa.^2 - 1).^3)./30826086846694801408 - (1494034203011081.*2.^(1./2).*a2_39.*sin(3.*phii).*(1 - zetaa.^2).^(3./2).*(21772800.*zetaa.*(zetaa.^2 - 1) + 58060800.*zetaa.^3))./16646086897215192760320 + (1125899906842624.*2.^(1./2).*3.^(1./2).*a2_3.*cos(phii).*(1 - zetaa.^2).^(1./2))./5644425081792261 + (140737488355328.*2.^(1./2).*35.^(1./2).*a2_24.*cos(4.*phii).*(zetaa.^2 - 1).^2)./1881475027264087 + (1125899906842624.*2.^(1./2).*3.^(1./2).*a2_1.*sin(phii).*(1 - zetaa.^2).^(1./2))./5644425081792261 + (140737488355328.*2.^(1./2).*35.^(1./2).*a2_16.*sin(4.*phii).*(zetaa.^2 - 1).^2)./1881475027264087 - (1413872091292528665.*2.^(1./2).*a2_34.*zetaa.*cos(4.*phii).*(zetaa.^2 - 1).^2)./963315213959212544 - (1413872091292528665.*2.^(1./2).*a2_26.*zetaa.*sin(4.*phii).*(zetaa.^2 - 1).^2)./963315213959212544 + (323285426043821.*2.^(1./2).*a2_46.*cos(4.*phii).*(zetaa.^2 - 1).^2.*(239500800.*zetaa.^2 - 21772800))./19728695581884672901120 + (323285426043821.*2.^(1./2).*a2_38.*sin(4.*phii).*(zetaa.^2 - 1).^2.*(239500800.*zetaa.^2 - 21772800))./19728695581884672901120 - (12896497701802128645.*2.^(1./2).*a2_47.*zetaa.*cos(5.*phii).*(1 - zetaa.^2).^(5./2))./7706521711673700352 - (12896497701802128645.*2.^(1./2).*a2_37.*zetaa.*sin(5.*phii).*(1 - zetaa.^2).^(5./2))./7706521711673700352 - (1494034203011081.*2.^(1./2).*a2_45.*cos(3.*phii).*(1 - zetaa.^2).^(3./2).*(21772800.*zetaa.*(zetaa.^2 - 1) + 58060800.*zetaa.^3))./16646086897215192760320 - (4398046511104.*2.^(1./2).*10.^(1./2).*a2_19.*sin(phii).*(1 - zetaa.^2).^(1./2).*(2880.*zetaa.*(zetaa.^2 - 1) + 3840.*zetaa.^3))./28222125408961305 + (281474976710656.*2.^(1./2).*7.^(1./2).*10.^(1./2).*a2_15.*cos(3.*phii).*(1 - zetaa.^2).^(3./2))./5644425081792261 + (281474976710656.*2.^(1./2).*7.^(1./2).*10.^(1./2).*a2_9.*sin(3.*phii).*(1 - zetaa.^2).^(3./2))./5644425081792261 - (281474976710656.*2.^(1./2).*70.^(1./2).*a2_23.*zetaa.*cos(3.*phii).*(1 - zetaa.^2).^(3./2))./1881475027264087 - (281474976710656.*2.^(1./2).*70.^(1./2).*a2_17.*zetaa.*sin(3.*phii).*(1 - zetaa.^2).^(3./2))./1881475027264087 - (4398046511104.*2.^(1./2).*5.^(1./2).*a2_22.*cos(2.*phii).*(zetaa.^2 - 1).*(20160.*zetaa.^2 - 2880))./84666376226883915 - (4398046511104.*2.^(1./2).*5.^(1./2).*a2_18.*sin(2.*phii).*(zetaa.^2 - 1).*(20160.*zetaa.^2 - 2880))./84666376226883915 - (562949953421312.*2.^(1./2).*3.^(1./2).*5.^(1./2).*a2_8.*cos(2.*phii).*(3.*zetaa.^2 - 3))./16933275245376783 - (562949953421312.*2.^(1./2).*3.^(1./2).*5.^(1./2).*a2_4.*sin(2.*phii).*(3.*zetaa.^2 - 3))./16933275245376783 - (4398046511104.*2.^(1./2).*10.^(1./2).*a2_21.*cos(phii).*(1 - zetaa.^2).^(1./2).*(2880.*zetaa.*(zetaa.^2 - 1) + 3840.*zetaa.^3))./28222125408961305 + (2199023255552.*2.^(1./2).*11.^(1./2).*105.^(1./2).*a2_28.*sin(2.*phii).*(zetaa.^2 - 1).*(201600.*zetaa.*(zetaa.^2 - 1) + 403200.*zetaa.^3))./8889969503822811075 - (1125899906842624.*2.^(1./2).*3.^(1./2).*5.^(1./2).*a2_7.*zetaa.*cos(phii).*(1 - zetaa.^2).^(1./2))./5644425081792261 - (1099511627776.*2.^(1./2).*13.^(1./2).*21.^(1./2).*a2_43.*cos(phii).*(1 - zetaa.^2).^(1./2).*(604800.*zetaa.*(zetaa.^2 - 1).^2 + 2419200.*zetaa.^3.*(zetaa.^2 - 1) + 967680.*zetaa.^5))./5333981702293686645 - (1125899906842624.*2.^(1./2).*3.^(1./2).*5.^(1./2).*a2_5.*zetaa.*sin(phii).*(1 - zetaa.^2).^(1./2))./5644425081792261 - (1099511627776.*2.^(1./2).*13.^(1./2).*21.^(1./2).*a2_41.*sin(phii).*(1 - zetaa.^2).^(1./2).*(604800.*zetaa.*(zetaa.^2 - 1).^2 + 2419200.*zetaa.^3.*(zetaa.^2 - 1) + 967680.*zetaa.^5))./5333981702293686645 + (35184372088832.*2.^(1./2).*6.^(1./2).*7.^(1./2).*a2_13.*cos(phii).*(1 - zetaa.^2).^(1./2).*(360.*zetaa.^2 - 72))./50799825736130349 - (274877906944.*2.^(1./2).*13.^(1./2).*210.^(1./2).*a2_44.*cos(2.*phii).*(zetaa.^2 - 1).*(9676800.*zetaa.^2.*(zetaa.^2 - 1) + 604800.*(zetaa.^2 - 1).^2 + 9676800.*zetaa.^4))./26669908511468433225 + (35184372088832.*2.^(1./2).*6.^(1./2).*7.^(1./2).*a2_11.*sin(phii).*(1 - zetaa.^2).^(1./2).*(360.*zetaa.^2 - 72))./50799825736130349 - (274877906944.*2.^(1./2).*13.^(1./2).*210.^(1./2).*a2_40.*sin(2.*phii).*(zetaa.^2 - 1).*(9676800.*zetaa.^2.*(zetaa.^2 - 1) + 604800.*(zetaa.^2 - 1).^2 + 9676800.*zetaa.^4))./26669908511468433225 + (549755813888.*2.^(1./2).*11.^(1./2).*70.^(1./2).*a2_33.*cos(3.*phii).*(1 - zetaa.^2).^(3./2).*(1814400.*zetaa.^2 - 201600))./8889969503822811075 + (4398046511104.*2.^(1./2).*11.^(1./2).*15.^(1./2).*a2_31.*cos(phii).*(1 - zetaa.^2).^(1./2).*(86400.*zetaa.^2.*(zetaa.^2 - 1) + 7200.*(zetaa.^2 - 1).^2 + 57600.*zetaa.^4))./1269995643403258725 + (549755813888.*2.^(1./2).*11.^(1./2).*70.^(1./2).*a2_27.*sin(3.*phii).*(1 - zetaa.^2).^(3./2).*(1814400.*zetaa.^2 - 201600))./8889969503822811075 + (4398046511104.*2.^(1./2).*11.^(1./2).*15.^(1./2).*a2_29.*sin(phii).*(1 - zetaa.^2).^(1./2).*(86400.*zetaa.^2.*(zetaa.^2 - 1) + 7200.*(zetaa.^2 - 1).^2 + 57600.*zetaa.^4))./1269995643403258725 + (562949953421312.*2.^(1./2).*7.^(1./2).*15.^(1./2).*a2_14.*zetaa.*cos(2.*phii).*(zetaa.^2 - 1))./5644425081792261 + (562949953421312.*2.^(1./2).*7.^(1./2).*15.^(1./2).*a2_10.*zetaa.*sin(2.*phii).*(zetaa.^2 - 1))./5644425081792261 + (2199023255552.*2.^(1./2).*11.^(1./2).*105.^(1./2).*a2_32.*cos(2.*phii).*(zetaa.^2 - 1).*(201600.*zetaa.*(zetaa.^2 - 1) + 403200.*zetaa.^3))./8889969503822811075;
    Equator_0(1,Zeitschritt)    = R_rho(0,0);
    Equator_45(1,Zeitschritt)   = R_rho(0,1*pi/4);
    Equator_90(1,Zeitschritt)   = R_rho(0,2*pi/4);
    Equator_135(1,Zeitschritt)  = R_rho(0,3*pi/4);
    Equator_180(1,Zeitschritt)  = R_rho(0,4*pi/4);
    Equator_225(1,Zeitschritt)  = R_rho(0,5*pi/4);
    Equator_270(1,Zeitschritt)  = R_rho(0,6*pi/4);
    Equator_315(1,Zeitschritt)  = R_rho(0,7*pi/4);
end
%% Plot
figure    
set(gca,'Fontsize',20); 
hold on
plot(T_star(1:end-1),Equator_0(1:end-1)/R_sph ,'-','color',Colors{8},'LineWidth',2)
plot(T_star(1:end-1),Equator_45(1:end-1)/R_sph,'-','color',Colors{2},'LineWidth',2)
plot(T_star(1:end-1),Equator_90(1:end-1)/R_sph,':','color',Colors{3},'LineWidth',2)
plot(T_star(1:end-1),Equator_135(1:end-1)/R_sph,'-','color',Colors{5},'LineWidth',2)
plot(T_star(1:6:end-1),Equator_180(1:6:end-1)/R_sph,'*','color',Colors{4},'LineWidth',2)
plot(T_star(1:6:end-1),Equator_225(1:6:end-1)/R_sph,'o','color',Colors{6},'LineWidth',2)
plot(T_star(1:8:end-1),Equator_270(1:8:end-1)/R_sph,'+','color',Colors{7},'LineWidth',2)
plot(T_star(1:6:end-1),Equator_315(1:6:end-1)/R_sph,'s','color',Colors{1},'LineWidth',2)
grid on
grid minor

xlabl = xlabel('$t$','FontSize',14);
set(xlabl,'Interpreter','latex')

ylabl = ylabel('$\mathcal{R}$','FontSize',14);
set(ylabl, 'Rotation', 0);     % Rotate the label to 90 degrees
set(ylabl,'Interpreter','latex')


set(gca,'Fontsize',20); 
legendEntry = [{'$\phi = 0$'}     ,{'$\phi = 1\pi/4$'},...
               {'$\phi = 2\pi/4$'},{'$\phi = 3\pi/4$'},...
               {'$\phi = 4\pi/4$'},{'$\phi = 5\pi/4$'},...
               {'$\phi = 6\pi/4$'},{'$\phi = 7\pi/4$'}],...
                lgd = legend(legendEntry,'Location','SouthEast','Interpreter','latex','FontSize',16 );
            
lgd.FontSize = 16;
% Setze zuerst die Legenden-Einheit auf Pixel
lgd.Units = 'pixels';
ldg_x0=800; 
ldg_y0=15;
ldg_width=200;
ldg_height=200;
lgd.Position = [ldg_x0, ldg_y0, ldg_width, ldg_height];
x0=0;
y0=0;
width=1000;
height=400;
set(gcf,'position',[x0,y0,width,height])         
%% Saving Pictures
cd '..\..\..\..\..\Plots\Code'
s0 = '..\Figures\';
s = strcat(s0,s1,s2,'_',s3);
print2eps(s,gcf())