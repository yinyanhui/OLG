clc; clear all; close all;
% Econ 5121 - Advance Quant
% Final Project
% Matias Marzani - Giovanni Aiello - November 2017

% This script solves the transition to the steady state for an OLG economy 
% with J-lived households, no initital assets, no growth in any sense, 1 unit of labor 
% endowment each period. 
% The output consists on the sequence of aggregate variables, prices and
% asset distribution across cohorts during the transition

% Assume at t=1 there is an earthquake and everyone looses a fraction D of the steady state assets

% Parameters
J=60;
alpha=0.3;
delta=0.1;
z=1;
beta = .99; 
gamma =4;
L=J;
T = 2*J; % time to transition
D =1/2; % fraction of capital that is lost
lambda = 1/2; % convergence weight on updated guess

% Compute SS interest rate, capital per capita and wage
rss = falseposquad(@(x) ExcSup(x,beta,gamma,alpha,z,delta,J),[0,1]);
kss = ((rss+delta)/(alpha*z))^(1/(alpha-1)); % K/L
wss = (1-alpha)*z*kss^alpha;

% Those who where alive before the shock hold a fraction (1-D) of the amount of assets 
% corresponding to the steady state
x0 = fsolve(@(x) assets(x,rss*ones(J,1),wss*ones(J,1),0,beta,gamma,J),0.1*ones(J-1,1)); 
a0 = (1-D)*[x0',0];

% Since supply of capital contracted, we guess the interest rate goes up by
% D% (can guess better?) and then converges to SS value linearly
rr0=zeros(T+J,1);
for t=1:T
    rr0(t)=rss+(T-t)/(T)*D*rss;
end
for t=T+1:T+J
    rr0(t)=rss;
end

rrg=rr0; % store guess to compare with solution

it = 0;
error = 1;
maxit = 100;
tic;
while error > 1e-5 && it <=maxit
it = it+1;

% Given the sequence of interest rates, get firm's wages: increasing, which
% makes sense since MgPL went down and will increase until SS is reached
ww=(1-alpha)*z*((rr0+delta)/(alpha*z)).^(alpha/(alpha-1));     

% Now we create a panel of asset holding decisions for households from t=1 to T
A = zeros(T,J);

% This guys are born after the shock
for t=1:T
    x1 = fsolve(@(x) assets(x,rr0(t:t+J-1),ww(t:t+J-1),0,beta,gamma,J),x0); 
    for j=1:J-1
        if j<=t
            A(t,j)= x1(j);
        end
    end
end

% This guys had age i when hit by the shock
for i = 2:J-1
    x=fsolve(@(x) assets(x,rr0(1:J-(i-1)),ww(1:J-(i-1)),a0(i-1),beta,gamma,J-(i-1)),x0(1:J-(i)));
    for j=(i-1):J-1
        for t=1:J-i
            if j==t+(i-1)
                A(t,j)= x(j-(i-1));
            end
        end
    end
end

K = sum(A,2); % implied sequence of aggregate capital
k = K/L;      % sequence of capital per capita
rr1 = alpha*z*k.^(alpha-1)-delta; % sequence of interest rate implied by firm's FOC

error = norm(rr0(1:T)-rr1(1:T));

% Updated guess of sequence of interest rates
rr0(1:T)=(1-lambda)*rr0(1:T) + lambda*(alpha*z*k.^(alpha-1)-delta);
end
toc;

if it == maxit+1
    disp('Covergence was not achieved in the maximum number of iterations. Try higher maxit or lower error. Or better fix the problem.')
    error
else
    disp('Covergence was achieved in iteration')
    it
end

% Plotting
subplot(2,2,1)
plot(1:T,rr0(1:T),1:T,rrg(1:T),'LineWidth',2)
legend('Equilibrium interst rate', 'Interest rate guess')
grid
xlabel('Time','FontSize',12)
title('Transition to SS: interest rate')
xlim([1 T])


subplot(2,2,2)
plot(1:T,ww(1:T),'LineWidth',2)
grid
xlabel('Time','FontSize',12)
title('Transition to SS: wage')
xlim([1 T])

subplot(2,2,3)
plot(1:T,k(1:T),'LineWidth',2)
grid
xlabel('Time','FontSize',12)
title('Transition to SS: Capital per capita')
xlim([1 T])



            


