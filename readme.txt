The codes in this folder are described below. The main code is transition.m, which calls the other ones.

- Steady state code (maybe steadystate.m?): This piece of code should solve for the steady state equilibrium. It iterates in the following way: 
1) Guess an initial interest rate and solve for the corresponding K/L and w from firm's problem. 
2) Given the sequences (constant in steady state) of interest rates and wages from previous step, call individual.m code to solve for household's problem
and then compute aggregate consumption (C) and aggregate capital supply (Ks).
3) Check if markets clear. If they don't, go back to step 1 and iterate on the guess for r accordingly until convergence. 

- individual.m (maybe rename to household.m?) solves household's problem (individual's problem) given preference parameters, lifetime and a sequence of interest rates and wages. The 
output is a sequence of consumption and saving decisions. Uses assets.m to solve the corresponding Euler equations in terms of saving decisions. Then, 
this code computes saving decisions. This code is called by the code that solves for the steady state and also by the code that solves for the transition
to the steady state, feeding this households with the corresponding guesses for sequences of interest rates and wages corresponding with their lifetime.

- assets.m solves the asset accumulation for a household given preference parameters, lifetime and a sequence of interest rates and wages. The code is designed in
a way such that for any given lenght of life, it writes the corresponding system of non-linear Euler equations and solves it.

- Transition to Steady state code (maybe transition.m?): given economy parameters and initial and final TFP, it calls steadystate.m to solve for initial and final 
steady states and then creates panel of consumption and saving decisions by cohort along the transition, iterating in the following way:
1) Guess an initial sequence of interest rates along the transition and solve for the corresponding sequences of K/L and w from firm's problem. 
2) Given the sequences of interest rates and wages obtained from previous step, call individual.m code to solve for each cohort's household's problem
and then compute aggregate consumption (C) and aggregate capital supply (Ks) for each period of the transition.
3) Check if markets clear for each period. If they don't, go back to step 1 and iterate on the guess for the sequence of r accordingly until convergence. 
