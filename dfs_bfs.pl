:- include('morada.pl').
:- include('aresta.pl').

origem(1).
ligacao(A,B) :- aresta(A,B,_);aresta(B,A,_).

%%%%%%%%%%%%%%%%%%%%%
%DFS
%%%%%%%%%%%%%%%%%%%%%

dfs(Destino,Caminho):-
    origem(Origem),
    dfsAux(Origem,Destino,[Origem],Caminho).

%condicao paragem qd vertice atual e destino sao iguais. Basta inverter caminho
dfsAux(Destino,Destino,[H|T],Caminho):-
    reverse([H|T],Cam),
    append(Cam,T,Caminho).

dfsAux(Actual,Destino,LA,Caminho):-
    ligacao(Actual,X), %testar ligacao entre vertice actual e um qualquer X
    \+ member(X,LA), %testar nao circularidade p/evitar vertices ja visitados
    dfsAux(X,Destino,[X|LA],Caminho). %chamada recursiva

%%%%%%%%%%%%%%%%%%%%%
%DFS MAIS Q 1 ENTREGA #TODO
%%%%%%%%%%%%%%%%%%%%%

dfsV(Destinos,Caminho):-
    origem(Origem),
    dfsVAux(Origem,Destinos,[Origem],Caminho).

% condicao de paragem qd deixa de haver destinos na lista
dfsVAux(Destino,[],[H|T],Caminho):-
    reverse([H|T],Cam),
    append(Cam,T,Caminho).
  
%condicao paragem qd vertice atual e destino sao iguais. Basta inverter caminho
dfsVAux(Destino,[Destino],[H|T],Caminho):-
    reverse([H|T],Cam),
    append(Cam,T,Caminho).

dfsVAux(Actual,Dest,LA,Caminho):-
    ligacao(Actual,X), %testar ligacao entre vertice actual e um qualquer X
    \+ member(X,LA), %testar nao circularidade p/evitar vertices ja visitados
    delete(Dest, X, Destinos),
    dfsVAux(X,Destinos,[X|LA],Caminho). %chamada recursiva

%%%%%%%%%%%%%%%%%%%%%
%BFS
%%%%%%%%%%%%%%%%%%%%%

bfs(Destino,Caminho):-
    origem(Origem),
    bfsAux(Destino,[[Origem]],Caminho).

%condicao paragem: qd destino = vertice à cabeça do caminho actual. Basta inverter caminho
bfsAux(Destino,[[Destino|T]|_],Caminho):-
    reverse([Destino|T],Cam),
    append(Cam,T,Caminho).

bfsAux(Destino,[LA|Outros],Caminho):-
    LA=[Actual|_],
    findall([X|LA],(Destino\==Actual,ligacao(Actual,X),\+ member(X,LA)),Novos), % calcular todos os vertices adjacentes não visitados e gerar um caminho novo c/ cada vertice e caminho actual
    append(Outros,Novos,Todos), %caminhos novos são colocados no final da lista
    bfsAux(Destino,Todos,Caminho). %chamada recursiva

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
