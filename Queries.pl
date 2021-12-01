%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Inteligência Artificial - LEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Trabalho Prático. 
% Queries relacionadas com as Funcionalidades Pretendidas.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Includes necessários para o funcionamento das Queries :

:-style_check(-discontiguous).
:-style_check(-singleton).

:-use_module(library(lists)).

:- include('Cliente.pl').
:- include('Encomenda.pl').
:- include('Entrega.pl').
:- include('Estafeta.pl').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 1 - Identificar o Estafeta que utilizou mais vezes um Meio de Transporte mais Ecológico.

estafetaMaisEcologico(Entregas,Estafeta):-accMax(Estafetas,Estafeta,Max), getBicicletas([Estafeta|Estafetas]).

accMax([H|T],A,Max):- H > A, accMax(T,H,Max).
accMax([H|T],A,Max):- H <= A, accMax(T,A,Max).
accMax([],A,A).

getBicicletas(Estafetas) :- findall(IdEstafeta,(entrega(IdEstafeta, _, _, _, "Bicicleta"),Estafetas)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 2 - Identificar que Estafetas entregaram determinadas encomendas a um determinado Cliente.

estafetasParaCliente(IdEncomenda, IdEstafeta) :- 
    entrega(IdEstafeta, _, IdEncomenda, _, _).

estafetasParaCliente2(Cliente, Estafetas) :-
    findall(Estafeta,(entrega(Estafeta, _, IdEncomenda, _, _),encomenda(IdEncomenda, Cliente, _, _, _, _, _, _)),Estafetas).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 3 - Identificar os Clientes servidos por um determinado Estafeta.

clientesServidosEstafeta(Estafeta,Clientes) :-
    findall(IdCliente,(entrega(Estafeta, _, IdEncomenda, _, _),encomenda(IdEncomenda, IdCliente, _, _, _, _, _, _)),Clientes).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 4 - Calcular o Valor Faturado pela Green Distribution num determinado dia.


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 5 - Identificar quais as zonas (e.g., rua ou freguesia) com maior Volume de Entregas por parte da Green Distribution.

ruasTodasEntregas(Ruas) :-
    findall(Morada,(cliente(IdCliente, Morada, _),encomenda(IdEncomenda, IdCliente, _, _, _, _, _, _),entrega(_, _, IdEncomenda, _, _)),Ruas).

freguesiasTodasEntregas(Freguesias) :-
    findall(Freguesia,(cliente(IdCliente, _, Freguesia),encomenda(IdEncomenda, IdCliente, _, _, _, _, _, _),entrega(_, _, IdEncomenda, _, _)),Freguesias).

ruaMaisEntregas(RuaMaisEntregas) :-
    ruasTodasEntregas(Ruas),
    sort(Ruas, Uniq),
    findall([Freq, X], (
        member(X, Uniq),
        include(=(X), Ruas, XX),
        length(XX, Freq)
    ), Freqs),
    sort(Freqs, SFreqs),
    last(SFreqs, [Freq, RuaMaisEntregas]).

freguesiaMaisEntregas(FreguesiaMaisEntregas) :-
    freguesiasTodasEntregas(Freguesias),
    sort(Freguesias, Uniq),
    findall([Freq, X], (
        member(X, Uniq),
        include(=(X), Freguesias, XX),
        length(XX, Freq)
    ), Freqs),
    sort(Freqs, SFreqs),
    last(SFreqs, [Freq, FreguesiaMaisEntregas]).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 6 - Calcular a Classificação Média de Satisfação de Cliente para um determinado Estafeta.

classificacoesEstafeta(Estafeta,Classificacoes) :-
    findall(Classificação,entrega(Estafeta,Classificação,_,_,_),Classificacoes).

length2([], 0).
length2([H|T], N) :- length(T, N1), N is N1+1.

sum([],0).
sum([X|List],Sum) :-
    sum(List,Sum1),
    Sum = X + Sum1.

mediaLista(Lista,Media) :-
    length2(Lista,N), sum(Lista,Soma),
    Media is Soma/N.

classificacaoMediaEstafeta(Estafeta,Media) :-
    classificacoesEstafeta(Estafeta,Classificacoes),
    mediaLista(Classificacoes,Media).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 7 - Identificar o Número Total de Entregas pelos diferentes Meios de Transporte, num determinado Intervalo de Tempo.

query7(Initial_Time,Final_Time,"Bicicleta"/X,"Mota"/Y,"Carro"/Z):-
    get_all_filter_time(Initial_Time,Final_Time,Time),
    filter_transports(Time,T),
    count(T,"Bicicleta",X),
    count(T,"Mota",Y),
    count(T,"Carro",Z).

% Predicado que filtra as Entregas guardando os Meios de Transporte Utilizados em cada uma delas.

filter_transports([Entrega],R):-
    get_transport(Entrega,X),
    R = [X].
filter_transports([Entrega|Entregas],R):-
    get_transport(Entrega,X),
    filter_transports(Entregas,Y),
    R = [X|Y].

% Getter Simples para obter o Meio de Transporte utilizado numa Entrega.

get_transport(entrega(_,_,_,_,T),T).

% Getter simples para obter a data na qual uma entrega foi feita.

get_time(X,E):-
    entrega(A,B,C,X,D),
    E = entrega(A,B,C,X,D).

% Predicado que verifica se uma Entrega foi feita no Intervalo de Tempo indicado.

filter_time(Initial_Time,Final_Time,Entrega):-
    get_time(X,Entrega),
    parse_time(Initial_Time,I),
    parse_time(Final_Time,F),
    parse_time(X,Y),
    Y >= I,
    Y <= F.

% Predicado que recolhe em R todas as Entregas feitas durante o Intervalo de Tempo indicado.

get_all_filter_time(Initial_Time,Final_Time,R):-
    findall(Entrega,filter_time(Initial_Time,Final_Time,Entrega),R).

% Predicado que conta quantas vezes um elemento X ocorre numa lista.

count([],X,0).
count([X|T],X,Y):- count(T,X,Z), Y is 1+Z.
count([X1|T],X,Z):- X1\=X,count(T,X,Z).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 8 - Identificar o Número Total de Entregas pelos Estafetas, num determinado Intervalo de Tempo.

query8(Initial_Time,Final_Time,R):-
    get_all_filter_time(Initial_Time,Final_Time,X),
    length(X,R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 9 - Calcular o Número de Encomendas Entregues e não Entregues pela Green Distribution, num determinado Período de Tempo.


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 10 - Calcular o Peso Total transportado por Estafeta num determinado dia.

totalPesoEstafetaDia(Estafeta,D-M-A,TotalPesos) :-
    findall(Peso,(entrega(Estafeta, _,IDencomenda, D-M-A, _),encomenda(IDencomenda,_,Peso,_,_,_,_,_)),ListaPesos),
    sum_list(ListaPesos,TotalPesos).