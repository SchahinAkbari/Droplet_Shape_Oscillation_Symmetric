    %%
    n=6;
    InitialDeformMod = 10;
    %%
    syms a 
    k = a^2
    Amplitude = 0.5;
    Mod = (n+1)^2;
    ampEntry = Amplitude/(200*sqrt(pi));
    A0 = zeros(1, Mod);
    B0 = zeros(1, Mod);
    A0(1, 1) = 1;
    A0(1, 5) = 25/(200*sqrt(pi));
    A0(1, 6) = 25/(200*sqrt(pi));
    A0(1, InitialDeformMod) = ampEntry;
    time = Main_A(A0,B0,Amplitude,n,InitialDeformMod);
    print(time);
    quit;
