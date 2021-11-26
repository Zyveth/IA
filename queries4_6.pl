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

Entrega(idEstafeta, _, idEncomenda, _, _);
Encomenda(idEncomenda, idCliente, _, _, _, _, _, _);    findall disto

%================================
% Query 5 - identificar quais as zonas (e.g., rua ou freguesia) com maior volume de entregas por parte da Green Distribution;
%================================

Cliente(IdCliente, Morada, Freguesia);
Encomenda(idEncomenda, idCliente, _, _, _, _, _, _);
Entrega(_, _, idEncomenda, _, _);                       somar isto e devolver a maior morada e maior freguesia

%================================
% Query 6 - calcular a classificação media de satisfação de cliente para um determinado estafeta; 
%================================

entrega(Estafeta, Nota, _, _, _). somar notas e dividir pelo n
