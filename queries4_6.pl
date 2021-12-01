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

%================================
% Query 6 - calcular a classificação media de satisfação de cliente para um determinado estafeta; 
%================================

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

%================================
% Query 10 - calcular o peso total transportado por estafeta num determinado dia; 
%================================

totalPesoEstafetaDia(Estafeta,D-M-A,TotalPesos) :-
    findall(Peso,(entrega(Estafeta, _,IDencomenda, D-M-A, _),encomenda(IDencomenda,_,Peso,_,_,_,_,_)),ListaPesos),
    sum_list(ListaPesos,TotalPesos).
