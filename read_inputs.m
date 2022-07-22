% read_inputs.m
% 
% Author: Olympia Axelou
% Affiliation: University of Thessaly
% 
% Date: 22 Jul 2022

function [lengths0,cur_den0] = read_inputs(tree_file0, current_densities_file0)
% read_inputs - Auxiliary function for input parsing

tree_file = tree_file0;
current_densities_file = current_densities_file0;
%% input wire name, node information, resistance
wires_temp = ''; 
fid = fopen(tree_file);

while ~feof(fid)
   str_temp = fgetl(fid);    
   str_temp = strrep(str_temp, '_', ' ');      
   wires_temp = [wires_temp,str_temp];        
end
segments = textscan(wires_temp,'%s n%s %d %d n%s %d %d %f','CommentStyle','*');     
lengths = segments{8}; % get the lengths of the wires
fclose(fid);
%% get branch # of every tree
segment_num = numel(lengths);           %record branch number of every tree

%% input branch current density
curden_temp = '';
fid = fopen(current_densities_file);

for j = 1:segment_num
    str_temp = fgetl(fid);
    curden_temp = [curden_temp, str_temp];        
end
cur_den = textscan(curden_temp, '%s %s %s %f');
cur_den = cur_den{end};

fclose(fid);

lengths0 = lengths;
cur_den0 = cur_den;
end

