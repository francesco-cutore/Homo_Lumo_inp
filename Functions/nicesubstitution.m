%% Create the list of carbons that will be substituted with boron and nitrogen
function iso_list= nicesubstitution(Graph,carbons,p,q,Hexcentres)

% Enumerate carbons coordinates 
carbons=[carbons, (1:size(carbons,1))'];

% Find the center of left and right hexagon
[~, indice_coord_destra]   = max(Hexcentres(:, 1));
[~, indice_coord_sinistra] = min(Hexcentres(:, 1));
Hex_dx = Hexcentres(indice_coord_destra, :);
Hex_sx = Hexcentres(indice_coord_sinistra, :);

% Find the center of the molecule
center = (Hex_sx + Hex_dx) / 2;

% Split the molecule in half (This isn't always a simmetry axis)
m_orizzontale = (Hex_dx(2) - Hex_sx(2)) / (Hex_dx(1) - Hex_sx(1));
q_orizzontale = Hex_sx(2) - m_orizzontale * Hex_sx(1);
abve_line_mask = carbons(:, 2) - (m_orizzontale * carbons(:, 1) + q_orizzontale) > -0.01;

% Find in an horribly way the other symmetry axis
if abs(m_orizzontale) < 0.01
    left_line_mask =  carbons(:, 1) < 0.01;
else
    left_line_mask = carbons(:, 2) - (- 1/m_orizzontale * (carbons(:, 1) - center(1)) + center(2)) > -0.01;
end

% Find carbons that are candidate to become borons  
if p == q || p==1 || q==1
    candidate_carbons = carbons(abve_line_mask & left_line_mask, :);
else
    candidate_carbons = carbons(abve_line_mask, :);
end

% For every boron, using the molecular graph, search for carbons to substitute with nitrogen 

iso_list=[]; %% NEED TO PREALLOCATE THIS IN A BETTER WAY
for i=1:size(candidate_carbons,1)
    candidate_boro = candidate_carbons(i,4);
    for j=1:size(Graph{candidate_boro},2)
        candidate_azoto = Graph{candidate_boro}(j);

        if p==q || q == 1
            azoto_x = carbons(candidate_azoto, 1);
            azoto_y = carbons(candidate_azoto, 2);
            if azoto_y - (m_orizzontale * azoto_x + q_orizzontale) > -0.01
                iso_list = [iso_list;[candidate_boro, candidate_azoto]];
            end
        elseif p == 1
            azoto_x = carbons(candidate_azoto, 1);
            azoto_y = carbons(candidate_azoto, 2);
            if azoto_y - (- 1/m_orizzontale * (azoto_x - center(1)) + center(2)) > -0.01
                iso_list = [iso_list;[candidate_boro, candidate_azoto]];
            end
        else
            iso_list = [iso_list;[candidate_boro, candidate_azoto]];
        end
        
    end
end
end
