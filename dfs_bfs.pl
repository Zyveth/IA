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

%condicao paragem qd vertice atual e destino sao iguais. Basta inverter caminho #TODO isto é só caminho de ida
dfsAux(Destino,Destino,[H|T],Caminho):-
    reverse([H|T],Cam),
    append(Cam,T,Caminho).

dfsAux(Actual,Destino,LA,Caminho):-
    ligacao(Actual,X), %testar ligacao entre vertice actual e um qualquer X
    \+ member(X,LA), %testar nao circularidade p/evitar vertices ja visitados
    dfsAux(X,Destino,[X|LA],Caminho). %chamada recursiva

%%%%%%%%%%%%%%%%%%%%%
%DFS MAIS Q 1 ENTREGA
%%%%%%%%%%%%%%%%%%%%%

dfsV(Destinos,Caminho):-
    origem(Origem),
    dfsVAux(Origem,Destinos,[Origem],Caminho).

% fucking hell
dfsVAux(Destino,[],[H|T],Caminho):-
    reverse([H|T],Cam),
    append(Cam,T,Caminho).
  
%condicao paragem qd vertice atual e destino sao iguais. Basta inverter caminho #TODO isto é só caminho de ida
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
