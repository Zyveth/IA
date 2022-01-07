:- include('dfs_bfs_bilp.pl').
:- include('Cliente.pl').
:- include('Encomenda.pl').


calculaTempo("dfs", Encomendas, "Carro", Caminho/Tempo) :-
    calculaPesoTotal(Encomendas,Peso),
    Peso =< 100,
    calculaParagens(Encomendas,Rota),
    dfs(1,Rota,Caminho/Custo),
    Velocidade is 25 - (0.1*Peso),
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