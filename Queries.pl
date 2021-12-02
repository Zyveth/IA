%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Inteligência Artificial - LEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Trabalho Prático. 
% Queries relacionadas com as Funcionalidades Pretendidas.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Includes necessários para o funcionamento das Queries :

:- style_check(-discontiguous).
:- style_check(-singleton).

:- use_module(library(lists)).

:- include('Cliente.pl').
:- include('Encomenda.pl').
:- include('Entrega.pl').
:- include('Estafeta.pl').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 1 - Identificar o Estafeta que utilizou mais vezes um Meio de Transporte mais Ecológico.

query1(Estafeta) :-
    getBicicletas(Estafetas),
    sort(Estafetas, Uniq),
    findall([Freq, X], (
        member(X, Uniq),
        include( =(X), Estafetas, XX),
        length(XX, Freq)
    ), Freqs),
    sort(Freqs, SFreqs),
    last(SFreqs, [Freq, Estafeta]).

% Função auxiliar da função 'query1' que encontra todos os Estafetas que usam Bicicletas.
getBicicletas(Estafetas) :- 
    findall(IdEstafeta,(entrega(IdEstafeta, _, _, _, "Bicicleta")),Estafetas).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 2 - Identificar que Estafetas entregaram determinadas Encomendas a um determinado Cliente.

query2([],[]).
query2([IdEncomenda|IdEncomendas], IdEstafetas) :-
    estafetaParaCliente(Estafeta,IdEncomenda),
    query2(IdEncomendas,Y),
    append([[Estafeta],Y],IdEstafetas).

% Função auxiliar da função 'query2' que encontra todas os Id's das Encomendas entregues por um determinado Estafeta.
estafetaParaCliente(IdEstafeta,IdEncomenda) :-
    entrega(IdEstafeta,_, IdEncomenda,_,_).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 3 - Identificar os Clientes servidos por um determinado Estafeta.

query3(Estafeta,ClientesOrdenados) :-
    findall(IdCliente,(entrega(Estafeta, _, IdEncomenda, _, _),encomenda(IdEncomenda, IdCliente, _, _, _, _, _, _)),Clientes),
    removeClientesDuplicados(Clientes,ClientesUnicos),
    sort(ClientesUnicos,ClientesOrdenados).

% Função auxiliar da função 'query 3' que remove os Clientes repetidos numa Lista.
removeClientesDuplicados([],[]).
removeClientesDuplicados([H | T], Clientes) :- member(H, T), removeClientesDuplicados( T, Clientes).
removeClientesDuplicados([H | T], [H|T1]) :- \+member(H, T), removeClientesDuplicados( T, T1).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 4 - Calcular o Valor Faturado pela Green Distribution num determinado dia.

query4(Data,TotalFaturado) :-
    findall(ValorFinal,
            ((entrega(_,_,IdEncomenda,Data,MeioDeTransporte),encomenda(IdEncomenda,_,_,_,_,Preco,_,DataPrevistaDeEntrega)),
            parse_time(DataPrevistaDeEntrega,I),
            parse_time(Data,F),
            (((MeioDeTransporte = "Bicicleta"),F > I, ValorFinal is Preco * 0.85 * 0.75);
            ((MeioDeTransporte = "Carro"),F > I, ValorFinal is Preco * 1 * 0.75);
            ((MeioDeTransporte = "Mota"),F > I, ValorFinal is Preco * 1.1 * 0.75);
            ((MeioDeTransporte = "Bicicleta"),F =< I, ValorFinal is Preco * 0.85);
            ((MeioDeTransporte = "Carro"),F =< I, ValorFinal is Preco * 1);
            ((MeioDeTransporte = "Mota"),F =< I, ValorFinal is Preco * 1.1)))
            ,Valores),
    sum_list(Valores,TotalFaturado).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 5 - Identificar quais as zonas (e.g., Morada ou Freguesia) com maior Volume de Entregas por parte da Green Distribution.

% Função que devolve a Morada com maior Volume de Entregas.
query5_1(MoradaMaisEntregas) :-
    moradasTodasEntregas(Moradas),
    sort(Moradas, Uniq),
    findall([Freq, X], (
        member(X, Uniq),
        include(=(X), Moradas, XX),
        length(XX, Freq)
    ), Freqs),
    sort(Freqs, SFreqs),
    last(SFreqs, [Freq, RuaMaisEntregas]).

% Função que devolve a Freguesia com maior Volume de Entregas.
query5_2(FreguesiaMaisEntregas) :-
    freguesiasTodasEntregas(Freguesias),
    sort(Freguesias, Uniq),
    findall([Freq, X], (
        member(X, Uniq),
        include(=(X), Freguesias, XX),
        length(XX, Freq)
    ), Freqs),
    sort(Freqs, SFreqs),
    last(SFreqs, [Freq, FreguesiaMaisEntregas]).

% Função auxiliar da função 'query5_1' que devolve todas as Morada onde ocorre pelo menos uma Entregas de uma Encomenda.
moradasTodasEntregas(Moradas) :-
    findall(Morada,(cliente(IdCliente, Morada, _),encomenda(IdEncomenda, IdCliente, _, _, _, _, _, _),entrega(_, _, IdEncomenda, _, _)),Moradas).

% Função auxiliar da função 'query5_2' que devolve todas as Freguesias onde ocorre pelo menos uma Entregas de uma Encomenda.
freguesiasTodasEntregas(Freguesias) :-
    findall(Freguesia,(cliente(IdCliente, _, Freguesia),encomenda(IdEncomenda, IdCliente, _, _, _, _, _, _),entrega(_, _, IdEncomenda, _, _)),Freguesias).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 6 - Calcular a Classificação Média de Satisfação de Cliente para um determinado Estafeta.

query6(Estafeta,Media) :-
    classificacoesEstafeta(Estafeta,Classificacoes),
    mediaLista(Classificacoes,Media).

% Função auxiliar da função 'query6' que encontra todas as Classificações atribuidas a um Estafeta.
classificacoesEstafeta(Estafeta,Classificacoes) :-
    findall(Classificacao,entrega(Estafeta,Classificacao,_,_,_),Classificacoes).

% Função auxiliar da função 'mediaLista' que calcula o tamanho de uma Lista.
length2([], 0).
length2([H|T], N) :- length(T, N1), N is N1 + 1.

% Função auxiliar da função 'mediaLista' que soma todos os elementos de uma Lista.
sum([],0).
sum([X|List],Sum) :-
    sum(List,Sum1),
    Sum = X + Sum1.

% Função auxiliar da função 'query6' que calcula a média dos elementos de uma Lista.
mediaLista(Lista,Media) :-
    length2(Lista,N), sum(Lista,Soma),
    Media is Soma/N.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 7 - Identificar o Número Total de Entregas pelos diferentes Meios de Transporte, num determinado Intervalo de Tempo.

query7(Initial_Time,Final_Time,X,Y,Z):-
    get_all_filter_time(Initial_Time,Final_Time,Time),
    filter_transports(Time,T),
    count(T,"Bicicleta",X),
    count(T,"Mota",Y),
    count(T,"Carro",Z).

% Função auxiliar das funções 'query7' e 'query9' que conta quantas vezes um elemento X ocorre numa lista.
count([],X,0).
count([X|T],X,Y):- count(T,X,Z), Y is 1 + Z.
count([X1|T],X,Z):- X1 \= X,count(T,X,Z).

% Função auxiliar das funções 'query7' e 'query8' que recolhe em R todas as Entregas feitas durante o Intervalo de Tempo indicado.
get_all_filter_time(Initial_Time,Final_Time,R):-
    findall(Entrega,filter_time(Initial_Time,Final_Time,Entrega),R).

% Função auxiliar da função 'query7' que filtra as Entregas guardando os Meios de Transporte Utilizados em cada uma delas.
filter_transports([Entrega],R):- get_transport(Entrega,X), R = [X].
filter_transports([Entrega|Entregas],R):- get_transport(Entrega,X), filter_transports(Entregas,Y), R = [X|Y].

% Função auxiliar da função 'filter_transports' usada para obter o Meio de Transporte utilizado numa Entrega.
get_transport(entrega(_,_,_,_,T),T).

% Função auxiliar da função 'get_all_filter_time' que verifica se uma Entrega foi feita no Intervalo de Tempo indicado.
filter_time(Initial_Time,Final_Time,Entrega):-
    get_time(X,Entrega),
    parse_time(Initial_Time,I),
    parse_time(Final_Time,F),
    parse_time(X,Y),
    Y >= I,
    Y =< F.

% Função auxiliar da função 'filter_time' para obter a Data na qual uma Entrega foi feita.
get_time(X,E):-
    entrega(A,B,C,X,D),
    E = entrega(A,B,C,X,D).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 8 - Identificar o Número Total de Entregas pelos Estafetas, num determinado Intervalo de Tempo.

query8(Initial_Time,Final_Time,R):-
    get_all_filter_time(Initial_Time,Final_Time,X),
    length(X,R).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 9 - Calcular o Número de Encomendas Entregues e não Entregues pela Green Distribution, num determinado Período de Tempo.

query9(Initial_Time,Final_Time,X,Z):-
    get_all_filter_time_encomenda(Initial_Time,Final_Time,Time),
    filter_estado(Time,T),
    count(T,"Entregue",A),
    query7(Initial_Time,Final_Time,B,C,D),
    Z is B + C + D,
    length(T,L),
    X is L - Z.
    
% Função auxiliar da função 'query9' que recolhe em R todas as Encomendas pedidas durante o Intervalo de Tempo indicado.
get_all_filter_time_encomenda(Initial_Time,Final_Time,R):-
    findall(Encomenda,filter_time_encomenda(Initial_Time,Final_Time,Encomenda),R).

% Função auxiliar da função 'get_all_filter_time_encomenda' verifica se uma Encomenda foi pedida no Intervalo de Tempo indicado.
filter_time_encomenda(Initial_Time,Final_Time,Encomenda):-
    get_time_encomenda(X,Encomenda),
    parse_time(Initial_Time,I),
    parse_time(Final_Time,F),
    parse_time(X,Y),
    Y >= I,
    Y =< F.

% Função auxiliar da função 'filter_time_encomenda' usada para obter a Data na qual uma Encomenda foi pedida.
get_time_encomenda(X,Encomenda):-
    encomenda(A,B,C,D,E,F,X,G),
    Encomenda = encomenda(A,B,C,D,E,F,X,G).

% Função auxiliar da função 'query9' que filtra as Encomendas guardando o Estado de cada uma delas.
filter_estado([Encomenda],R):- get_estado(Encomenda,X), R = [X].
filter_estado([Encomenda|Encomendas],R):- get_estado(Encomenda,X), filter_estado(Encomendas,Y), R = [X|Y].

% Função auxiliar da função 'filter_estado' usada para obter o Estado duma encomenda.
get_estado(encomenda(_,_,_,_,S,_,_,_),S).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Query 10 - Calcular o Peso Total transportado por Estafeta num determinado dia.

query10(Estafeta,Data,TotalPesos) :-
    findall(Peso,(entrega(Estafeta, _,IDencomenda, Data, _),encomenda(IDencomenda,_,Peso,_,_,_,_,_)),ListaPesos),
    sum_list(ListaPesos,TotalPesos).