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

query7(Initial_Time/Final_Time,"Bicicleta"/X,"Moto"/Y,"Carro"/Z):-
    query81(Initial_Time/Final_Time,Time),
    filter_transports(Time,T),
    count(T,"Bicicleta",X),
    count(T,"Moto",Y),
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

get_transport(entrega(_,_,_,_,_,X),X).

% Getter simples para obter a data na qual uma entrega foi feita.

get_time(entrega(_,_,_,_,X,_),X).

% Predicado que conta quantas vezes um elemento X ocorre numa lista.

count([],X,0).
count([X|T],X,Y):- count(T,X,Z), Y is 1+Z.
count([X1|T],X,Z):- X1\=X,count(T,X,Z).

%================================
% Query 8 - identificar o número total de entregas pelos estafetas, num determinado
% intervalo de tempo;
%================================

query8(Initial_Time/Final_Time,Entrega):-
    get_time(Entrega,X),
    X >= Initial_Time,
    X =< Final_Time.
query81(Initial_Time/Final_Time,R):-
    findall(Entrega,query8(Initial_Time/Final_Time,Entrega),R).

%================================
% Query 9 - calcular o número de encomendas entregues e não entregues pela Green
% Distribution, num determinado período de tempo;
%================================