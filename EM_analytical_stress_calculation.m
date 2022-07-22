% EM_analytical_stress_calculation.m
% 
% Author: Olympia Axelou
% Affiliation: University of Thessaly
% 
% Date: 22 Jul 2022

function [sigmas, time_elapsed] = EM_analytical_stress_calculation(lambdas,A_coeff,right_side_matrix,t)
% EM_analytical_stress_calculation - Compute matrix L at specific time
% and perform IDCT-II to calculate the final transient stress at t
% 
% Compute matrix L: 
%      [ (e^(λ1t)-1)/λ1         ... 0 ]
% L  = [ 0 ...  (e^(λit)-1)/λi  ... 0 ]
%      [ 0      ...    (e^(λnt)-1)/λn ] 
%    |
%    | 
%    v
% Finally, calculate stress at t:
% sigmas(t) = idct(L * right_side_matrix), where:
% right_side_matrix is the matrix is obtained by EM_analytical_formulation
time_start = tic;

% Form the time-variant matrix L 
% to calculate sigmas at specific time 
L = zeros(size(lambdas,1));
for i=1:size(lambdas,1)
    if(lambdas(i) == 0)
        L(i,i) = t;
    else
        L(i,i) = (exp(A_coeff*lambdas(i)*t)-1)/(A_coeff*lambdas(i));
    end
end

% Finally, apply the IDCT-II and find final solution
sigmas = mirt_idctn(L * right_side_matrix);

time_elapsed = toc(time_start);
end

