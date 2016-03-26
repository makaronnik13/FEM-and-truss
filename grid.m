%% creating grid
function [elements, nodes] = grid(num_sect,L,H); 
elements = [];
nodes = [0 0];
for e=1:num_sect+1
    nodes(end+1, 1) = e*L;
    nodes(end, 2) = 0;
end
for e=1:num_sect
    nodes(end+1, 1) = e*L;
    nodes(end, 2) = H;
end
for e=1:num_sect*2+1
    if  e ~= num_sect+2
        elements(end+1, 1) = e;
        elements(end, 2) = e+1;
    end
end
for e=1:num_sect
    if  rem(e, 2) == 1 
        elements(end+1, 1) = e;
        elements(end, 2) = e+2+num_sect;
    end
end
for e=3:num_sect+2
    if  rem(e, 2) == 1 
        elements(end+1, 1) = e;
        elements(end, 2) = e+num_sect;
    end
end
for e=2:num_sect+1
        elements(end+1, 1) = e;
        elements(end, 2) = e+num_sect+1;
end