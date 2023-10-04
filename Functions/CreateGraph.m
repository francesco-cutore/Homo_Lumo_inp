%% Create the molecular graph using a substitution list
function [graph,all_carbons_sorted] = CreateGraph(hexagons)
    all_carbons = [];
    for i = 1:length(hexagons)        
        hexagon_carbons = [hexagons(i).points hexagons(i).point_mask'];
        all_carbons = [all_carbons; hexagon_carbons];
    end
    
    all_carbons = [all_carbons zeros(size(all_carbons, 1), 1)];
    idx = (all_carbons(:, 3) ~= 0);
    all_carbons = all_carbons(idx, :);
    all_carbons= [all_carbons(:,1:2), all_carbons(:,4)];

    all_carbons=round(all_carbons,5);
    all_carbons_sorted = sortrows(all_carbons,[2, 1],'descend');
    distance = pdist(all_carbons_sorted(:,1:2));
    dist_mat = squareform(distance);
    [near_rows, near_cols] = find(dist_mat >= 1 & dist_mat < 1.42);
    list = [near_rows, near_cols];
    graph=cell(1,size(all_carbons_sorted,1));
    
    for i = 1:size(list, 1)
        graph{list(i, 1)} = [graph{list(i, 1)}, list(i, 2)];  
    end   
end