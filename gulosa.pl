% Algoritmo Greedy para 2ª fase do projeto de Inteligência Artificial 2021/22
% 2022/01/01

% Style Check

:- style_check(-discontiguous).
:- style_check(-singleton).

% Includes

:- include('morada.pl').
:- include('aresta.pl').

% Código

resolveGulosa(Caminho/Custo) :-
    inicio(Nodo),
    aresta(Nodo, _, _,Est),
    agulosa([[Nodo]/0/Est], CaminhoInverso/Custo/_),
    inverso(CaminhoInverso, Caminho).

agulosa(Caminhos, Caminho) :-
    obtem_melhor_g(Caminhos, Caminho),
    Caminho = [Nodo|_]/_/_,
    fim(Nodo).

agulosa(Caminhos, SolucaoCaminho) :-
    obtem_melhor_g(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
    expandeGulosa(MelhorCaminho, ExpCaminhos),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
    agulosa(NovoCaminhos, SolucaoCaminho).

obtem_melhor_g([Caminho], Caminho) :- !.

obtem_melhor_g([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
	Est1 =< Est2, !,
	obtem_melhor_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).

obtem_melhor_g([_|Caminhos], MelhorCaminho) :- 
	obtem_melhor_g(Caminhos, MelhorCaminho).

expandeGulosa(Caminho, ExpCaminhos) :-
	findall(NovoCaminho, adjacenteG(Caminho,NovoCaminho), ExpCaminhos).

adjacenteG([Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
    aresta(Nodo, ProxNodo, PassoCusto, Estimativa),
    nao(member(ProxNodo, Caminho)),
	NovoCusto is Custo + PassoCusto,
    Est = Estimativa.

seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).