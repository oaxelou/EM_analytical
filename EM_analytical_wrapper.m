% EM_analytical_wrapper.m
% 
% Author: Olympia Axelou
% Affiliation: University of Thessaly
% 
% Date: 22 Jul 2022

clc;clear;format longg;
addpath('dct')

fprintf('\n - - - EM Analytical - - - \n\n');
%% Script Initializations

% Set time
t = 6.38e8;

% Number of nodes
dx = 1e-6; 

% Inputs 
benchmark = '5-segment';
tree_file = strcat('benchmarks/', benchmark, '/tree_line.txt');
current_densities_file = strcat('benchmarks/', benchmark, '/tree_curden.txt');


% Physical parameters - Cu DD
D0=1.3e-9;              % Diffusivity Constant (m^2/s)
Ea=1.609e-19;           % Activation Energy 
kB=1.3806e-23;          % Boltzmann constant (J/K).
T = 378;                % Temperature (K)
Da=D0*exp(-Ea/(kB*T));  % Diffusion coefficient 
B0=28e9;                % Bulk Modulus for the metal (Pa)
Omega=1.182e-29;        % Atomic Volume foe the metal (m^3)
rho=2.25e-8;            % Electrical Resistivity (Ohm m)
Z=1;                    % Effective Charge Number

kappa=(Da*B0*Omega)/(kB*T);
b = Ea*Z*rho/Omega;

% Flags
plots_flag = true;
plot_curden_flag = true;
plot_visibility = 'on';

%% Input Parsing

[lengths,cur_den] = read_inputs(tree_file, current_densities_file);
clear tree_file current_densities_file;


% Plot current densities
if plots_flag && plot_curden_flag
    n_wires = numel(lengths); %number of wire segments in tree

    x = zeros(size(cur_den,1),1);
    for i = 2:size(cur_den,1)+1
        x(i) = x(i-1) + lengths(i-1);
    end
    
    x1 = zeros(2*size(cur_den,1),1);
    j = 2;
    for i = 2:size(cur_den,1)+1
        if j <= 2*size(cur_den,1)
            if j > 2
                x1(j-1) = x1(j-2);
            end
            x1(j) = x1(j-1) + lengths(i-1);
            j = j + 2;
        end
    end

    f1 = figure('visible', plot_visibility);
    clf(f1);
    hold on;
    curden1 = repelem(cur_den, 2, 1);
    for i = 1:size(curden1,1)/2
       plot(x1(2*i-1:2*i),curden1(2*i-1:2*i), 'b-','LineWidth',3);
       xline(x1(2*i),'--'); 
    end
%     plot(x1,repelem(J_list, 2, 1), 'b*--');
    xlim([x(1) x(size(x,1))]);
    line_str = "Current Density accross the line";
    title_str = sprintf('%s',line_str);

    title_curden_obj = title(title_str);
    set(title_curden_obj,'Interpreter','none')
    f1.Position(1) = 300;
    f1.Position(2) = 250;
    hold off;
    
    clear x x1 curden1
end

%% Form analytical solution

[A_coeff,nx_total,B,u,nodes_per_segment, time_matrix_formulation] = matrix_formulation(dx,lengths,cur_den,kappa,b);
clear cur_den lengths;

fprintf('Starting analytical method formulation...\n');
[lambdas, right_side_matrix, time_formulation] = EM_analytical_formulation(nx_total,B,u);
clear B u;

%% Calculate sigmas at specific time
% This section here can be executed multiple times (for different time points)
% and in parallel without having to run again the EM_analytical_formulation script.

fprintf('Starting analytical method execution...\n');
[sigmas, time_execution] = EM_analytical_stress_calculation(lambdas,A_coeff,right_side_matrix,t);

fprintf('\nnx_total = %d\n', nx_total);
fprintf('#segments = %d\n', size(nodes_per_segment,1));

fprintf('\nAnalytical Formation Time: %.10f\n', time_matrix_formulation+time_formulation);
fprintf('Analytical Execution Time: %.10f\n', time_execution);
fprintf('Analytical Total Time: %.10f\n', time_matrix_formulation+time_formulation+time_execution);

%% Plot stress across the line

if plots_flag
    f2 = figure('visible', plot_visibility);
    x = dx * [0:nx_total-1]';

    hold on;
    plot(x,sigmas, 'b*-');
    xlim([(dx*(nx_total-1))*0 (dx*(nx_total-1))]);

    f2.Position(1) = 865;
    f2.Position(2) = 250;
    hold off;

    title_str = sprintf('%s at %.1d sec',"5-segment line", t);

    title_obj = title(title_str);
    set(title_obj,'Interpreter','none')
end
