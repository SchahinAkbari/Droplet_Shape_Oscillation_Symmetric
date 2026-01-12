function Spalte1 = Spaltenfunction(Zeilee,Mod)
	Denom = Zeilee/(2*Mod);
	isaninteger = @(x)isfinite(x) & x==floor(x);	if 1==isaninteger(Denom)
		Spalte1 = Denom;
	else
		Spalte1=fix(Denom)+1;
	end
end
