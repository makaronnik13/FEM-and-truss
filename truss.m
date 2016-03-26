clear all
clc
format short
%% properties
Asq=0;
K = 2;
N = 45;
H = 2;
L = 3;
E = 210e9;
s = 600e6;
r = 7800;
P=15000;
max_tension = s/K;
%% creating grid
sections = (N-5)/8;
num_sect= sections*2 + 1; 
[elements, nodes] = grid(num_sect,L,H);
element_num = size(elements,1);
node_num = size(nodes,1);
%% Plot construction pic1
subplot(2,1,1)
scaleFact1 = 1e2;
for e=1:element_num
    x=[nodes(elements(e,1),1) nodes(elements(e,2),1)];
    y=[nodes(elements(e,1),2) nodes(elements(e,2),2)];
plot(x,y,'b',10, 4)
text((x(2)+x(1))/2-0.1,(y(2)+y(1))/2,int2str(e),'Color','blue')
hold on
end
for e=1:node_num
    x=nodes(e,1);
    y=nodes(e,2);
plot(x,y,'r.','MarkerSize',20)
text(x,y-0.1,int2str(e),'Color','red')
hold on
end
axis([-1,(num_sect+2)*L,-1,H+1]);
%% calculating minimal sqare
scaleFact2 = 1e2;
%[deformedcoordinates,minA,activeDof, U, displacements] = truss_eval(nodes, elements,scaleFact2,0,0.1,sections,E,max_tension,r,H,L);
[deformedcoordinates,minA,activeDof, U, displacements] = truss_eval(nodes, elements,scaleFact2,P,Asq,sections,E,max_tension,r,H,L);
fprintf('minimal sqare is ');
fprintf(num2str(minA^2));
fprintf('m^2\n');
%% plot construction pic2
cc=jet(200);
subplot(2,1,2)
hold on
caxis([-max_tension max_tension]) 
colormap jet
colorbar
for e = 1:element_num;
 l0 = sqrt((nodes(elements(e,1),1)-nodes(elements(e,2),1))^2+(nodes(elements(e,1),2)-nodes(elements(e,2),2))^2);
 l1 = sqrt((deformedcoordinates(elements(e,1),1)-deformedcoordinates(elements(e,2),1))^2+(deformedcoordinates(elements(e,1),2)-deformedcoordinates(elements(e,2),2))^2);
 ep = l1-l0;
 Q = ep*E;
 perc = Q/max_tension;
 color = round(100*perc)+100;
 if (color>200) 
     color = 200;
 end
 if (color<1) 
     color = 1;
 end
 indice = elements(e,:);
 % undeformed plot
 M = [nodes(elements(e,1),1) nodes(elements(e,1),2);
 nodes(elements(e,2),1) nodes(elements(e,2),2)];
 h1 = plot(M(:,1),M(:,2),'--k');
 h1.Color = [0,0,0,0.4];
 % deformed plot
 N = [deformedcoordinates(elements(e,1),1) deformedcoordinates(elements(e,1),2);
 deformedcoordinates(elements(e,2),1) deformedcoordinates(elements(e,2),2)];
 h2(e) = plot(N(:,1),N(:,2),'red', 'LineWidth',2);
 set(h2(e),'Color',cc(color ,:));
end
axis([-1 (sections+1)*L*2+1 -1 H+1]);
%% knots
plot(nodes(1,1)-0.5,nodes(1,2),'<r','MarkerSize',10);
plot(nodes(1,1)+0.5,nodes(1,2),'>r','MarkerSize',10);
plot(nodes((sections+1)*2+1,1),nodes((sections+1)*2+1,2),'or','MarkerSize',10);
%% forces   
for e = 2:node_num/2;
         text(deformedcoordinates(e,1),deformedcoordinates(e,2)-0.2,'\downarrow','FontSize',20,'Rotation',0,'HorizontalAlignment','center');
     hold on
end

