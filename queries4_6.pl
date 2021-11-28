:-style_check(-discontiguous).
:-style_check(-singleton).

:-use_module(library(lists)).

:- include('Cliente.pl').
:- include('Encomenda.pl').
:- include('Entrega.pl').
:- include('Estafeta.pl').

%================================
% Query 4 - identificar os clientes servidos por um determinado estafeta;
%================================

clientesServidosEstafeta(Estafeta,Clientes) :-
    findall(IdCliente,(entrega(Estafeta, _, IdEncomenda, _, _),encomenda(IdEncomenda, IdCliente, _, _, _, _, _, _)),Clientes).

%================================
% Query 5 - identificar quais as zonas (e.g., rua ou freguesia) com maior volume de entregas por parte da Green Distribution;
%================================

%Cliente(IdCliente, Morada, Freguesia);
%Encomenda(idEncomenda, idCliente, _, _, _, _, _, _);
%Entrega(_, _, idEncomenda, _, _);                       somar isto e devolver a maior morada e maior freguesia

%================================
% Query 6 - calcular a classificação media de satisfação de cliente para um determinado estafeta; 
%================================

classificacoesEstafeta(Estafeta,Classificacoes) :-
    findall(Classificação,entrega(Estafeta,Classificação,_,_,_),Classificacoes).

length([], 0).
length([H|T], N) :- length(T, N1), N is N1+1.

sum([],0).
sum([X|List],Sum) :-
    sum(List,Sum1),
    Sum = X + Sum1.

mediaLista(Lista,Media) :-
    length(Lista,N), sum(Lista,Soma),
    Media is Soma/N.

classificacaoMediaEstafeta(Estafeta,Media) :-
    classificacoesEstafeta(Estafeta,Classificacoes),
    mediaLista(Classificacoes,Media).


