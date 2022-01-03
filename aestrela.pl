% Algoritmo AEstrela para 2ª fase do projeto de Inteligência Artificial 2021/22
% 2022/01/01

% Style Check

:- style_check(-discontiguous).
:- style_check(-singleton).

% Includes

:- include('morada.pl').
:- include('aresta.pl').

% Código

inicio(1).

resolveAEstrela(Caminho/Custo) :-
    inicio(Nodo),
    aresta(Nodo, _, _),
    aestrela([[Nodo]/0/Capacidade], CaminhoInverso/Custo/_),
    inverso(CaminhoInverso, Caminho).

aestrela(Caminhos, Caminho) :-
	obtem_melhor(Caminhos, Caminho),
	Caminho = [Nodo|_]/_/_,
    fim(Nodo).

aestrela(Caminhos, SolucaoCaminho) :-
    obtem_melhor(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
    expandeAEstrela(MelhorCaminho, ExpCaminhos),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    aestrela(NovoCaminhos, SolucaoCaminho).

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
    aresta(Nodo, ProxNodo, PassoCusto,Estimativa),
    nao(member(ProxNodo, Caminho)),
	NovoCusto is Custo + PassoCusto,
    Est = Estimativa.

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).