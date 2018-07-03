% Econ 5121 - Advanced Quantitative Methods in Economics
% Final Project
% Matias Marzani  - November 2017
% False Position Method (quadratic step)

% This function implements the quadratic false position method for root-finding 
% to a given a function equation Fun, whitin an interval "Int".
% The output is a root of Fun.

function root = falseposquad(Fun, Int)
er = 1;  % initialize error
j = 1; 
rootit = zeros(50,1); % I will store the root iterations here (hopefully 50 steps will be more than enough)
flag = 0;
while er > 1e-5 && flag == 0 && j <=500
    x1 = min(Int); % lower bound
    x2 = max(Int); % upper bound
    xh = (x1+x2)/2; % half of interval
    fx1 = feval(Fun,x1); 
    fx2 = feval(Fun,x2); 
    fxh = feval(Fun,xh);
    
    % Change of variables from [x1,x2] to [-1,1] through function phi
    phi = @(t) x1+(1+t)*(x2-x1)/2;   
    % Solve f(t) = 0 where f(t)=c0+c1*t+c2*t^2, f(-1)=fx1, f(0)=fxh & f(1)=fx2
    % Then, f(t) = fxh + 1/2*(fx2-fx1)*t + (-fxh + 1/2*(fx1+fx2))*t^2
    c0 = fxh;
    c1 = (fx2-fx1)/2;
    c2 = (fx1+fx2)/2-fxh;
    troot1 = (-c1+sqrt(c1^2-4*c0*c2))/(2*c2);
    troot2 = (-c1-sqrt(c1^2-4*c0*c2))/(2*c2);
    if troot1 <= 1 && troot1 >= -1
        troot = troot1;
    elseif troot2 <= 1 && troot2 >= -1
        troot = troot2;
    else
        flag = 1;
    end
    
    root = phi(troot); % root after change of variables
    rootit(j+1) = root; 
    er = abs((rootit(j+1) - rootit(j))/rootit(j+1)); % relative error
    froot = feval(Fun,root); % f(root)
    
    % update interval = [x1 x2] depending on the sign of f(root)
    if fx1*froot < 0
        Int = [x1 root]; 
    elseif froot*fx2 < 0
        Int = [root x2]; 
    end
    j = j+1;  
end
if froot>1e-3 || j >= 500
    disp('The algoritm did not converge. Try to guess better. You can do it! ;)')
end
return
