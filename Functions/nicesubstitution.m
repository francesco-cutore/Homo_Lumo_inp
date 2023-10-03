function iso_list= nicesubstitution(Graph,carbons,p,q,Hexcentres)
carbons=[carbons, (1:size(carbons,1))'];

%% Swap them, half the hassle
if p>q
    tmp = q;
    q = p;
    p = tmp;
end

[~, indice_coord_destra]   = max(Hexcentres(:, 1));
[~, indice_coord_sinistra] = min(Hexcentres(:, 1));
Hex_dx = Hexcentres(indice_coord_destra, :);
Hex_sx = Hexcentres(indice_coord_sinistra, :);
m = (Hex_dx(2) - Hex_sx(2)) / (Hex_dx(1) - Hex_sx(1));
q = Hex_sx(2) - m * Hex_sx(1);


if q == 1


end

if p == q
    down_carbon = min(carbons(:,2));
    top_carbon = max(carbons(:,2));
    center = [0, (down_carbon + top_carbon)/2];
    center = round(center,5);
    idx=carbons(:,1) <= center(1) & carbons(:,2) >= center(2);
    candidate_carbons = carbons(idx,:);
    iso_list=[];
    for i=1:size(candidate_carbons,1)
        candidate_boro = candidate_carbons(i,4);
        for j=1:size(Graph{candidate_boro},2)
            candidate_azoto = Graph{candidate_boro}(j);
            if carbons(candidate_azoto, 2) >= center(2)
                iso_list = [iso_list;[candidate_boro, candidate_azoto]];
            end
        end
    end
else
    [~, indice_coord_destra]   = max(Hexcentres(:, 1));
    [~, indice_coord_sinistra] = min(Hexcentres(:, 1));
    Hex_dx = Hexcentres(indice_coord_destra, :);
    Hex_sx = Hexcentres(indice_coord_sinistra, :);
    m = (Hex_dx(2) - Hex_sx(2)) / (Hex_dx(1) - Hex_sx(1));
    q = Hex_sx(2) - m * Hex_sx(1);
    above_line_mask = carbons(:, 2) > (m * carbons(:, 1) + q);
    candidate_carbons = carbons(above_line_mask, :);
    iso_list=[];
        for i=1:size(candidate_carbons,1)
            candidate_boro = candidate_carbons(i,4);
            for j=1:size(Graph{candidate_boro},2)
                candidate_azoto = Graph{candidate_boro}(j); 
                iso_list = [iso_list;[candidate_boro, candidate_azoto]];                
            end
        end
end
end