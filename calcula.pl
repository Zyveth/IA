% Calcula tempos para 2ª fase do projeto de Inteligência Artificial 2021/22
% 2022/01/01

% Style Check

:- style_check(-discontiguous).
:- style_check(-singleton).

% Includes

:- include('dfs_bfs_bilp.pl').
:- include('Cliente.pl').
:- include('Encomenda.pl').
:- include('aestrela.pl').
:- include('gulosa.pl').

% Dfs

calculaTempo("dfs", Encomendas, "Carro", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 100,
    calculaParagens(Encomendas,Rota),
    dfs(1,Rota,Caminho/Custo),
    Velocidade is 25 - (0.1*Peso),
    Tempo is Custo/Velocidade.

calculaTempo("dfs", Encomendas, "Mota", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 20,
    calculaParagens(Encomendas,Rota),
    dfs(1,Rota,Caminho/Custo),
    Velocidade is 35 - (0.5*Peso),
    Tempo is Custo/Velocidade.

calculaTempo("dfs", Encomendas, "Bicicleta", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 5,
    calculaParagens(Encomendas,Rota),
    dfs(1,Rota,Caminho/Custo),
    Velocidade is 10 - (0.7*Peso),
    Tempo is Custo/Velocidade.

%Bfs

calculaTempo("bfs", Encomendas, "Carro", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 100,
    calculaParagens(Encomendas,Rota),
    bfs(1,Rota,Caminho/Custo),
    Velocidade is 25 - (0.1*Peso),
    Tempo is Custo/Velocidade.

calculaTempo("bfs", Encomendas, "Mota", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 20,
    calculaParagens(Encomendas,Rota),
    bfs(1,Rota,Caminho/Custo),
    Velocidade is 35 - (0.5*Peso),
    Tempo is Custo/Velocidade.

calculaTempo("bfs", Encomendas, "Bicicleta", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 5,
    calculaParagens(Encomendas,Rota),
    bfs(1,Rota,Caminho/Custo),
    Velocidade is 10 - (0.7*Peso),
    Tempo is Custo/Velocidade.
    
% AEstrela

calculaTempo("aestrela", Encomendas, "Carro", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 100,
    calculaParagens(Encomendas,Rota),
    aestrela(1,Rota,Caminho/Custo),
    Velocidade is 25 - (0.1*Peso),
    Tempo is Custo/Velocidade.

calculaTempo("aestrela", Encomendas, "Mota", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 20,
    calculaParagens(Encomendas,Rota),
    aestrela(1,Rota,Caminho/Custo),
    Velocidade is 35 - (0.5*Peso),
    Tempo is Custo/Velocidade.

calculaTempo("aestrela", Encomendas, "Bicicleta", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 5,
    calculaParagens(Encomendas,Rota),
    aestrela(1,Rota,Caminho/Custo),
    Velocidade is 10 - (0.7*Peso),
    Tempo is Custo/Velocidade.

% Gulosa

calculaTempo("gulosa", Encomendas, "Carro", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 100,
    calculaParagens(Encomendas,Rota),
    gulosa(1,Rota,Caminho/Custo),
    Velocidade is 25 - (0.1*Peso),
    Tempo is Custo/Velocidade.

calculaTempo("gulosa", Encomendas, "Mota", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 20,
    calculaParagens(Encomendas,Rota),
    gulosa(1,Rota,Caminho/Custo),
    Velocidade is 35 - (0.5*Peso),
    Tempo is Custo/Velocidade.

calculaTempo("gulosa", Encomendas, "Bicicleta", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 5,
    calculaParagens(Encomendas,Rota),
    gulosa(1,Rota,Caminho/Custo),
    Velocidade is 10 - (0.7*Peso),
    Tempo is Custo/Velocidade.



calculaParagens([Encomenda], Rota):-
    encomenda(Encomenda, IDCliente, _, _, _, _, _, _),
    cliente(IDCliente,Morada,_),
    Rota = [Morada].

calculaParagens([H|T], Rota):-
    calculaParagens(T,Rota1),
    calculaParagens([H],Rota2),
    append(Rota1,Rota2,Rota).

calculaPesoTotal([Encomenda], Peso):-
    encomenda(Encomenda, _, Peso, _, _, _, _, _).
calculaPesoTotal([H|T], Peso) :-
    calculaPesoTotal(T,Peso1),
    calculaPesoTotal([H],Peso2),
    Peso is Peso1 + Peso2.