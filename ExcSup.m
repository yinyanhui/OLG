% Econ 5121 - Advance Quant
% Final Project
% Matias Marzani - Giovanni Aiello - November 2017

% This function computes the excess supply of capital for a given interest
% rate and set of economy parameters. It's used in steadystate.m to get the r that clears
% the market

function [out] = ExcSup(r0,beta,gamma,alpha,z,delta,J)

kd = ((r0+delta)/(alpha*z))^(1/(alpha-1)); % K/L
w = (1-alpha)*z*kd^alpha;

rr = r0*ones(J,1); % (constant) sequence of interest rates faced by households
ww = w*ones(J,1); %  (constant) sequence of wages faced by households

% Households problem
x=fsolve(@(x) assets(x,rr,ww,0,beta,gamma,J),0.1*ones(J-1,1)); 

aa = [x',0]'; % asset holdings

A=sum(aa); % Aggregate capital supply (sum across cohorts)

ks=A/J;

out=ks-kd;

end