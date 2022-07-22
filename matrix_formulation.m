% matrix_formulation.m
% 
% Author: Olympia Axelou
% Affiliation: University of Thessaly
% 
% Date: 22 Jul 2022

function [A_coeff,nx_total,B,u,nodes_per_segment, time_matrix_formulation] = matrix_formulation(dx0,lengths0,J_list_norm0,kappa,b)
% matrix_formulation - Formulate matrices A and B
time_start = tic;

lengths = lengths0;
J_list_norm=J_list_norm0;
dx = dx0;
n_wires = numel(lengths); %number of wire segments in interconnect line

% Total length of line
length = 0;
for segment=1:numel(lengths)
    length = length + lengths(segment);
end

% Total number of discretization nodes on line
nx_total = ceil(length / dx);

% Number of discretization nodes per segment
nodes_per_segment = zeros(numel(lengths),1);
for i=1:numel(lengths)
   nodes_per_segment(i) = ceil(lengths(i)/dx); 
end

% Form matrix B
B = sparse(nx_total, n_wires);
index = 1;
for i = 1:n_wires
    B(index,i)=1;
    B(index+nodes_per_segment(i)-1,i)=-1;
    index = index + nodes_per_segment(i) -1;
end

B_coeff = kappa*b/dx;
B = B * B_coeff;
u = J_list_norm;
   
A_coeff = kappa/(dx*dx);

time_matrix_formulation = toc(time_start);
end
