% Definisco la classe Hexagon che descrive un esagono
classdef Hexagon
    properties
        % Centro dell'esagono in coordinate cartesiane
        center
        % Coordinate cartesiane dei vertici dell'esagono
        points
        % Coordinate esagonali
        coords
        % Valore di ogni vertice (0 = non presente, 1 = presente ma senza H, 2 = C e H associato)
        point_mask
    end
    % Costanti utilizzate nella classe
    properties(Constant)
        % Versori nelle 6 possibili direzioni, primo in basso destra
        cube_direction_vectors = [
            [+1, 0, -1]; [+1, -1, 0]; [0, -1, +1];
            [-1, 0, +1]; [-1, +1, 0]; [0, +1, -1];
            ];
    end

    properties(Constant)
        % Matrice di trasformazione dalle coordinate esagonali alle coordinate cartesiane
        hex_to_pixel_transform = [
            [    3/2   ,    0   ];
            [ sqrt(3)/2, sqrt(3)]
            ];
    end

    methods
        % Costruttore della classe, riceve le coordinate esagonali e il raggio dell'esagono
        function obj = Hexagon(hex_coord, radius)
            if nargin < 2
                radius = 1.4;
            end
            obj.coords = hex_coord;
            obj.center = transpose(radius * obj.hex_to_pixel_transform * transpose(obj.coords(1:2)));
            obj.center(2) = -obj.center(2);
            obj.points = obj.get_hexagon_points(obj.center, radius);
            % Inizialmente tutti i punti sono uguali a 2 (reali)
            obj.point_mask = [2, 2, 2, 2, 2, 2];
        end

        % La funzione prende in input un centro e un raggio e restituisce le coordinate dei vertici di un esagono regolare
        function points = get_hexagon_points(~, center, radius)
            points = zeros(6, 2);
            for i = 1:6
                angle =  pi * (i) / 3;
                x = center(1) + radius * cos(angle);
                y = center(2) + radius * sin(angle);
                points(i,:) = [x, y];
            end
        end
        % La funzione disegna un esagono su una figura fornita come input.
        % Se il parametro "useful" è true, vengono disegnati solo i punti utili, altrimenti vengono disegnati tutti i punti
        function draw(obj, fig, useful)
            figure(fig);
            hold on;
            if useful
                points_to_plot = obj.get_useful_points();
            else
                points_to_plot = obj.points;
            end
            plot([points_to_plot(:, 1); points_to_plot(1, 1)], [points_to_plot(:, 2);points_to_plot(1, 2)], 'k');
            hydrogens = obj.get_hydrogens();
            plot(points_to_plot(:, 1), points_to_plot(:, 2), 'og', 'MarkerFaceColor', 'g');
            plot(obj.center(1), obj.center(2), 'ob', 'MarkerFaceColor', 'b');
            plot(hydrogens(:, 1), hydrogens(:, 2), 'or', 'MarkerFaceColor', 'r');

            axis equal;
            axis off;
        end
        % La funzione restituisce i punti utili di un esagono, ovvero quelli con valore 2 e 1
        function useful_points = get_useful_points (obj)
            useful_points = obj.points(obj.point_mask == 1 | obj.point_mask == 2, :);
        end
        % Questa funzione calcola la distanza tra due esagoni nel cubo
        function distance = get_distance(obj, other)
            % Trova la differenza tra le coordinate dei due esagoni
            tmp = obj.coords - other.coords;
            % Calcola la norma L1 del vettore delle differenze
            n1 = norm (tmp, 1);
            % Divide per 2 perché abbiamo tagliato un cubo
            distance = n1 / 2;
        end
        % Questa funzione restituisce una nuova maschera di punti basata su un altro esagono e un colore
        function new_mask = get_neighbour_mask(obj, other, color)
            % Si trova il versore relativo che collega i due esagoni
            tmp = obj.coords - other.coords;
            % Si trova l'indice del vettore direzione nella matrice dei vettori di direzione del cubo
            [~, row_index] = ismember(tmp, obj.cube_direction_vectors, 'rows');
            row_index = mod(row_index + 1, 6);
            old_mask = obj.point_mask;
            % Trova gli indici da modificare
            indexes = [row_index, row_index+1];
            if row_index == 0
                indexes = [1, 6];
            end
            % Modifica i valori della maschera solo se sono maggiori del valore del colore
            if old_mask(indexes(1)) > color; old_mask(indexes(1)) = color; end
            if old_mask(indexes(2)) > color; old_mask(indexes(2)) = color; end

            new_mask = old_mask;
        end
        % Imposta la maschera di punti
        function obj = set.point_mask(obj, new_point_mask)
            obj.point_mask = new_point_mask;
        end
        % Restituisce i punti che soddisfano la condizione di maschera 2
        function hydrogenated_carbons = get_hydrogenated_carbons(obj)
            hydrogenated_carbons = obj.points(obj.point_mask == 2, :);
        end

        function hydrogens = get_hydrogens(obj)
            distance_from_carbon = 1.1;
            % calcola le coordinate degli atomi di idrogeno adiacenti ai carboni idrogenati
            hydrogenated_points = obj.get_hydrogenated_carbons;
            hydrogens = zeros(size(hydrogenated_points,1), 2);

            for i = 1:size(hydrogenated_points,1)
                hydrogenated_point = hydrogenated_points(i, :);
                dir = hydrogenated_point - obj.center;
                dir = dir / norm(dir);
                hydrogens(i, :)= hydrogenated_point + distance_from_carbon * dir;
            end
        end
        % La funzione restituisce una rappresentazione testuale dell'oggetto, utilizzando le coordinate dei punti utili e degli atomi di idrogeno
        function stringified = to_string(obj, substitution_list)
            carbons = obj.get_useful_points();
            hydrogens = obj.get_hydrogens();
            stringified = strings(length(carbons)+length(hydrogens), 1);
            for i = 1:length(carbons)
                atom_type = "C";
                for j = 1:size(substitution_list, 1)
                    pos = [substitution_list{j, 2} substitution_list{j, 3}];
                    if pdist([pos; carbons(i, 1:2)]) < 0.1
                        atom_type = substitution_list{j, 1};
                    end
                end
                stringified(i) = sprintf('%s %20f %20f %20f', atom_type, carbons(i, 1), carbons(i, 2), rand/10);
            end
            for i = 1:size(hydrogens,1)
                stringified(i+length(carbons)) = sprintf('H %20f %20f %20f', hydrogens(i, 1), hydrogens(i, 2), rand/10);
            end

        end
    end
end
