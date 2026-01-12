function time = Start(Amplitude,n)
    Mod = (n+1)^2;
    ampEntry = Amplitude/(200*sqrt(pi));
    InitialDeformMod = 7;
    A0 = zeros(1, Mod);
    B0 = zeros(1, Mod);
    A0(1, 1) = 1;
    A0(1, InitialDeformMod) = ampEntry;
    time = Main_A(A0,B0,Amplitude,n,InitialDeformMod);
end
