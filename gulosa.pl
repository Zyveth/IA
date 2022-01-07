% Algoritmo Greedy para 2ª fase do projeto de Inteligência Artificial 2021/22
% 2022/01/01

% Style Check

:- style_check(-discontiguous).
:- style_check(-singleton).

% Includes

:- include('morada.pl').
:- include('aresta.pl').

% Código

gulosa(Inicio,Nodos,Caminho/Custo) :-
    findall(Permutacao,permutation(Nodos,Permutacao),Possiveis),
    gulosa_multipla_aux2(Inicio,Possiveis,Caminho1/Custo1),
    last(Caminho1,Last),
    resolveGulosa(Last,Inicio,Caminho2/Custo2),
    removehead(Caminho2,Caminho3),
    append(Caminho1,Caminho3,Caminho),
    Custo is Custo1 + Custo2.
    
gulosa_multipla_aux2(Inicio,[Nodos],Caminho/Custo) :-
    gulosa_multipla_aux(Inicio,Nodos,Caminho/Custo),
    !.

gulosa_multipla_aux2(Inicio,[Nodos1,Nodos2 |Permutacoes],Caminho/Custo) :-
    gulosa_multipla_aux(Inicio , Nodos1, Caminho1/Custo1),
    gulosa_multipla_aux(Inicio , Nodos2, Caminho2/Custo2),
    Custo1 =< Custo2,
    gulosa_multipla_aux2(Inicio,[Nodos1|Permutacoes],Caminho/Custo),
    !.

gulosa_multipla_aux2(Inicio,[Nodos1,Nodos2 |Permutacoes],Caminho/Custo) :-
    gulosa_multipla_aux2(Inicio,[Nodos2|Permutacoes],Caminho/Custo).

permutation([], []).
permutation([X], [X]) :- !.
permutation([T|H], X) :- 
    permutation(H, H1), 
    append(L1, L2, H1), 
    append(L1, [T], X1), 
    append(X1, L2, X).

gulosa_multipla_aux(Inicio,[],[]/0) :- !.

gulosa_multipla_aux(Inicio,[Nodo|Nodos],Caminho/Custo) :-
    resolveGulosa(Inicio,Nodo,Caminho1/Custo1),
    !,
    gulosa_multipla_aux(Nodo,Nodos,Caminho2/Custo2),
    removehead(Caminho2,Caminho3),
    append(Caminho1,Caminho3,Caminho),
    Custo is Custo1 + Custo2.

removehead([],[]).
removehead([_|Tail], Tail).

resolveGulosa(Inicio,Fim,Caminho/Custo) :-
    agulosa(Fim,[[Inicio]/0/Est], CaminhoInverso/Custo/_),
    reverse(CaminhoInverso, Caminho),
    !.

agulosa(Fim,Caminhos, Caminho) :-
    obtem_melhor_g(Caminhos, Caminho),
    Caminho = [Fim|_]/_/_.
    
agulosa(Fim,Caminhos, SolucaoCaminho) :-
    obtem_melhor_g(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
    expandeGulosa(MelhorCaminho, ExpCaminhos),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    agulosa(Fim,NovoCaminhos, SolucaoCaminho).

obtem_melhor_g([Caminho], Caminho) :- !.

obtem_melhor_g([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Est1 =< Est2, !,
	obtem_melhor_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).

obtem_melhor_g([_|Caminhos], MelhorCaminho) :- 
	obtem_melhor_g(Caminhos, MelhorCaminho).

expandeGulosa(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacenteG(Caminho,NovoCaminho), ExpCaminhos).

adjacenteG([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
    aresta(Nodo, ProxNodo, PassoCusto),
    nao(member(ProxNodo, Caminho)),
	NovoCusto is Custo + PassoCusto,
    estimativa(ProxNodo,Est).

estimativa(Nodo,Est) :-
    morada(Nodo,_,Estimativa),
    Est = Estimativa.

seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).