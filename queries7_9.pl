:-style_check(-discontiguous).
:-style_check(-singleton).

:- use_module(library(lists)).

%================================
% Query 7 - identificar o número total de entregas pelos diferentes meios de transporte,
% num determinado intervalo de tempo.
%================================

query7(Initial_Time/Final_Time,Entregas,bicicleta/X,moto/Y,carro/Z):-
    filter_by_time(Initial_Time/Final_Time,Entregas,Time),
    filter_transports(Time,T),
    count(T,bicicleta,X),
    count(T,moto,Y),
    count(T,carro,Z).

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

% Predicado que filtra as entregas guardando aquelas que ocurreram durante um intervalo de
% de tempo específico.

filter_by_time(_,[],[]).
filter_by_time(Initial_Time/Final_Time,[Entrega|Entregas],[Entrega|T]):-
    filter_by_time(Initial_Time/Final_Time,Entregas,Y),
    get_time(Entrega,X),
    X >= Initial_Time,
    X =< Final_Time,
    T = Y.
filter_by_time(Initial_Time/Final_Time,[Entrega|Entregas],R):-
    filter_by_time(Initial_Time/Final_Time,Entregas,Y),
    R = Y.

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