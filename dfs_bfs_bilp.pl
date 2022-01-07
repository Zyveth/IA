:- include('morada.pl').
:- include('aresta.pl').

origem(1).

permutation([], []).
permutation([X], [X]) :- !.
permutation([T|H], X) :- 
    permutation(H, H1), 
    append(L1, L2, H1), 
    append(L1, [T], X1), 
    append(X1, L2, X).

%%%%%%%%%%%%%%%%%%%%%
%DFS
%%%%%%%%%%%%%%%%%%%%%

resolveDFS(Destino,Custo,Caminho):-
    origem(Origem),
    dfsAux(Origem,Destino,[Origem],0,Custo,Caminho).

resolveDFS(Origem,Destino,Custo,Caminho):-
    dfsAux(Origem,Destino,[Origem],0,Custo,Caminho).

%condicao paragem qd vertice atual e destino sao iguais.
dfsAux(Destino,Destino,[H|T],CI,Custo,Caminho):-
    reverse([H|T],Caminho),
    Custo is CI.

dfsAux(Actual,Destino,LA,CI,Custo,Caminho):-
    aresta(Actual,X,C), %testar ligacao entre vertice actual e um qualquer X
    \+ member(X,LA), %testar nao circularidade p/evitar vertices ja visitados
    C1 is CI+C,
    dfsAux(X,Destino,[X|LA],C1,Custo,Caminho). %chamada recursiva

%%%%%%%%%%%%%%%%%%%%%
%BFS
%%%%%%%%%%%%%%%%%%%%%

resolveBFS(Destino,Custo,Caminho):-
    origem(Origem),
    bfsAux(Destino,[([Origem],0)],Custo,Caminho).

resolveBFS(Origem,Destino,Custo,Caminho):-
    bfsAux(Destino,[([Origem],0)],Custo,Caminho).

%condicao paragem: qd destino = vertice à cabeça do caminho actual. Basta inverter caminho
bfsAux(Destino,[([Destino|T],C)|_],Custo,Caminho):-
    reverse([Destino|T],Caminho),
    Custo is C.

bfsAux(Destino,[([Actual|T],CA)|Outros],Custo,Caminho):-
    findall(([X,Actual|T],C),(Destino\==Actual,aresta(Actual,X,CustoE),\+ member(X,[Actual|T]),C is CA + CustoE),Novos), % calcular todos os vertices adjacentes não visitados e gerar um caminho novo c/ cada vertice e caminho actual
    append(Outros,Novos,Todos), %caminhos novos são colocados no final da lista
    bfsAux(Destino,Todos,Custo,Caminho). %chamada recursiva

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Busca Iterativa Limitada em Profundidade  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

resolveBILP(Origem,Destino, Max, Solucao) :- 
    caminho(Origem, Destino, Solucao),
    length(Solucao, Comp),
    ( (Comp =< Max) ; (Comp > Max), !, fail).

caminho(Nodo, Nodo, [Nodo]).
caminho(Primeiro, Ultimo, [Ultimo|Caminho]) :- 
    caminho(Primeiro, Penultimo, Caminho),
    ligacao(Penultimo, Ultimo),
    not(member(Ultimo, Caminho)).

