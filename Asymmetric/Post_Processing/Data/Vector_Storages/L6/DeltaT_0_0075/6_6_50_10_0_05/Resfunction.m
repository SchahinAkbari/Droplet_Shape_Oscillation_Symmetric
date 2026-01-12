function Res = Resfunction(Residum,Zeilee,Mod)
	Denom = Zeilee/(2*Mod);
	isaninteger = @(x)isfinite(x) & x==floor(x);	if 1==isaninteger(Denom)
		Zeile1 = Mod*2;
	else
		Zeile1=rem(Zeilee,2*Mod);
	end
	Res= Residum(Zeile1);
end
