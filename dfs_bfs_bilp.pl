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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dfs(Inicio,Nodos,Caminho/Custo) :-
    findall(Permutacao,permutation(Nodos,Permutacao),Possiveis),
    dfs_multipla_aux2(Inicio,Possiveis,Caminho1/Custo1),
    last(Caminho1,Last),
    resolveDFS(Last,Inicio,Custo2,Caminho2),
    removehead(Caminho2,Caminho3),
    append(Caminho1,Caminho3,Caminho),
    Custo is Custo1 + Custo2.
    
dfs_multipla_aux2(Inicio,[Nodos],Caminho/Custo) :-
    dfs_multipla_aux(Inicio,Nodos,Caminho/Custo),
    !.

dfs_multipla_aux2(Inicio,[Nodos1,Nodos2 |Permutacoes],Caminho/Custo) :-
    dfs_multipla_aux(Inicio , Nodos1, Caminho1/Custo1),
    dfs_multipla_aux(Inicio , Nodos2, Caminho2/Custo2),
    Custo1 =< Custo2,
    dfs_multipla_aux2(Inicio,[Nodos1|Permutacoes],Caminho/Custo),
    !.

dfs_multipla_aux2(Inicio,[Nodos1,Nodos2 |Permutacoes],Caminho/Custo) :-
    dfs_multipla_aux2(Inicio,[Nodos2|Permutacoes],Caminho/Custo).

dfs_multipla_aux(Inicio,[],[]/0) :- !.

dfs_multipla_aux(Inicio,[Nodo|Nodos],Caminho/Custo) :-
    resolveDFS(Inicio,Nodo,Custo1,Caminho1),
    !,
    dfs_multipla_aux(Nodo,Nodos,Caminho2/Custo2),
    removehead(Caminho2,Caminho3),
    append(Caminho1,Caminho3,Caminho),
    Custo is Custo1 + Custo2.

removehead([],[]).
removehead([_|Tail], Tail).

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

