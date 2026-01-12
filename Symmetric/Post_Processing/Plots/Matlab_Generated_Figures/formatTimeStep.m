function TIMESTEP = formatTimeStep(TimeStep)
    % Entferne das Prefix 'DeltaT_'
    numPart = erase(TimeStep, 'DeltaT_');
    
    % Ersetze '_' durch '.'
    numPart = strrep(numPart, '_', '.');
    
    % Baue LaTeX-String
    TIMESTEP = ['$\Delta t = ', numPart, '$'];
end
