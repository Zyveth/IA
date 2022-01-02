:- include('morada.pl').
:- include('aresta.pl').

ligacao(A,B) :- aresta(A,B,_);aresta(B,A,_).

%%%%%%%%%%%%%%%%%%%%%
%DFS
%%%%%%%%%%%%%%%%%%%%%

dfs(Origem,Destino,Caminho):-
    dfsAux(Origem,Destino,[Origem],Caminho).

%condicao paragem qd vertice atual e destino sao iguais. Basta inverter caminho #TODO isto é só caminho de ida
dfsAux(Destino,Destino,LA,Caminho):-
    reverse(LA,Caminho).

dfsAux(Actual,Destino,LA,Caminho):-
    ligacao(Actual,X), %testar ligacao entre vertice actual e um qualquer X
    \+ member(X,LA), %testar nao circularidade p/evitar vertices ja visitados
    dfsAux(X,Destino,[X|LA],Caminho). %chamada recursiva

%%%%%%%%%%%%%%%%%%%%%
%BFS
%%%%%%%%%%%%%%%%%%%%%

bfs(Origem,Destino,Caminho):-
    bfsAux(Destino,[[Origem]],Caminho).

%condicao paragem: qd destino = vertice à cabeça do caminho actual. Basta inverter caminho
bfsAux(Destino,[[Destino|T]|_],Caminho):-
    reverse([Destino|T],Caminho).

bfsAux(Destino,[LA|Outros],Caminho):-
    LA=[Actual|_],
    findall([X|LA],(Destino\==Actual,ligacao(Actual,X),\+ member(X,LA)),Novos), % calcular todos os vertices adjacentes não visitados e gerar um caminho novo c/ cada vertice e caminho actual
    append(Outros,Novos,Todos), %caminhos novos são colocados no final da lista
    bfsAux(Destino,Todos,Caminho). %chamada recursiva
