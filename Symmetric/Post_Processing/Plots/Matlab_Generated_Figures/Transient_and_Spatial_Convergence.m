figure 
subplot(1,2,1)
Spartial_Convergence_Combined_fig
subplot(1,2,2)
Transient_Convergence_Combined_fig
x0=0;  
y0=0;
width=1300;
height=400;
set(gcf,'position',[x0,y0,width,height])
cd '..\..\Plots\Code'
s0 = '..\Figures\';
s1 = 'Convergence_';

s = strcat(s0,s1,s2,TimeSteppScheme,'_',s3);
print2eps(s,gcf())