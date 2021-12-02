:-style_check(-discontiguous).
:-style_check(-singleton).

:-use_module(library(lists)).

:- include('Cliente.pl').
:- include('Encomenda.pl').
:- include('Entrega.pl').
:- include('Estafeta.pl').

%================================
% Query 7 - identificar o número total de entregas pelos diferentes meios de transporte,
% num determinado intervalo de tempo.
%================================

query7(Initial_Time,Final_Time,"Bicicleta"/X,"Mota"/Y,"Carro"/Z):-
    get_all_filter_time_entrega(Initial_Time,Final_Time,Time),
    filter_transports(Time,T),
    count(T,"Bicicleta",X),
    count(T,"Mota",Y),
    count(T,"Carro",Z).

% Predicado que filtra as entregas guardando os meios de transporte utilizados em cada uma 
% delas.

filter_transports([Entrega],R):-
    get_transport(Entrega,X),
    R = [X].
filter_transports([Entrega|Entregas],R):-
    get_transport(Entrega,X),
    filter_transports(Entregas,Y),
    R = [X|Y].

% Getter simples para obter o meio de transporte utilizado numa entrega.

get_transport(entrega(_,_,_,_,T),T).

% Getter simples para obter a data na qual uma entrega foi feita.

get_time_entrega(X,E):-
    entrega(A,B,C,X,D),
    E = entrega(A,B,C,X,D).

% Predicado que verifica se uma entrega foi feita no intervalo de tempo
% indicado.

filter_time_entrega(Initial_Time,Final_Time,Entrega):-
    get_time_entrega(X,Entrega),
    parse_time(Initial_Time,I),
    parse_time(Final_Time,F),
    parse_time(X,Y),
    Y >= I,
    Y =< F.

% Predicado que recolhe em R todas as entregas feitas durante o intervalo
% de tempo indicado.

get_all_filter_time_entrega(Initial_Time,Final_Time,R):-
    findall(Entrega,filter_time_entrega(Initial_Time,Final_Time,Entrega),R).

% Predicado que conta quantas vezes um elemento X ocorre numa lista.

count([],X,0).
count([X|T],X,Y):- count(T,X,Z), Y is 1+Z.
count([X1|T],X,Z):- X1\=X,count(T,X,Z).

%================================
% Query 8 - identificar o número total de entregas pelos estafetas, num determinado
% intervalo de tempo;
%================================

query8(Initial_Time,Final_Time,R):-
    get_all_filter_time_entrega(Initial_Time,Final_Time,X),
    length(X,R).

%================================
% Query 9 - calcular o número de encomendas entregues e não entregues pela Green
% Distribution, num determinado período de tempo;
%================================

query9(Initial_Time,Final_Time,"Efetuada"/X,"A ser Entregue"/Y,"Entregue"/Z):-
    get_all_filter_time_encomenda(Initial_Time,Final_Time,Time),
    filter_status(Time,T),
    count(T,"Entregue",A),
    count(T,"Efetuada",X),
    count(T,"A ser Entregue",E),
    query7(Initial_Time,Final_Time,"Bicicleta"/B,"Mota"/C,"Carro"/D),
    Z is B+C+D,
    Y is E+(A-Z).
    

% Predicado que recolhe em R todas as encomendas pedidas durante o intervalo
% de tempo indicado.

get_all_filter_time_encomenda(Initial_Time,Final_Time,R):-
    findall(Encomenda,filter_time_encomenda(Initial_Time,Final_Time,Encomenda),R).

% Predicado que verifica se uma encomenda foi pedida no intervalo de tempo
% indicado.

filter_time_encomenda(Initial_Time,Final_Time,Encomenda):-
    get_time_encomenda(X,Encomenda),
    parse_time(Initial_Time,I),
    parse_time(Final_Time,F),
    parse_time(X,Y),
    Y >= I,
    Y =< F.

% Getter simples para obter a data na qual uma encomenda foi pedida.

get_time_encomenda(X,Encomenda):-
    encomenda(A,B,C,D,E,F,X,G),
    Encomenda = encomenda(A,B,C,D,E,F,X,G).

% Predicado que filtra as encomendas guardando o status de cada uma 
% delas.

filter_status([Encomenda],R):-
    get_status(Encomenda,X),
    R = [X].
filter_status([Encomenda|Encomendas],R):-
    get_status(Encomenda,X),
    filter_status(Encomendas,Y),
    R = [X|Y].

% Getter simples para obter o status duma encomenda.

get_status(encomenda(_,_,_,_,S,_,_,_),S).