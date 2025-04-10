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

%Grille évoluée
%[[1,1,0],[1,1,1],[0,1,0]]
% 1 1 0
% 1 1 1
% 0 1 0

voisins(Grille,Ligne,Colonne,ListeVoisine):-
    LigneHaut is Ligne - 1,                         %On calcule l'indice de la ligne du haut
    LigneBas is Ligne + 1,                          %On calcule l'indice de la ligne du bas
    ColonneGauche is Colonne - 1,                   %On calcule l'indice de la colonne de gauche
    ColonneDroite is Colonne + 1,                   %On calcule l'indice de la colonne de droite

    cellule(Grille,LigneHaut,Colonne,Haut),             %Voisin du dessus
    cellule(Grille,LigneHaut,ColonneGauche,GaucheHaut), %Voisin du haut gauche
    cellule(Grille,LigneHaut,ColonneDroite,DroiteHaut), %Voisin du haut droite

    cellule(Grille,LigneBas,Colonne,Bas),               %On récupère la cellule du bas
    cellule(Grille,LigneBas,ColonneGauche,GaucheBas),   %On récupère la cellule du bas gauche
    cellule(Grille,LigneBas,ColonneDroite,DroiteBas),   %On récupère la cellule du bas droite

    cellule(Grille,Ligne,ColonneGauche,Gauche),         %On récupère la cellule de gauche
    cellule(Grille,Ligne,ColonneDroite,Droite),         %On récupère la cellule de droite

    ListeVoisine = [GaucheHaut,Haut,DroiteHaut,Gauche,Droite,GaucheBas,Bas,DroiteBas]. %On crée la liste de voisins vivants

nb_voisins_vivants(Grille, Ligne, Colonne, Nombre):-
    voisins(Grille,Ligne,Colonne,ListeVoisine),     %On récupère la liste de voisins
    somme(ListeVoisine,Nombre).                     %On somme les voisins vivants


%On vérifie si une cellule vivante survie ou meurt
survie(Grille,Ligne,Colonne,EtatSuivant):-

    cellule(Grille,Ligne,Colonne,1),                  %On récupère la cellule si elle est vivante
    nb_voisins_vivants(Grille,Ligne,Colonne,Nombre),  %On récupère le nombre de voisins vivants

    Nombre >= 2,Nombre =< 3,EtatSuivant = 1.          %On vérifie si la cellule survie                 
%Si la cellule ne survie pas survie donnera false

%On vérifie si une cellule morte nait ou reste morte
naissance(Grille,Ligne,Colonne,EtatSuivant):-

    cellule(Grille,Ligne,Colonne,0),                  %On récupère la cellule si elle est morte
    nb_voisins_vivants(Grille,Ligne,Colonne,Nombre),  %On récupère le nombre de voisins vivants

    Nombre =:= 3,EtatSuivant = 1.                     %On vérifie si la cellule nait
naissance(_,_,_,0).                                   %Si les conditions ne sont pas remplies, la cellule reste morte
%Si la cellule ne respecte pas les conditions a savoir être déja morte ou avoir 3 voisins vivants, EtatSuivant sera 0

%On calcule chacune des règles du jeu de la vie
etat_suivant_cellule(Grille, Ligne, Colonne,EtatSuivant):-
    survie(Grille,Ligne,Colonne,EtatSuivant);       %On vérifie si la cellule survie
    naissance(Grille,Ligne,Colonne,EtatSuivant).    %On vérifie si la cellule nait

% Le point-virgule (`;`) permet de faire un "OU logique" entre les deux règles : 
% - Si `survie/4` réussit (la cellule survit), alors `EtatSuivant` sera mis à 1 (cellule vivante).
% - Si `survie/4` échoue (la cellule ne survit pas ou est déjà morte), on passe à `naissance/4` pour vérifier si la cellule peut naître.
%   Si la cellule est morte et a exactement 3 voisins vivants, alors `EtatSuivant` sera mis à 1 (la cellule naît).
%   Sinon si la cellule est vivante ou bien a plus ou moins de 3 voisins vivants, alors EtatSuivant sera mis à 0.
%   Cela fonctionne car si naissance est testé cela signifie que survie a échoué, donc la cellule est morte.

%On vérifie si une cellule vivante survie ou meurt
survie(Grille,Ligne,Colonne,EtatSuivant):-

    cellule(Grille,Ligne,Colonne,1),                  %On récupère la cellule si elle est vivante
    nb_voisins_vivants(Grille,Ligne,Colonne,Nombre),  %On récupère le nombre de voisins vivants

    Nombre >= 2,Nombre =< 3,EtatSuivant = 1.          %On vérifie si la cellule survie                 
%Si la cellule ne survie pas survie donnera false

%On vérifie si une cellule morte nait ou reste morte
naissance(Grille,Ligne,Colonne,EtatSuivant):-

    cellule(Grille,Ligne,Colonne,0),                  %On récupère la cellule si elle est morte
    nb_voisins_vivants(Grille,Ligne,Colonne,Nombre),  %On récupère le nombre de voisins vivants

    Nombre =:= 3,EtatSuivant = 1.                     %On vérifie si la cellule nait
naissance(_,_,_,0).                                   %Si les conditions ne sont pas remplies, la cellule reste morte
%Si la cellule ne respecte pas les conditions a savoir être déja morte ou avoir 3 voisins vivants, EtatSuivant sera 0

%On calcule chacune des règles du jeu de la vie
etat_suivant_cellule(Grille, Ligne, Colonne,EtatSuivant):-
    survie(Grille,Ligne,Colonne,EtatSuivant);       %On vérifie si la cellule survie
    naissance(Grille,Ligne,Colonne,EtatSuivant).    %On vérifie si la cellule nait

% Le point-virgule (`;`) permet de faire un "OU logique" entre les deux règles : 
% - Si `survie/4` réussit (la cellule survit), alors `EtatSuivant` sera mis à 1 (cellule vivante).
% - Si `survie/4` échoue (la cellule ne survit pas ou est déjà morte), on passe à `naissance/4` pour vérifier si la cellule peut naître.
%   Si la cellule est morte et a exactement 3 voisins vivants, alors `EtatSuivant` sera mis à 1 (la cellule naît).
%   Sinon si la cellule est vivante ou bien a plus ou moins de 3 voisins vivants, alors EtatSuivant sera mis à 0.
%   Cela fonctionne car si naissance est testé cela signifie que survie a échoué, donc la cellule est morte.

% Parcours de la grille ligne par ligne, en commençant par l'indice 0
grille_suivante(Grille, NouvelleGrille):-                               
    grille_suivante(Grille, NouvelleGrille, 0, Grille). 

% Cas d'arrêt : grille vide
grille_suivante([], [], _, _).                                                          

% Cas récursif : parcours ligne par ligne
grille_suivante([Ligne | Reste], [NouvelleLigne | NouvellesRestantes], Indice, GrilleBase) :-   
    ligne_suivante(Ligne, NouvelleLigne, Indice, 0, GrilleBase), 
    IndiceSuivant is Indice + 1,
    grille_suivante(Reste, NouvellesRestantes, IndiceSuivant, GrilleBase).

ligne_suivante(Ligne, NouvelleLigne, IndiceLigne, GrilleBase) :-
    ligne_suivante(Ligne, NouvelleLigne, IndiceLigne, 0, GrilleBase).  % Commence à la colonne 0

ligne_suivante([], [], _, _, _).                                                                       % Cas d'arrêt, la ligne est vide

% Cas récursif : on calcule l'état suivant pour chaque cellule
ligne_suivante([_ | Reste], [EtatSuivant | NouvellesRestantes], IndiceLigne, IndiceColonne, GrilleBase) :-
    etat_suivant_cellule(GrilleBase, IndiceLigne, IndiceColonne, EtatSuivant),  % On calcule l'état suivant
    NouvelleColonne is IndiceColonne + 1,
    ligne_suivante(Reste, NouvellesRestantes, IndiceLigne, NouvelleColonne, GrilleBase).
