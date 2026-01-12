function text = functionHandle2text(myString,outputName)
% Dein String

% Öffne (oder erstelle) eine Textdatei im Schreibmodus
fileID = fopen(outputName, 'w');

% Schreibe den String in die Datei
fprintf(fileID, '%s\n', myString);

% Schließe die Datei
fclose(fileID);