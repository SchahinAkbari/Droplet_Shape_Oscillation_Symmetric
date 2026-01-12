%% Animation Asymmetry
%% Schahin Akbari 21.08.2025
%% FDY Tu-Darmstadt
%% Load VectorStorages
clc
clear all
%% Creat Spherical Harmonics
Spherical_Mode = 16;
n=6;
 for L=0:n           % L = degree
     for m= -L:L        % M = Order
          YLM{L^2+L+m+1} = SphericalHarmonics(L,m);    % Single Spherical Harmonics
     end
 end
 %% Initialisation of Grid for Plotting                          % 
zetaa = -1:0.02:1.0;                      % polar angle
phii = 0:pi/40:2*pi;                    % azimuth angle
[phii,zetaa] = meshgrid(phii,zetaa);    % define the grid
 for i = 1:numel(YLM)
    funH = char(YLM{i});
    modifiedExpression = strrep(funH, '^', '.^');
    modifiedExpression = strrep(modifiedExpression, '*', '.*');
    modifiedExpression = strrep(modifiedExpression, '/', './');
      newYLM{i} = strtrim(modifiedExpression);
 end
R_rho = eval(newYLM{Spherical_Mode});
% Mapping
R = R_rho.*sqrt(1-zetaa.^2);     % convert to Cartesian coordinates
x = R.*cos(phii);                % convert to Cartesian coordinates
y = R.*sin(phii);                % convert to Cartesian coordinates
z = R_rho.*zetaa;                % convert to Cartesian coordinates
%% Plot
%% 3-D
fig = figure('Position',[0 0 3840 2160]);

s = surf(x,y,z);                 
shading faceted                  % behält die Kantenlinien auf der Oberfläche

%% Camera, Angle and Settings
light;                           % Lichtquelle
lighting gouraud;                % sanfte Schattierung
axis equal                       % gleiche Maßstäbe
box on                           % nur den Rahmen behalten

% Keine Achsenbeschriftungen oder Gitter im Hintergrund
set(gca,'XColor','none', ...
        'YColor','none', ...
        'ZColor','none', ...
        'TickLength',[0 0], ...
        'GridColor','none')

grid off                         % Gitterlinien ausschalten

view(40,30)
set(gcf,'Color','w')             % weißer Hintergrund


fname = fullfile(sprintf('harmonic_%03d.png', Spherical_Mode));
exportgraphics(fig, fname, 'BackgroundColor','none', 'Resolution', 300);
