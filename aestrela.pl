% Algoritmo AEstrela para 2ª fase do projeto de Inteligência Artificial 2021/22
% 2022/01/01

% Style Check

:- style_check(-discontiguous).
:- style_check(-singleton).

% Includes

:- include('morada.pl').
:- include('aresta.pl').

% Código

aestrela(Inicio,Nodos,Caminho/Custo) :-
    findall(Permutacao,permutation(Nodos,Permutacao),Possiveis),
    aestrela_multipla_aux2(Inicio,Possiveis,Caminho/Custo).
    
aestrela_multipla_aux2(Inicio,[Nodos],Caminho/Custo) :-
    aestrela_multipla_aux(Inicio,Nodos,Caminho/Custo),
    !.

aestrela_multipla_aux2(Inicio,[Nodos1,Nodos2 |Permutacoes],Caminho/Custo) :-
    aestrela_multipla_aux(Inicio , Nodos1, Caminho1/Custo1),
    aestrela_multipla_aux(Inicio , Nodos2, Caminho2/Custo2),
    Custo1 =< Custo2,
    aestrela_multipla_aux2(Inicio,[Nodos1|Permutacoes],Caminho/Custo),
    !.

aestrela_multipla_aux2(Inicio,[Nodos1,Nodos2 |Permutacoes],Caminho/Custo) :-
    aestrela_multipla_aux(Inicio , Nodos1, Caminho1/Custo1),
    aestrela_multipla_aux(Inicio , Nodos2, Caminho2/Custo2),
    Custo2 =< Custo1,
    aestrela_multipla_aux2(Inicio,[Nodos2|Permutacoes],Caminho/Custo).

permutation([], []).
permutation([X], [X]) :- !.
permutation([T|H], X) :- 
    permutation(H, H1), 
    append(L1, L2, H1), 
    append(L1, [T], X1), 
    append(X1, L2, X).

aestrela_multipla_aux(Inicio,[],[]/0) :- !.

aestrela_multipla_aux(Inicio,[Nodo|Nodos],Caminho/Custo) :-
    resolveAEstrela(Inicio,Nodo,Caminho1/Custo1),
    !,
    aestrela_multipla_aux(Nodo,Nodos,Caminho2/Custo2),
    last([Nodo|Nodos],Last),
    resolveAEstrela(Last,Inicio,Caminho3/Custo3),
    !,
    removehead(Caminho3,Caminho4),
    append(Caminho1,Caminho6,Caminho5),
    append(Caminho5,Caminho4,Caminho),
    Custo is Custo1 + Custo2 + Custo3.

removehead([_|Tail], Tail).

resolveAEstrela(Inicio,Fim,Caminho/Custo) :-
    aestrela_aux(Fim,[[Inicio]/0/Capacidade], CaminhoInverso/Custo/_),
    reverse(CaminhoInverso, Caminho),
    !.

aestrela_aux(Fim,Caminhos, Caminho) :-
	obtem_melhor(Caminhos, Caminho),
	Caminho = [Fim|_]/_/_.

aestrela_aux(Fim,Caminhos, SolucaoCaminho) :-
    obtem_melhor(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
    expandeAEstrela(MelhorCaminho, ExpCaminhos),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela_aux(Fim,NovoCaminhos, SolucaoCaminho).

obtem_melhor([Caminho], Caminho) :- !.

obtem_melhor([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Custo1 + Est1 =< Custo2 + Est2, !,
	obtem_melhor([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
	
obtem_melhor([_|Caminhos], MelhorCaminho) :- 
	obtem_melhor(Caminhos, MelhorCaminho).
    
expandeAEstrela(Caminho, ExpCaminhos) :-
    findall(NovoCaminho, adjacenteG(Caminho,NovoCaminho), ExpCaminhos).

seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).

adjacenteG([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
    aresta(Nodo, ProxNodo, PassoCusto),
    nao(member(ProxNodo, Caminho)),
	NovoCusto is Custo + PassoCusto,
    estimativa(ProxNodo,Est).

estimativa(Nodo,Est) :-
    morada(Nodo,_,Estimativa),
    Est = Estimativa.

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).