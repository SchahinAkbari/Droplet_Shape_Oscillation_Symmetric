function Harmonics = SphericalHarmonics(L,m)
syms zetaa phii
% Rodriguez Formula for Assoziated Legendre Polynomials (PLm)
h         = (zetaa^2-1)^L; 
h1        = diff(h,zetaa,L+m);
PLm       =((-1)^(m+L))*((1-zetaa^2)^(m/2))*h1/((2^L)*factorial(L)); % (PLm)
% Normalizied PLm
Norm_PLm  = sqrt((2*L+1)*(factorial(L-m))/(2*factorial(L+m)))*PLm;
% Solution of Azimuthequation
if m < 0 
    h         = (zetaa^2-1)^L; 
   h1        = diff(h,zetaa,L+abs(m));
PLm       =((-1)^(abs(m)+L))*((1-zetaa^2)^(abs(m)/2))*h1/((2^L)*factorial(L)); % (PLm)
% Normalizied PLm
Norm_PLm  = sqrt((2*L+1)*(factorial(L-abs(m)))/(2*factorial(L+abs(m))))*PLm;
% Solution of Azimuthequation
    
    Azimuth = (sqrt(2)*sin(abs(m)*phii))/(sqrt(2*pi));
elseif m == 0
    Azimuth   = 1/sqrt(2*pi);
else
    Azimuth = (sqrt(2)*cos(m*phii))/(sqrt(2*pi));
end
Harmonics(zetaa) = Azimuth*Norm_PLm;
end

