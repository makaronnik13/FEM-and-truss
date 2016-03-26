%% truss evaluation
function [deformedcoordinates, Asq, activeDof, U, displacements] = truss_eval(nodes, elements,scaleFact2,P,Asq,sections,E,max_tension,r,GH,GL)
flag = true;
delta = 0.1;
%delta = 1000;
g = 9.81;
while flag
    %P=P+delta;
    Asq=Asq+delta;
    A=Asq*Asq;
    EA=A*E;
    node_num = size(nodes,1);
    element_num = size(elements,1);
    GDof = 2*node_num;
    xx = nodes(:,1);
    yy = nodes(:,2);
    %% Applied loads
    load = P*g;
    F = zeros(GDof,1);
    for e = 1:node_num/2+1
            F(e*2)= -load;
    end
    
    [forces] = trussForces(node_num, GH, GL, A, r, g);
    for e = 1:size(forces,1)
        F(e*2) = F(e*2)-forces(e);
    end;
    for e = 1:element_num
           
    end
    
    %% calculating stiffness matrix
    stiffness = zeros(GDof);
    element_length_total = zeros(size(elements,1),1);
    for e = 1:element_num
     indice = elements(e,:);
     elementDof = [indice(1)*2-1 indice(1)*2 indice(2)*2-1 indice(2)*2];
     xa = xx(indice(2))-xx(indice(1));
     ya = yy(indice(2))-yy(indice(1));
     element_length = sqrt(xa*xa+ya*ya);
     element_length_total(e) = element_length;
     %rotations
     C = xa/element_length;
     S = ya/element_length;
     % stiffness matrix(local)
     ke = EA/element_length*[C*C C*S -C*C -C*S; C*S S*S -C*S -S*S;...
     -C*C -C*S C*C C*S;-C*S -S*S C*S S*S];
     % stiffness matrix (global)
     stiffness(elementDof,elementDof) = stiffness(elementDof,elementDof)+ke;
    end
    %% Boundary conditions
    prescribedDof = [2 ((sections+1)*2+1)*2-1 ((sections+1)*2+1)*2];
    %% Solution
    activeDof = setdiff(1:GDof,prescribedDof);
    U = stiffness(activeDof,activeDof)\F(activeDof);
    displacements = zeros(GDof,1);
    displacements(activeDof) = U;
    deformedcoordinates = [nodes(:,1)+scaleFact2*...
     displacements(1:2:2*size(nodes,1)-1) nodes(:,2)+...
     scaleFact2*displacements(2:2:2*size(nodes,1))];
    for e = 1:element_num;
     l0 = sqrt((nodes(elements(e,1),1)-nodes(elements(e,2),1))^2+(nodes(elements(e,1),2)-nodes(elements(e,2),2))^2);
     l1 = sqrt((deformedcoordinates(elements(e,1),1)-deformedcoordinates(elements(e,2),1))^2+(deformedcoordinates(elements(e,1),2)-deformedcoordinates(elements(e,2),2))^2);
   h  ep = (l1-l0)/l0;
     Q = ep*E;
     perc = Q/max_tension;
     no_overload = true;
     if (abs(perc)>1) 
         no_overload = false;
         %fprintf(num2str(Asq));
         %fprintf('\n');
     end
    end
    flag = ~no_overload;
    %if and(not(flag),abs(delta)>10)
    %    flag = true;
    %    P=P-delta;
    %    delta = delta*0.1;
    %end
    if and(not(flag),abs(delta)>0.00001)
        flag = true;
        Asq=Asq-delta;
        delta = delta*0.1;
    end
end