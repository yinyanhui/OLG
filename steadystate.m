clc; clear all; close all;
% Econ 5121 - Advance Quant
% Final Project
% Matias Marzani - Giovanni Aiello - November 2017

% This script solves the steady state for an OLG economy with J-lived
% households, no initital assets, no growth in any sense, 1 unit of labor 
% endowment each period. 
% The output consists on the SS aggregate variables, the distribution of
% assets across cohorts and some beautiful plots

% Parameters
J=60;
alpha=0.3;
delta=0.1;
z=1;
beta = .99; 
gamma =4; 

% Solve interest rate
rss = falseposquad(@(x) ExcSup(x,beta,gamma,alpha,z,delta,J),[0,3]);

M=20; %Grid size for plotting market clearing given grid of interest rate
rgrid = linspace(0,2*rss,M); % Grid for interest rates
kd = zeros(M,1);    % grid for K/L demand from firm
ys = zeros(M,1);    % grid for Y/L (supply)
cd = zeros(M,1);    % grid for C/L demand (households)
ks = zeros(M,1);    % grid for K/L supply (households)

for m=1:M
    r0=rgrid(m);

k = ((r0+delta)/(alpha*z))^(1/(alpha-1)); % K/L
w = (1-alpha)*z*k^alpha;

kd(m)=k;
ys(m)=z*k^alpha;

rr = r0*ones(J,1); % (constant) sequence of interest rates faced by households
ww = w*ones(J,1); %  (constant) sequence of wages faced by households

% Households problem
x=fsolve(@(x) assets(x,rr,ww,0,beta,gamma,J),0.1*ones(J-1,1)); 

aa = [x',0]'; % asset holdings

cc = zeros(J,1); % consumption sequence
cc(1)=ww(1)-aa(1);
for j = 2:J-1
    cc(j) = ww(j)+(1+rr(j-1))*aa(j-1)-aa(j); 
end
cc(J) = ww(J)+(1+rr(J-1))*aa(J-1);

A=sum(aa); % Aggregate capital supply (sum across cohorts)
C=sum(cc); % Aggregate consumption (sum across cohorts)

cd(m)=C/J; % Consumption per capita 
ks(m)=A/J; % Capital supply per capita
end

ymdK=ys-delta*ks;
cpdK=cd+delta*ks;

kss = ((rss+delta)/(alpha*z))^(1/(alpha-1)); % K/L
wss = (1-alpha)*z*(kss)^alpha;
yss = z*kss^alpha;

rrss = rss*ones(J,1); % sequence of interest rates
wwss = wss*ones(J,1); % sequence of wages

% Households problem solution at steady state
x=fsolve(@(x) assets(x,rrss,wwss,0,beta,gamma,J),0.1*ones(J-1,1)); 
aass = [x',0]'; % asset holdings

ccss = zeros(J,1); % consumption sequence
ccss(1)=wwss(1)-aass(1);
for j = 2:J-1
    ccss(j) = wwss(j)+(1+rrss(j-1))*aass(j-1)-aass(j); 
end
ccss(J) = wwss(J)+(1+rrss(J-1))*aass(J-1);

css=sum(ccss)/J;

% Plotting
%subplot(2,2,1)
set(gca,'DefaultTextFontSize',18)
plot(rgrid,ks,rgrid,kd,'--','LineWidth',2)
grid
xlabel('Interest rate (r)','FontSize',12)
legend('K/J supply','K/J demand','Location','Best')
title('Capital market clearing at SS')
xlim([0 2*rss])
set(gca,'fontsize',15)

%subplot(2,2,2)
set(gca,'fontsize',18)
plot(rgrid,cd,rgrid,ymdK,'--','LineWidth',2)
grid
xlabel('Interest rate (r)','FontSize',12)
legend('Consumption per capita','Y/J - delta*K/J','Location','Best')
title('Goods market clearing at SS')
xlim([0 2*rss])
set(gca,'fontsize',15)

%subplot(2,2,3)
set(gca,'fontsize',18)
plot(rgrid,cpdK,rgrid,ys,'--','LineWidth',2)
grid
xlabel('Interest rate (r)','FontSize',12)
legend('C/J + delta*K/J','Y','Location','Best')
title('Goods market clearing at SS')
xlim([0 2*rss])
set(gca,'fontsize',15)

%subplot(2,2,4)
set(gca,'fontsize',18)
plot(1:J,cc,0:J,[0;aa],1:J,ww,'--','LineWidth',2)
legend('Consumption Policy at SS','Saving Policy at SS','SS Wage','Location','Best')
grid
xlabel('Age (j)','FontSize',12)
title('Lifetime Policy functions at SS')
set(gca,'fontsize',15)

rass=(1+rss)^(J/60)-1; % annual interest rate


