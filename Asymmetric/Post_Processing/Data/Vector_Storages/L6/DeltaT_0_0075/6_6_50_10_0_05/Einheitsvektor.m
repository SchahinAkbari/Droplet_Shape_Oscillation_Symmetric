function E = Einheitvektor(Zeilee, Mod)
	Denom = Zeilee/(2*Mod);
	isaninteger = @(x)isfinite(x) & x==floor(x);	if 1==isaninteger(Denom)
		Spalte = Denom;
	else
		Spalte=fix(Denom)+1;
	end
	E_vektor_Speicher=zeros(Mod,2*Mod);
	for i=1:Mod
		E_vektor_Speicher(i,2*i)=1;
		E_vektor_Speicher(i,2*i-1)=1;
	end
	E= E_vektor_Speicher(:,Spalte);
end
