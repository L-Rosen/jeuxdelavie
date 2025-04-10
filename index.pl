% Récupère l'élément placé a un certain indice dans une liste
element_indice(0,[X|_],X).                          %Cas d'arrêt, on a trouvé l'élément
element_indice(Indice,[_|Queue],Element):-
    Indice1 is Indice - 1,                          %On décrémente l'indice
    element_indice(Indice1,Queue,Element).          %On cherche dans la queue de la liste

%Additionne tous les éléments d'une liste
somme([],0).                                      %Cas d'arrêt, la liste est vide
somme([Tete|Queue],Somme):-
    somme(Queue,Somme1),                           %On ajoute la somme de la queue récursivement
    Somme is Somme1 + Tete.                        %On ajoute la tête de la liste à la somme	


% Récupère la cellule d'une grille à partir de ses indices
cellule(Grille,Ligne,Colonne,Cellule):-
    element_indice(Ligne,Grille,Liste),             %On récupère la ligne sous forme d'une liste
    element_indice(Colonne,Liste,Cellule).          %On récupère la cellule dans la ligne
cellule(_,_,_,0).                                   %Si la ligne ou la colonne est en dehors de la grille, on renvoie 0

%On peux se permettre de mettre 0 car toutes les rêgles du jeux n'impliquent que des voisins vivants
%or lorsqu'on rajoute des 0 dans la liste de voisins le total ne changera pas

%[[0,1,0],[1,1,0],[0,0,1]]
% 0 1 0
% 1 1 0
% 0 0 1
voisins(Grille,Ligne,Colonne,ListeVoisine):-
    LigneHaut is Ligne - 1,                         %On calcule l'indice de la ligne du haut
    LigneBas is Ligne + 1,                          %On calcule l'indice de la ligne du bas
    ColonneGauche is Colonne - 1,                   %On calcule l'indice de la colonne de gauche
    ColonneDroite is Colonne + 1,                   %On calcule l'indice de la colonne de droite

    cellule(Grille,LigneHaut,Colonne,Haut),         %On récupère la cellule du haut
    cellule(Grille,LigneBas,Colonne,Bas),           %On récupère la cellule du bas
    cellule(Grille,Ligne,ColonneGauche,Gauche),     %On récupère la cellule de gauche
    cellule(Grille,Ligne,ColonneDroite,Droite),     %On récupère la cellule de droite

    ListeVoisine = [Haut,Droite,Bas,Gauche].        %On assemble la liste

nb_voisins_vivants(Grille, Ligne, Colonne, Nombre):-
    voisins(Grille,Ligne,Colonne,ListeVoisine),     %On récupère la liste de voisins
    somme(ListeVoisine,Nombre).                     %On somme les voisins vivants