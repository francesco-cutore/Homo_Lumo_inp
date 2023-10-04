clear;clc;close all

%Trova la path corrente per inizializzare i percorsi usati dal programma
current_dir = pwd;
CONSTANTS = constant_intializer(current_dir);

% Importa le funzioni
addpath("Functions/")

% Svuota la cartella inputs 
delete(strcat(CONSTANTS("Output"), "/*.txt"))
deleteAllElementsInFolder(CONSTANTS("Output_Gaussian"))

% Importa le funzioni
addpath("Functions/")

% Richiede l'input dell'utente per le dimensioni del parallelepipedo
p = input('Inserisci la prima dimensione (p) >>');
q = input('Inserisci la seconda dimensione (q) >>');

% Crea una nuova figura
fig = figure();
set(gcf,'color','w');

% Crea una lista di esagoni
hexagons = Hexagon.empty;

% Aggiunge l'esagono centrale
hexagons(1) = Hexagon([0,0,0]);

%Crea le coordinate esagonali in funzione di p e q
coords=inptocoords(p,q);

% Aggiunge gli esagoni alla lista
Hexcentres=zeros(size(coords,1),2);
for i = 1:size(coords, 1)
    coord = coords(i, :);
    new_hexagon = Hexagon(coord);   
    Hexcentres(i,:)=new_hexagon.center;
    hexagons(end+1) = new_hexagon; %#ok<SAGROW>

    % Verifica se gli esagoni sono vicini e rimuove i punti inutili
    for j = 1:i
        if hexagons(i+1).get_distance(hexagons(j)) == 1
            new_mask = hexagons(i+1).get_neighbour_mask(hexagons(j),0);
            hexagons(i+1).point_mask = new_mask;
            neighbour_new_mask = hexagons(j).get_neighbour_mask(hexagons(i+1), 1);     %anche vecchio esagono modifica punti e disabilita colore 1 (carbonio senza idr)
            hexagons(j).point_mask = neighbour_new_mask;

        end
    end
end

% Salva la lista dei centri degli esagoni e aggiunge il primo esagono (di
% centro 0,0)
Hexcentres= [0,0;Hexcentres];

% Crea il grafo molecolare privato degli idrogeni, il grafo è cretato
% mediante una lista (non una matrice) di adiacenza per una maggiore
% efficienza
[Graph,carbons]=CreateGraph(hexagons);

% Trova i carboni candidati ad essere sostituiti con boro o azoto
Candidates = nicesubstitution(Graph,carbons,p,q,Hexcentres);

substitution_list = cell(1, size(Candidates,1));
for i=1:size(Candidates,1)
    substitution_list{i} = cell(2, 3);
    substitution_list{i}{1,1} = "B";                               
    substitution_list{i}{2,1} = "N";
    substitution_list{i}{1,2} = carbons(Candidates(i, 1), 1);
    substitution_list{i}{1,3} = carbons(Candidates(i, 1), 2);
    substitution_list{i}{2,2} = carbons(Candidates(i, 2), 1);
    substitution_list{i}{2,3} = carbons(Candidates(i, 2), 2);
end

% Disegna gli esagoni nella finestra
for i = 1:length(hexagons)
    hexagons(i).draw(fig, false);
end
view(25, 90)

% Ottiene le stringhe degli esagoni
general_name = strcat(CONSTANTS("Output"), "/isomero_%d_%d.txt");

for k = 1:size(Candidates, 1)
    filename = sprintf(general_name, Candidates(k, 1), Candidates(k, 2));
    hexagon_strings = string([]);
    for i = 1:length(hexagons)
        hexagon_strings = cat (1, hexagon_strings, hexagons(i).to_string(substitution_list{k}));
    end
    
    %Rimuove righe vuote 
    hexagon_strings = hexagon_strings(hexagon_strings ~= "" );

    % Scrive le stringhe su un file di testo chiamato "isomero_(B)_(N).txt"
    % Apre il file in modalità scrittura
    fid = fopen(filename, 'w');
    
    % Scrive il numero di stringhe dell'array nella prima riga del file
    fprintf(fid, '%d\n', size(hexagon_strings, 1));
    
    % Riga vuota
    fprintf(fid, '\n');
    
    % Scrive ogni stringa nel file, una per linea
    for i = 1:size(hexagon_strings, 1)
        fprintf(fid, '%s\n', hexagon_strings(i));
    end
    
    % Chiude il file
    fclose(fid);
end

% Crea gli input per Gaussian 
to_Gaussian(CONSTANTS("Output"), CONSTANTS("Output_Gaussian"));

