function iso_list= nicesubstitution(Graph,carbons,p,q,Hexcentres)
carbons=[carbons, (1:size(carbons,1))'];

[~, indice_coord_destra]   = max(Hexcentres(:, 1));
[~, indice_coord_sinistra] = min(Hexcentres(:, 1));
Hex_dx = Hexcentres(indice_coord_destra, :);
Hex_sx = Hexcentres(indice_coord_sinistra, :);
center = (Hex_sx + Hex_dx) / 2;

m_orizzontale = (Hex_dx(2) - Hex_sx(2)) / (Hex_dx(1) - Hex_sx(1));
q_orizzontale = Hex_sx(2) - m_orizzontale * Hex_sx(1);

abve_line_mask = carbons(:, 2) - (m_orizzontale * carbons(:, 1) + q_orizzontale) > -0.01;
%left_line_mask = carbons(:, 1) - (n_verticale   * carbons(:, 2) + k_verticale)   > -0.01;
% left_line_mask = (carbons(:,2)*(Hex_sx(2)-Hex_dx(2))+Hex_sx(2)*Hex_dx(2)-Hex_sx(2)^2)/(Hex_dx(1)-Hex_sx(1))+Hex_sx(1) - carbons(:,1) > -0.01;

if abs(m_orizzontale) < 0.01
    left_line_mask =  carbons(:, 1) < 0.01;
else
    left_line_mask = carbons(:, 2) - (- 1/m_orizzontale * (carbons(:, 1) - center(1)) + center(2)) > -0.01;
end

if p == q || p==1 || q==1
    candidate_carbons = carbons(abve_line_mask & left_line_mask, :);
else
    candidate_carbons = carbons(abve_line_mask, :);
end

iso_list=[];
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
            % if azoto_x - (n_verticale  * azoto_y + k_verticale)   > -0.01
                iso_list = [iso_list;[candidate_boro, candidate_azoto]];
            end
        else
            iso_list = [iso_list;[candidate_boro, candidate_azoto]];
        end
        
    end
end
%x_points = linspace(-2, 4, 100);
%y_points = (- 1/m_orizzontale * (x_points - center(1)) + center(2));
%plot(x_points, y_points);
%hold off
end
% if q == 1
% 
% 
% end
% 
% if p == q
%     down_carbon = min(carbons(:,2));
%     top_carbon = max(carbons(:,2));
%     center = [0, (down_carbon + top_carbon)/2];
%     center = round(center,5);
%     idx=carbons(:,1) <= center(1) & carbons(:,2) >= center(2);
%     candidate_carbons = carbons(idx,:);
%     iso_list=[];
%     for i=1:size(candidate_carbons,1)
%         candidate_boro = candidate_carbons(i,4);
%         for j=1:size(Graph{candidate_boro},2)
%             candidate_azoto = Graph{candidate_boro}(j);
%             if carbons(candidate_azoto, 2) >= center(2)
%                 iso_list = [iso_list;[candidate_boro, candidate_azoto]];
%             end
%         end
%     end
% else
%     [~, indice_coord_destra]   = max(Hexcentres(:, 1));
%     [~, indice_coord_sinistra] = min(Hexcentres(:, 1));
%     Hex_dx = Hexcentres(indice_coord_destra, :);
%     Hex_sx = Hexcentres(indice_coord_sinistra, :);
%     m = (Hex_dx(2) - Hex_sx(2)) / (Hex_dx(1) - Hex_sx(1));
%     q = Hex_sx(2) - m * Hex_sx(1);
%     above_line_mask = carbons(:, 2) > (m * carbons(:, 1) + q);
%     candidate_carbons = carbons(above_line_mask, :);
%     iso_list=[];
%         for i=1:size(candidate_carbons,1)
%             candidate_boro = candidate_carbons(i,4);
%             for j=1:size(Graph{candidate_boro},2)
%                 candidate_azoto = Graph{candidate_boro}(j); 
%                 iso_list = [iso_list;[candidate_boro, candidate_azoto]];                
%             end
%         end
% end
