% Econ 5121 - Advance Quant
% Final Project
% Matias Marzani - Giovanni Aiello - November 2017

% This function solves the lifetime savings for an individual who lives J
% periods, given parameters gamma (CRRA utility), beta (discount factor),
% initial assets a0 and a sequence of interest rates and wages

function G = assets(x,rr,ww,a0,beta,gamma,J)
if J==2 % An agent who lives only 2 periods solves only 1 Euler equation, where we impose initial assets = 0 and 
        % termial saving = 0
    G(1)=   (ww(1)  +  a0              -x(1)  )^(-gamma)  -beta*(1+rr(1))*(ww(2)    +(1+rr(1)  )*x(1)         )^(-gamma);
elseif J==3 % An agent who lives only 3 periods solves 2 Euler equations, where we impose initial assets = 0  in
        % the 1st equation and termial saving = 0 in the 2nd equation
    G(1)=   (ww(1)  +  a0              -x(1)  )^(-gamma)  -beta*(1+rr(1))*(ww(2)    +(1+rr(1)  )*x(1)-x(2)    )^(-gamma);
    G(2)=   (ww(2)  +  (1+rr(2))*x(1)  -x(2)  )^(-gamma)  -beta*(1+rr(2))*(ww(3)    +(1+rr(2)  )*x(2)         )^(-gamma);
else % An agent who lives more than 3 periods solves 3 types of Euler equations, where we impose initial assets = 0  in
     % the 1st equation and termial saving = 0 in the last equation. The middle equations are standard
    G(1)=   (ww(1)  +  a0            -x(1)  )^(-gamma)  -beta*(1+rr(1))*(ww(2)    +(1+rr(1)  )*x(1)-x(2)    )^(-gamma);
    for j=2:J-2
    G(j)=   (ww(j)  +  (1+rr(j))*x(j-1)-x(j)  )^(-gamma)  -beta*(1+rr(j))*(ww(j+1)+(1+rr(j))*x(j)-x(j+1)  )^(-gamma);
    end  
    G(J-1)= (ww(J-1)+(1+rr(J-1))*x(J-2)-x(J-1))^(-gamma)  -beta*(1+rr(J-1))*(ww(J)+(1+rr(J-1))*x(J-1)       )^(-gamma);
end
