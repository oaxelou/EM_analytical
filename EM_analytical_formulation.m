% EM_analytical_formulation.m
% 
% Author: Olympia Axelou
% Affiliation: University of Thessaly
% 
% Date: 22 Jul 2022

function [lambdas,right_side_matrix, time_elapsed] = EM_analytical_formulation(nx_total,B,u)
% EM_analytical_formulation - Formulation of the time-invariant matrix r
% and calculation of eigenvalues of system matrix A
% 
% Eigenvalue decomposition for the solution of:
% sigmas_deriv = G*sigmas + B*u
%
% Analytical solution:
% sigmas(t) = e^(At)*sigmas(0) + integral(0->t)(e^(A(t-τ))*Bu)dτ
%    |
%    | A = VΛV^(-1), Λ: diagonal matrix containing the eigenvalues of A
%    |               V: matrix containing the eigenvectors of A  
%    |
%    v
% sigmas(t) = V * L * V^(-1) * B * u, where:
% 
%      [ (e^(λ1t)-1)/λ1         ... 0 ]
% L  = [ 0 ...  (e^(λit)-1)/λi  ... 0 ]
%      [ 0      ...    (e^(λnt)-1)/λn ] 
%    |
%    | 
%    v
% sigmas(t) = idct(L * dct(B * u)), with:
% dct being DCT-II and idct being IDCT-II
time_start = tic;

% Compute eigenvalues 
lambdas = 2*cos([0:(nx_total-1)]'*pi/nx_total)-2;

% Perform DCT-II on vector u
r = B*u;
right_side_matrix =  mirt_dctn(r);

time_elapsed = toc(time_start);

end

