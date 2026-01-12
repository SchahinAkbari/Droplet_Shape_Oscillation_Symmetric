function timeElapsed = Main_A(A0,B0,Amplitude,n, InitialDeformMod)
%% Intro
% Schahin Akbari 31.05.2020
% Masterthesis
% NumericaL Drop Oscillation with arbitrary large Deformation
%% Initialization
tic
parpool('local', 32);
% n                                         % Max. degree
Mod             = (n+1)^2;                   % Number of modes
MaxZeitschritte = 400;                        % Max. Time Steps
JacobiMatrix_Reshape    = zeros((2*Mod)^2,1);      % Initialize
isaninteger = @(x)isfinite(x) & x==floor(x);
VectorSpeicherA                = zeros(Mod,MaxZeitschritte);   %Storage for A coefficients
VectorSpeicherB                = zeros(Mod,MaxZeitschritte);   %Storage for B coefficients
Iter_Newton_Gedaempft_Speicher = zeros(MaxZeitschritte,12);    %Storage for Iteration of damping cycles 
StopNewtonGedaempft            = zeros(MaxZeitschritte,1);     %Matrix for damped Newton Method 
ResiduumSpeicher               = zeros(MaxZeitschritte,12);    %Storage for Residuum
KondiZahlJacobi                = zeros(MaxZeitschritte,12);    %Storage for Jacobi Number
% Einheitvektor                  = eye(Mod);                     %Identity Matrix for newton Pertubation 
X                              = zeros(Mod*2,1);               %Vector for Function
TimeStep_Storage = zeros(1, MaxZeitschritte);
%% Amplitudes
A1 = A0;
A2 = A0;
B1 = zeros(1, Mod);
B2 = zeros(1, Mod);
VectorSpeicherA(:,1)=A1;
VectorSpeicherB(:,1)=B1;

%% Data for Newton Method
epsilon         = 10^(-7);     % Pertubation Jacobi Matrix
%DeltaT          = 0.01;       % Step Size
DeltaT           = 0.075;       % Step Size;
Sigma           = zeros(1,16); % Steps for the damped Newton Method
Sigma(1)=1;
for nn = 1:15
   Sigma(nn+1)=  1/(2^(nn));
end
phiii = 10^-(10);                % Tolerance

Equation_GeneratorAsymmetry1
Equation_GeneratorAsymmetry
%% Newton Verfahren
for TimeStep =1:MaxZeitschritte
    if TimeStep == 1    
        X(1:2:2*Mod) = A1;
        X(2:2:2*Mod) = B1;
        for k=1:11
            tic;
            D_Res0      = NumIntegration1(A1,A0,B1,B0,DeltaT);      % Residuum
            L2Norm_quadrat0 = D_Res0'*D_Res0;               % Square of L2 Norm
            parfor KK =1:(Mod*2)^2                             % size(non_crack_bytes); % access whole of non_crack_bytes
                if mod(Spaltenfunction(KK,Mod),2) == 1
                    %% Jacobian         
                    F = NumIntegration1_Zeilee(A1+(epsilon*(Einheitsvektor(KK,Mod))'),A0,B1,B0,DeltaT,KK) %% Creat
                    JacobiMatrix_Reshape(KK) = (1/epsilon)*(F-Resfunction(D_Res0,KK,Mod))     
                else
                    G = NumIntegration1_Zeilee(A1,A0,B1+(epsilon*(Einheitsvektor(KK,Mod))'),B0,DeltaT,KK) %% with
                    JacobiMatrix_Reshape(KK) = (1/epsilon)*(G-Resfunction(D_Res0,KK,Mod))                        %% pertubation epsilon

                end
            end
            JacobiMatrix = reshape(JacobiMatrix_Reshape,2*Mod,2*Mod);%%
            Delta = - linsolve(JacobiMatrix,D_Res0);        % Delta as Newton step
            %% Damping
            for p =1:15                                     % loop for damped Newton
                X1    = X + Delta*Sigma(p);                 % X1 new Soltuion for function
        
                A1 = (X1(1:2:2*Mod))';                      %reassign
                B1 = (X1(2:2:2*Mod))';                      %reassign
        
                D_Res1= NumIntegration1(A1,A0,B1,B0,DeltaT);      % calculate new Residuum.
                L2Norm_quadrat1 = D_Res1'*D_Res1;        % Square of L2 Norm
                L2Norm_1 = sqrt(L2Norm_quadrat1);         % L2 Norm
        
                if L2Norm_quadrat1 < (1-(1/(500))*Sigma(p))*L2Norm_quadrat0  % Check if L2_Norm got smaller.   
                    if p==1                                                  % If L2_Norm is smaller, Convergence Radius is reached          
                        StopNewtonGedaempft (TimeStep,1)=1;                  % Set to 1 if p==1                   
                    end
                    break                                % Break, since L2 Norm got smaller
                end
                if StopNewtonGedaempft (TimeStep,1)==1
                    break                                % Break, since the Convergence Radius is reaced   
                end
                A1 = X(1:2:2*Mod);  %Reassignment % If L2_Norm doesn't got smaller, repete the last step with half of the step size                                  
                B1 = X(2:2:2*Mod);  %Reassignment % If L2_Norm doesn't got smaller, repete the last step with half of the step size
            end
            Iter_Newton_Gedaempft_Speicher(TimeStep,k)=p; % Assign Number of steps from damped Newton to storage
            ResiduumSpeicher(TimeStep,k)=L2Norm_1;        % Assign Residuum to storage
            KondiZahlJacobi (TimeStep,k) = cond(JacobiMatrix);  %Assign Jacobian Number to stoage
            
            elapsedTime = toc;
            TimeStep_Storage(TimeStep, k) = elapsedTime;

            if L2Norm_1 < phiii              
                break               % Stop if L2_norm is smaller than tolerance
            end
            if k>1 &&  ResiduumSpeicher(TimeStep,k-1)*0.99 < ResiduumSpeicher(TimeStep,k)
                break               % Stop if L2_norm does not decrease enough
            end
            X = X1;                 % Assign new Soltuion for function
        end
        X = X1;                     % Assign new Soltuion for function
        VectorSpeicherA(:,TimeStep+1)=A1; %Assign Coefficient to storage
        VectorSpeicherB(:,TimeStep+1)=B1; %Assign Coefficient to storage

%% Aenderungen
        %  if 1==isaninteger(Intt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Speichergroesse
        Speicher_Sequenz =1 ;
        Intt = TimeStep/Speicher_Sequenz;
          writematrix(VectorSpeicherA,strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_',strcat(int2str(TimeStep),'VectorSpeicherA.txt')));
          writematrix(VectorSpeicherB,strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_',strcat(int2str(TimeStep),'VectorSpeicherB.txt')));%Output for Feedback which current Timestep is calculated       
          writematrix(A1,strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_',strcat(int2str(TimeStep),'A.txt')));
          writematrix(B1,strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_',strcat(int2str(TimeStep),'B.txt')));
          writematrix(ResiduumSpeicher',strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_',strcat(int2str(Intt),'ResiduumSpeicher.txt')));     
          writematrix(TimeStep_Storage',strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_',strcat(int2str(Intt),'TimeStep_Storage.txt')));     
%% Aenderungen
%    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        A2=A1*2 - A0;  % Assign new Coefficient to old coeffient
        B2=B1*2 - B0;  % Assign new Coefficient to old coeffient

    else
        X(1:2:2*Mod) = A2;
        X(2:2:2*Mod) = B2;
        for k=1:11
            tic;
            D_Res0      = NumIntegration(A2,A1,A0,B2,B1,B0,DeltaT);      % Residuum
            L2Norm_quadrat0 = D_Res0'*D_Res0;               % Square of L2 Norm
            parfor KK =1:(Mod*2)^2                             % size(non_crack_bytes); % access whole of non_crack_bytes
                if mod(Spaltenfunction(KK,Mod),2) == 1
                    %% Jacobian          
                    F = NumIntegration_Zeilee(A2+(epsilon*(Einheitsvektor(KK,Mod))'),A1,A0,B2,B1,B0,DeltaT,KK); %% Creat
                    JacobiMatrix_Reshape(KK) = (1/epsilon)*(F-Resfunction(D_Res0,KK,Mod))     
                else
                    G = NumIntegration_Zeilee(A2,A1,A0,B2+(epsilon*(Einheitsvektor(KK,Mod))'),B1,B0,DeltaT,KK); %% with
                    JacobiMatrix_Reshape(KK) = (1/epsilon)*(G-Resfunction(D_Res0,KK,Mod))                        %% pertubation epsilon
                end
            end
            JacobiMatrix = reshape(JacobiMatrix_Reshape,2*Mod,2*Mod);%%
            Delta = - linsolve(JacobiMatrix,D_Res0);        % Delta as Newton step
            %% Damping
            for p =1:15                                     % loop for damped Newton
                X1    = X + Delta*Sigma(p);                 % X1 new Soltuion for function
        
                A2 = (X1(1:2:2*Mod))';                      %reassign
                B2 = (X1(2:2:2*Mod))';                      %reassign
        
                D_Res1= NumIntegration(A2,A1,A0,B2,B1,B0,DeltaT);      % calculate new Residuum.
                L2Norm_quadrat1 = D_Res1'*D_Res1;        % Square of L2 Norm
                L2Norm_1 = sqrt(L2Norm_quadrat1);         % L2 Norm
        
                if L2Norm_quadrat1 < (1-(1/(500))*Sigma(p))*L2Norm_quadrat0  % Check if L2_Norm got smaller.   
                    if p==1                                                  % If L2_Norm is smaller, Convergence Radius is reached          
                        StopNewtonGedaempft (TimeStep,1)=1;                  % Set to 1 if p==1                   
                    end
                    break                                % Break, since L2 Norm got smaller
                end
                if StopNewtonGedaempft (TimeStep,1)==1
                    break                                % Break, since the Convergence Radius is reaced   
                end
                A2 = X(1:2:2*Mod);  %Reassignment % If L2_Norm doesn't got smaller, repete the last step with half of the step size                                  
                B2 = X(2:2:2*Mod);  %Reassignment % If L2_Norm doesn't got smaller, repete the last step with half of the step size
            end
            Iter_Newton_Gedaempft_Speicher(TimeStep,k)=p; % Assign Number of steps from damped Newton to storage
            ResiduumSpeicher(TimeStep,k)=L2Norm_1;        % Assign Residuum to storage
            KondiZahlJacobi (TimeStep,k) = cond(JacobiMatrix);  %Assign Jacobian Number to stoage

            elapsedTime = toc;
            TimeStep_Storage(TimeStep, k) = elapsedTime;

            if L2Norm_1 < phiii              
                break               % Stop if L2_norm is smaller than tolerance
            end
            if k>1 &&  ResiduumSpeicher(TimeStep,k-1)*0.99 < ResiduumSpeicher(TimeStep,k)
                break               % Stop if L2_norm does not decrease enough
            end
            X = X1;                 % Assign new Soltuion for function
        end
        X = X1;                     % Assign new Soltuion for function
        VectorSpeicherA(:,TimeStep+1)=A2; %Assign Coefficient to storage
        VectorSpeicherB(:,TimeStep+1)=B2; %Assign Coefficient to storage
%% Speichergroesse
        Speicher_Sequenz =1 ;
        Intt = TimeStep/Speicher_Sequenz;
        if 1==isaninteger(Intt)
          writematrix(VectorSpeicherA,strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_',strcat(int2str(Intt),'VectorSpeicherA.txt')));
          writematrix(VectorSpeicherB,strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_',strcat(int2str(Intt),'VectorSpeicherB.txt')));%Output for Feedback which current Timestep is calculated       
          writematrix(A1,strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_',strcat(int2str(Intt),'A.txt')));
          writematrix(B1,strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_',strcat(int2str(Intt),'B.txt')));%Output for Feedback which current Timestep is calculated       
          writematrix(ResiduumSpeicher',strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_',strcat(int2str(Intt),'ResiduumSpeicher.txt')));     
          writematrix(TimeStep_Storage',strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_',strcat(int2str(Intt),'TimeStep_Storage.txt'))); 
        end
        A0 = A1;
        B0 = B1;
        A1 = A2;  % Assign new Coefficient to old coeffient
        B1 = B2;  % Assign new Coefficient to old coeffient
        B2 = B1*2 - B0;
        A2 = A1*2 - A0;
    end
end
        
        

%%
 writematrix(VectorSpeicherA,strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_','VectorSpeicherA.txt'));
 writematrix(VectorSpeicherB,strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_','VectorSpeicherB.txt'));
 writematrix(Iter_Newton_Gedaempft_Speicher',strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_','Iter_Newton_Gedaempft_Speicher.txt'));
 writematrix(StopNewtonGedaempft',strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_','StopNewtonGedaempft.txt'));
 writematrix(ResiduumSpeicher',strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_','ResiduumSpeicher.txt'));
 writematrix(KondiZahlJacobi',strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_','KondiZahlJacobi.txt'));
 writematrix(TimeStep_Storage',strcat(int2str(n),'_',int2str(InitialDeformMod),'_',int2str(Amplitude),'_','TimeStep_Storage.txt')); 
 timeElapsed = 1;
 quit;
end