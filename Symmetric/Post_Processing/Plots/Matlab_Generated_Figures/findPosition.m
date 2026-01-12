function [idx_low, idx_high, exact_pos, local_frac] = findPosition(dt1, target)
% findPosition  Lokale Position eines Targets in der kumulativen Folge dt1
%
%   [idx_low, idx_high, exact_pos, local_frac] = findPosition(dt1, target)
%
% Inputs
%   dt1   : Vektor positiver Schrittweiten
%   target: gesuchte kumulative Zielsumme
%
% Outputs
%   idx_low   : untere Indexgrenze (0 bedeutet vor dem ersten Element)
%   idx_high  : obere Indexgrenze
%   exact_pos : kontinuierliche Indexposition (z.B. 7.3 zwischen 7 und 8)
%   local_frac: Anteil im aktuellen Intervall [idx_low, idx_high] zwischen 0 und 1

    cumVals   = cumsum(dt1(:).');
    totalSum  = cumVals(end);
    tol       = max(eps(totalSum), eps);

    % Vor- und Nachbereich
    if target <= 0
        idx_low   = 0; 
        idx_high  = 1; 
        local_frac= target / cumVals(1);
        exact_pos = idx_low + local_frac;
        return;
    end

    if target >= totalSum
        idx_low   = numel(dt1)-1;
        idx_high  = numel(dt1);
        local_frac= 1;
        exact_pos = idx_high;
        return;
    end

    % Intervall finden
    idx_high = find(cumVals >= target - tol, 1, 'first');
    idx_low  = idx_high - 1;

    prev_sum = 0;
    if idx_low > 0
        prev_sum = cumVals(idx_low);
    end

    % Prüfen, ob wir genau auf der Grenze sind
    if abs(target - cumVals(idx_high)) <= tol
        local_frac = 1;      % am oberen Rand
        exact_pos  = idx_high;
        return;
    end

    % Normales Intervall
    local_frac = (target - prev_sum) / (cumVals(idx_high) - prev_sum);
    exact_pos  = idx_low + local_frac;
end
