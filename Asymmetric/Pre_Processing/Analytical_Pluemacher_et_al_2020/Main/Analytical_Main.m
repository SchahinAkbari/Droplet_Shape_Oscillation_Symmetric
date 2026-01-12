%% Initialization
clc
clear all
n=6 ;                   % maxmal Degree
q0  =0;
R0  =4.6*10^(-5);
epsilon2=0.1;
epsilon1=0.1;
Mod = (n+1)^2;
YLM  = cell(Mod,1);
tau_initial=0;
mu = 0.07275;           % surface tension
rho=1;                  % Dichte
kesi=mu/(rho*R0^3);
Y0=(7186705221432913*2^(1/2))/36028797018963968;
%% Creat Spherical Harmonics        
 for L=0:n              % L = degree
     for m= -L:L        % M = Order
          YLM{L^2+L+m+1} = SphericalHarmonics(L,m);    % Single Spherical Harmonics
     end
 end
%% Variables and assignmens
syms zetaa 
syms phii
syms deltaT
syms t
%%       
Omega=cell(Mod,1);
AMP=cell(Mod,1);
Tau = cell(Mod, 1); % Zell-Array erstellen
for i = 1:Mod
    Tau{i} = 0; % Jede Zelle mit 0 initialisieren
end

%% Omega Frequenz
for L=0:n
    for m=-L:L

       Omega{L^2+L+m+1}=sqrt(mu*L*(L+2)*(L-1)/(rho*R0^3));
       %Tau{L^2+L+m+1}=tau_initial;
    end
end
%% 
%% Main function
% Initial conditions
% for Modal=(n^2+1):Mod
for Modal=[9,8,7,6,5]     %% SA Was heisst Modal 2? Im vergleich zu Formel von Pluemacher

    for amp=[50,10]   %% SA Amplitude 5 im Bezug auf Pluemacher oder auf Akbari?                     
%         ,35,65,95,125
        
        Amplitude=amp;
        A0matrix  = Amplitude*R0/((200*sqrt(pi))*(epsilon2)*Y0)*eye(Mod);  %% SA entdimensionieren? bzw. zum vergleichen?                     
        
        AB=A0matrix((Modal),:);  %% SA Anfangswert wird hier gesetzt.
        for i=1:Mod              % L = degree
            AMP{i}=AB(i);
        end
        %% erste Ordernung
        AA1=cell(Mod,1);
        AA2=cell(Mod,1);
        BB1=cell(Mod,1);
        BB2=cell(Mod,1);
        
        for L=0:n
            for m=-L:L
        
                if L==0||L==1
        
                BB1{L^2+L+m+1}=0; % % Seite S8( Seite 8) SA Confirmation
                AA1{L^2+L+m+1}=0; %
                else
                AA1{L^2+L+m+1}=AMP{L^2+L+m+1}*cos(Omega{L^2+L+m+1}*t+Tau{L^2+L+m+1}); %% SA Confirmation
                % equation 50, S7
                BB1{L^2+L+m+1}=-(R0/L)*AMP{L^2+L+m+1}*Omega{L^2+L+m+1}*sin(Omega{L^2+L+m+1}*t+Tau{L^2+L+m+1}); %% SA Confirmation
                % equation 52, S8

                end
            end
        end
        
        
        %% for second order        
        Omega_P=cell(Mod,Mod);   % frequency Omega_positiv
        Omega_N=cell(Mod,Mod);   % frequency Omega_negativ
        h_1_N=cell(Mod,Mod);     % h1_fucntion_positiv
        h_1_P=cell(Mod,Mod);     % h1_function_negativ
        h_2_N=cell(Mod,Mod);     % h2_fucntion_positiv
        h_2_P=cell(Mod,Mod);     % h2_function_negativ
        
        
        H_1_N=cell(Mod,Mod,Mod);
        H_1_P=cell(Mod,Mod,Mod);        
        %% k_1=j,k_2=k,
               
        C_tilde_1=cell(Mod,Mod,Mod);
        C_tilde_2=cell(Mod,Mod,Mod);
        C_tilde_3=cell(Mod,Mod,Mod);
        C_tilde_4=cell(Mod,Mod,Mod);
        
        D_tilde_1_N=cell(Mod,Mod,Mod);
        D_tilde_1_P=cell(Mod,Mod,Mod);
        D_tilde_2_N=cell(Mod,Mod,Mod);
        D_tilde_2_P=cell(Mod,Mod,Mod);
        
        nu_1_N=cell(Mod,Mod);
        nu_1_P=cell(Mod,Mod);
        nu_2_N=cell(Mod,Mod);
        nu_2_P=cell(Mod,Mod);
        
        for j=1:Mod
            for k=1:Mod
                Omega_N{j,k}=Omega{j}-Omega{k};%equation 61, S9 // SA Confirmation
                Omega_P{j,k}=Omega{j}+Omega{k};%equation 61, S9 // SA Confirmation
                h_1_P{j,k}=cos(Omega_P{j,k}*t);%equation 60, S8 // SA Confirmation
                h_2_P{j,k}=sin(Omega_P{j,k}*t);%equation 60, S8 // SA Confirmation
                h_1_N{j,k}=cos(Omega_N{j,k}*t);%equation 60, S8 // SA Confirmation
                h_2_N{j,k}=sin(Omega_N{j,k}*t);%equation 60, S8 // SA Confirmation
                
            end
        end        
        %%       
        for l=0:n %l
            for j=0:n %k1
                for k =0:n %k2
                    for m=-l:l
                        for q=-j:j
                            for z=-k:k
        
                                if k==0
                                    C_tilde_1{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}=0;
                                else
                                    C_tilde_1{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}=1/(2*k)*(-j*(j+1)+k*(k+1)+l*(l+1))-(l+2);
                                %equaqtion B2, S17 // SA confirmation
                                end
                                if j==0||k==0
                                    C_tilde_2{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}=0;
                                else
                                    C_tilde_2{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}=l/(4*j*k)*(2*j*k+l*(l+1)-j*(j+1)-k*(k+1));
                                %equaqtion B3, S17 // SA confirmation
                                end
                                C_tilde_3{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}=2*l*(j*(j+1)-1);
                                %equaqtion B4, S17 // SA confirmation
                                H_1_N{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}=-C_tilde_1{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}*Omega{k^2+k+z+1}^2+...
                                (C_tilde_1{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}+C_tilde_2{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1})*(Omega{j^2+j+q+1}*Omega{k^2+k+z+1})+...
                                kesi*C_tilde_3{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1};% S18 // SA wo ist C_tilde_4? Antowrt: Keine Viskosit�t deswegen = 0;
                                % SA Confirmation c ist = 0!
                                H_1_P{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}=-C_tilde_1{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}*Omega{k^2+k+z+1}^2-...
                                (C_tilde_1{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}+C_tilde_2{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1})*(Omega{j^2+j+q+1}*Omega{k^2+k+z+1})+...
                                kesi*C_tilde_3{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1};% S18 // SA wo ist C_tilde_4? Antwort: Keine Viskosit�t. Deswegen = 0;
                                % Sa Confirmation c ist = 0!
                                
                                % H_2_N und H_2_P = 0;

                                nu_1_P{j^2+j+q+1,k^2+k+z+1}=cos(Tau{j^2+j+q+1}+Tau{k^2+k+z+1});% equation B10, S18  // SA Confirmation
                                nu_1_N{j^2+j+q+1,k^2+k+z+1}=cos(Tau{j^2+j+q+1}-Tau{k^2+k+z+1});% equation B11, S18  // SA Confirmation
                                nu_2_P{j^2+j+q+1,k^2+k+z+1}=sin(Tau{j^2+j+q+1}+Tau{k^2+k+z+1});% equation B10, S18  // SA Confirmation
                                nu_2_N{j^2+j+q+1,k^2+k+z+1}=sin(Tau{j^2+j+q+1}-Tau{k^2+k+z+1});% equation B11, S18  // SA Confirmation
                    
                                D_tilde_1_P{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}= 0.5*AMP{j^2+j+q+1}*AMP{k^2+k+z+1}*H_1_P{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}*nu_1_P{j^2+j+q+1,k^2+k+z+1};
                                %equation B6, S17 // SA Confirmation 
                                D_tilde_2_P{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}=-0.5*AMP{j^2+j+q+1}*AMP{k^2+k+z+1}*H_1_P{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}*nu_2_P{j^2+j+q+1,k^2+k+z+1};
                                %equation B7, S17 // Sa Confirmation
                                D_tilde_1_N{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}= 0.5*AMP{j^2+j+q+1}*AMP{k^2+k+z+1}*H_1_N{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}*nu_1_N{j^2+j+q+1,k^2+k+z+1};
                                %equation B6, S17 // SA Confirmation
                                D_tilde_2_N{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}=-0.5*AMP{j^2+j+q+1}*AMP{k^2+k+z+1}*H_1_N{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}*nu_2_N{j^2+j+q+1,k^2+k+z+1};
                                %equation B7, S17 // SA Confirmation
                            end
                        end
                    end
                end
            end
        end                          
        %%                         
        B_1_N=cell(Mod,Mod,Mod);
        B_1_P=cell(Mod,Mod,Mod);
        B_2_N=cell(Mod,Mod,Mod);
        B_2_P=cell(Mod,Mod);
        B_N=cell(Mod,Mod);
        B_P=cell(Mod,Mod);
        D_1_N=cell(Mod,Mod);
        D_1_P=cell(Mod,Mod);
        D_2_N=cell(Mod,Mod);
        D_2_P=cell(Mod,Mod);
        
        P=cell(Mod,Mod,Mod);
              
        %%        
        for l=1:Mod
            for j=1:Mod
                for k=1:Mod
                    if (l==8&&k==5&&j==5) ||(l==16&&k==10&&j==10)%S10
                        
                        B_P{l,j,k}=2*Omega{l};%equation 69,S9 // SA confirmation
                        B_N{l,j,k}=2*Omega{l};%equation 69,S9 // SA Confirmation
                        
                        D_2_N{l,j,k}= D_tilde_1_N{l,j,k}*t/B_N{l,j,k};%equation 72,S9 // SA confirmation
                        D_2_P{l,j,k}= D_tilde_1_P{l,j,k}*t/B_P{l,j,k};%equation 72,S9 // SA confirmaiton
        
                        D_1_P{l,j,k}=-D_tilde_2_P{l,j,k}*t/B_P{l,j,k};%equation 72,S9 // SA confirmation
        
                        if Omega_N{j,k}<0 %equation 72,S9
                            D_1_N{l,j,k}=  D_tilde_2_N{l,j,k}*t/B_N{l,j,k};
                        else
                            D_1_N{l,j,k}= -D_tilde_2_N{l,j,k}*t/B_N{l,j,k};
                        end
                  
                    else
                        B_1_N{l,j,k}=Omega{l}^2-Omega_N{j,k}^2;%equation 68,S9 SA Confirmation
                        B_1_P{l,j,k}=Omega{l}^2-Omega_P{j,k}^2;%equation 68,S9 SA Confirmation
                        B_2_P{l,j,k}=0;%equation 68,S9 SA Confirmation
                        B_2_N{l,j,k}=0;%equation 68,S9 SA Confirmation
        
                        B_N{l,j,k}=B_1_N{l,j,k}^2+B_2_N{l,j,k}^2;%S9 SA Confirmation
                        B_P{l,j,k}=B_1_P{l,j,k}^2+B_2_P{l,j,k}^2;%S9 SA Confirmation
        
                        if B_N{l,j,k}==0
                            D_1_N{l,j,k}=0;
                            D_2_N{l,j,k}=0;
        
                        else
                        D_1_N{l,j,k}=(1/B_N{l,j,k})*B_1_N{l,j,k}*D_tilde_1_N{l,j,k};
                        D_2_N{l,j,k}=(1/B_N{l,j,k})*(B_1_N{l,j,k}*D_tilde_2_N{l,j,k});
                        %equation 71,S9 SA Confirmation
                        end
        
                        if B_P{l,j,k}==0
                            D_1_P{l,j,k}=0;
                            D_2_P{l,j,k}=0;
        
                        else
                        D_1_P{l,j,k}=(1/B_P{l,j,k})*B_1_P{l,j,k}*D_tilde_1_P{l,j,k};
                        D_2_P{l,j,k}=(1/B_P{l,j,k})*(B_1_P{l,j,k}*D_tilde_2_P{l,j,k});
                        %equation 71,S9 SA Confirmation
        
                        end  
                    end       
                    P{l,j,k}=D_1_P{l,j,k}*h_1_P{j,k}+D_1_N{l,j,k}*h_1_N{j,k}+D_2_P{l,j,k}*h_2_P{j,k}+D_2_N{l,j,k}*h_2_N{j,k};
                    %equation 70,S9 SA Confirmation
                end
            end       
        end
        %%  integral von 3 SpharicalHarmonics       
        load('IntegYYY.mat')
        % IntegYYY=cell(Mod,Mod,Mod);
        % for l=1:Mod
        %     l
        %     for j=1:Mod
        %         j
        %         for k=1:Mod
        %             YYY=YLM{l}*YLM{j}*YLM{k};
        %             if l==1 &&j ==1 && k==1
        %                 IntegYYY{l,j,k}=Y0^3*4*pi;
        %             else
        %                 try
        %                     Int1 = int(YYY,zetaa,-1,1);
        %                     IntegYYY{l,j,k} = int(Int1, phii ,0,2*pi);
        %                 catch
        %                     IntegYYY{l,j,k} = int(YYY, zetaa ,-1,1);
        %                 end
        %             end
        % 
        %             if IntegYYY{l,j,k}*IntegYYY{l,j,k}<0.000000001
        %                 IntegYYY{l,j,k}=0;
        %             end
        % 
        %         end
        %     end
        % end
%         %% 
%          for l=1:Mod
%             for j=1:Mod
%                 for k=1:Mod
%                     YYY=matlabFunction(YLM{l}*YLM{j}*YLM{k});
%                     if l==1 &&j ==1 && k==1
%                         IntegYYY{l,j,k}=Y0^3*4*pi;
%                     else
%                         try
%                         IntegYYY{l,j,k}=integral2(YYY,-1,1,0,2*pi,'AbsTol',10^(-12));
%                         catch
%                             IntegYYY{l,j,k}=integral(YYY,-1,1,'AbsTol',10^(-12))*2*pi;
%                         end
%                     end
%         
%                     if IntegYYY{l,j,k}*IntegYYY{l,j,k}<0.000000001
%                         IntegYYY{l,j,k}=0;
%                     end
%         
%                 end
%             end
%         end
        %% %equation 64,S9 Third Term SA Confirmation
        Thirdterm=cell(Mod,1);
        for l=1:Mod
            Thirdterm{l}=0;
            for j=1:Mod
                for k=1:Mod           
                    Thirdterm{l}=Thirdterm{l}+IntegYYY{l,j,k}*P{l,j,k};          
                end
            end
        end
        %% % SA Confirmation! SA Confirmation
        C_1=cell(Mod,1);%equation 76,S10
        C_2=cell(Mod,1);%equation 77,S10
        for l=2:Mod
            C_1{l}=0;
            C_2{l}=0;
            for j=1:Mod
                for k=1:Mod
                     C_1{l}=C_1{l}-IntegYYY{l,j,k}*(D_1_P{l,j,k}+D_1_N{l,j,k});
                     if Omega{l}==0
                        C_2{l}=0;
                     else
                        C_2{l}=C_2{l}-(1/Omega{l})*IntegYYY{l,j,k}*(Omega_P{j,k}*D_2_P{l,j,k}-Omega_N{j,k}*D_2_N{l,j,k});
                     end
                end
            end
        end
        C_1{1}=0;
        C_2{1}=0;
        %% %equation 64,S9 SA Confirmation
        for l=1:Mod
            if l==1
                AA2{l}=0;
                for j=1:Mod
        
                    AA2{l}=AA2{l}+(AA1{j}*AA1{j});
                end
                AA2{l}=AA2{l}*(-1/(sqrt(4*pi)*R0));
            else
                AA2{l}=(1/R0)*(C_1{l}*cos(Omega{l}*t)+C_2{l}*sin(Omega{l}*t)+Thirdterm{l});
            end
        end       
        %% SA Confirmation Zeitableitung Ordnung 2
        AA2dot=cell(Mod,1);
        for l=1:Mod        
            AA2dot{l}=diff(AA2{l},t);
        end
        %%  SA Confirmation Zeitableitung Ordnung 1
        AA1dot=cell(Mod,1);
        for l=1:Mod       
            AA1dot{l}=diff(AA1{l},t);
        end       
        %% SA Confirmation Zeitableitung Ordnung 2 l==0! WICHTIG!
        BB20dot=zeros(1,1);%equation 57,S8 vielleicht 56
        for j=0:n %k1
            for k =0:n %k2
                for q=-j:j
                    for z=-k:k    
                        BB20dot=BB20dot+IntegYYY{1,j^2+j+q+1,k^2+k+z+1}*(0.5*AA1dot{j^2+j+q+1}*AA1dot{k^2+k+z+1}...
                        -1/(4*R0^2)*(j*(k+1)+k*(k+1))*BB1{j^2+j+q+1}*BB1{k^2+k+z+1}...
                        -2*mu/(rho*R0^3)*AA1{j^2+j+q+1}*AA1{k^2+k+z+1}*(1-j*(j+1)));
                    end
                end
            end
        end
        %% 
        B_Rightterm=cell(Mod,1);%equation 57,S8 // SA 90% Confirmation nicht richtig verstanden
                                % vielleicht 56
        for l=0:n
            for m=-l:l
                B_Rightterm{l^2+l+m+1}=0;      
                for j=0:n
                    for k=0:n
                        for q=-j:j
                            for z=-k:k
                               if k==0
                                    B_Rightterm{l^2+l+m+1}=B_Rightterm{l^2+l+m+1}+IntegYYY{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}/...
                                    R0*AA1{j^2+j+q+1}*AA1dot{k^2+k+z+1}*(-(l+2));
                               else
                                    B_Rightterm{l^2+l+m+1}=B_Rightterm{l^2+l+m+1}+IntegYYY{l^2+l+m+1,j^2+j+q+1,k^2+k+z+1}/...
                                    R0*AA1{j^2+j+q+1}*AA1dot{k^2+k+z+1}*(-(l+2)+1/k*(-j*(j+1)+k*(k+1)+l*(l+1)));
                               end
                            end
                        end
                    end
                end
                if l==0
                    BB2{l^2+l+m+1}=int(BB20dot); %% SA Wieso hier das Integral?  -> Antwort: ZeitIntegral!
                else
                    BB2{l^2+l+m+1}=(AA2dot{l^2+l+m+1}-B_Rightterm{l^2+l+m+1})*R0/l; %%%%%% WIESO STEHT HIER EIN AA2 dot?! Antwort: Gleichung 56
                end
            end
        end
        %%      Storage for Coefficients!
        StorageNameAB = '..\..\Post_Processing\Data\Coef_Storage\';
        for l=1:Mod%A
            filename_A_order_1=[StorageNameAB,num2str(Modal),'_',num2str(Amplitude),'_a_order1_',num2str(l),'.txt'];
            diary(filename_A_order_1)
            AA1{l}*epsilon2
            diary off
            filename_A_order_2=[StorageNameAB,num2str(Modal),'_',num2str(Amplitude),'_a_order2_',num2str(l),'.txt'];
            diary(filename_A_order_2)
            AA2{l}*epsilon2^2
            diary off
        end
   
        for l=1:Mod%B
            filename_B_order_1=[StorageNameAB,num2str(Modal),'_',num2str(Amplitude),'_b_order1_',num2str(l),'.txt'];
            diary(filename_B_order_1)
            BB1{l}*epsilon1
            diary off
            filename_B_order_2=[StorageNameAB,num2str(Modal),'_',num2str(Amplitude),'_b_order2_',num2str(l),'.txt'];
            diary(filename_B_order_2)
            BB2{l}*epsilon1^2
            diary off
        end
        %% 
        StorageNameq_r_dot = '..\..\Post_Processing\Data\q_R_dot\';
        R=R0;
        for l=1:Mod
            R=R+(AA1{l}*epsilon2+AA2{l} *epsilon2^2)*YLM{l};
        end
        
        filename_AR=[StorageNameq_r_dot,num2str(Modal),'_',num2str(Amplitude),'R','.txt'];
        diary(filename_AR)
            R
        diary off
        
        Rdot  = diff(R,t);
        filename_ARdot=[StorageNameq_r_dot,num2str(Modal),'_',num2str(Amplitude),'Rdot','.txt'];
        diary(filename_ARdot)
            Rdot
        diary off
        %% 
        q=q0;
        for l=1:Mod
            q=q+(BB1{l}*epsilon1+BB2{l}*epsilon1^2)*YLM{l};

        end

        filename_Aq=[StorageNameq_r_dot,num2str(Modal),'_',num2str(Amplitude),'q','.txt'];
        diary(filename_Aq)
            q
        diary off

        qdot  = diff(q,t);

        filename_Aqdot=[StorageNameq_r_dot,num2str(Modal),'_',num2str(Amplitude),'qdot','.txt'];
        diary(filename_Aqdot)
            qdot
        diary off
    end
end