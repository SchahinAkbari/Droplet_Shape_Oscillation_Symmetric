function Expression = StringManipulator(Expression)
%Operatoren ersetzen
Expression = strrep(Expression, '/', './');
Expression = strrep(Expression, '^', '.^');
Expression = strrep(Expression, '*', '.*');
Expression = ['@(zetaa, phii) ' Expression];