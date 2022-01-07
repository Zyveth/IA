:- include('morada.pl').
:- include('aresta.pl').

origem(1).
ligacao(A,B,C) :- aresta(A,B,C);aresta(B,A,C).

%%%%%%%%%%%%%%%%%%%%%
%DFS
%%%%%%%%%%%%%%%%%%%%%

dfs(Destino,Custo,Caminho):-
    origem(Origem),
    dfsAux(Origem,Destino,[Origem],0,Custo,Caminho).

dfs(Origem,Destino,Custo,Caminho):-
    dfsAux(Origem,Destino,[Origem],0,Custo,Caminho).

%condicao paragem qd vertice atual e destino sao iguais. Basta inverter caminho
dfsAux(Destino,Destino,[H|T],CI,Custo,Caminho):-
    reverse([H|T],Cam),
    append(Cam,T,Caminho),
    Custo is CI + CI.


dfsAux(Actual,Destino,LA,CI,Custo,Caminho):-
    aresta(Actual,X,C), %testar ligacao entre vertice actual e um qualquer X
    \+ member(X,LA), %testar nao circularidade p/evitar vertices ja visitados
    C1 is CI+C,
    dfsAux(X,Destino,[X|LA],C1,Custo,Caminho). %chamada recursiva

%%%%%%%%%%%%%%%%%%%%%
%DFS MAIS Q 1 ENTREGA
%%%%%%%%%%%%%%%%%%%%%

dfsV(Destinos,Custo,Caminho):-
    origem(Origem),
    dfsVAux(Origem,Destinos,[Origem],0,Custo,Caminho).

% condicao de paragem qd deixa de haver destinos na lista
dfsVAux(Destino,[],[H|T],CI,Custo,Caminho):-
    reverse([H|T],Cam),
    append(Cam,T,Caminho),
    Custo is CI + CI.


%condicao paragem qd vertice atual e destino sao iguais. Basta inverter caminho
dfsVAux(Destino,[Destino],[H|T],Caminho):-
    reverse([H|T],Cam),
    append(Cam,T,Caminho),
    Custo is CI + CI.


dfsVAux(Actual,Dest,LA,CI,Custo,Caminho):-
    aresta(Actual,X,C), %testar ligacao entre vertice actual e um qualquer X
    \+ member(X,LA), %testar nao circularidade p/evitar vertices ja visitados
    delete(Dest, X, Destinos),
    C1 is CI + C,
    dfsVAux(X,Destinos,[X|LA],C1,Custo,Caminho). %chamada recursiva

%%%%%%%%%%%%%%%%%%%%%
%BFS
%%%%%%%%%%%%%%%%%%%%%

bfs(Destino,Custo,Caminho):-
    origem(Origem),
    bfsAux(Destino,[([Origem],0)],Custo,Caminho).

bfs(Origem,Destino,Custo,Caminho):-
    bfsAux(Destino,[([Origem],0)],Custo,Caminho).

%condicao paragem: qd destino = vertice à cabeça do caminho actual. Basta inverter caminho
bfsAux(Destino,[([Destino|T],C)|_],Custo,Caminho):-
    reverse([Destino|T],Cam),
    append(Cam,T,Caminho),
    Custo is C + C.

bfsAux(Destino,[([Actual|T],CA)|Outros],Custo,Caminho):-
    findall(([X,Actual|T],C),(Destino\==Actual,aresta(Actual,X,CustoE),\+ member(X,[Actual|T]),C is CA + CustoE),Novos), % calcular todos os vertices adjacentes não visitados e gerar um caminho novo c/ cada vertice e caminho actual
    append(Outros,Novos,Todos), %caminhos novos são colocados no final da lista
    bfsAux(Destino,Todos,Custo,Caminho). %chamada recursiva

%%%%%%%%%%%%%%%%%%%%%
%BFS MAIS Q 1 ENTREGA #TODO
%%%%%%%%%%%%%%%%%%%%%

bfsV(Destinos,Caminho):-
    origem(Origem),
    bfsVAux(Destinos,[[Origem]],Caminho).

%fucking hell
bfsVAux([],[[Destino|T]|_],Caminho):-
    reverse([Destino|T],Cam),
    append(Cam,T,Caminho).

%condicao paragem: qd destino = vertice à cabeça do caminho actual. Basta inverter caminho
bfsVAux([Destino],[[Destino|T]|_],Caminho):-
    reverse([Destino|T],Cam),
    append(Cam,T,Caminho).

bfsVAux(Dest,[LA|Outros],Destinos):-
    LA=[Actual|_],
    findall([X|LA],(ligacao(Actual,X),\+ member(X,LA)),Novos), % calcular todos os vertices adjacentes não visitados e gerar um caminho novo c/ cada vertice e caminho actual
    append(Outros,Novos,[[H|_]|_]), %caminhos novos são colocados no final da lista
    delete(Dest,H,AA).%#TODO isto está mal eu n posso apagar destinos 
    bfsVAux(Destinos,Todos,Caminho). %chamada recursiva

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Busca Iterativa Limitada em Profundidade          %TODO falta fazer o caminho total e perceber direito o cut
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bilp(GoalNode, Max, Solution) :- 
    origem(Origin),
    path(Origin, GoalNode, Solution),
    length(Solution, Length),
    ( (Length =< Max) ; (Length > Max), !, fail).

path(Node, Node, [Node]).

path(FirstNode, LastNode, [LastNode|Path]) :- 
    path(FirstNode, OneButLast, Path),
    ligacao(OneButLast, LastNode),
    not(member(LastNode, Path)).
