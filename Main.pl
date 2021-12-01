%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Inteligência Artificial - LEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Trabalho Prático. 
% Main do Trabalho Prático.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Includes necessários para o funcionamento das Queries :

:- style_check(-discontiguous).
:- style_check(-singleton).

:- use_module(library(lists)).

:- include('Cliente.pl').
:- include('Encomenda.pl').
:- include('Entrega.pl').
:- include('Estafeta.pl').
:- include('Queries.pl').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Main.

main() :- nl,
	write('------------------------------------------------ Centro de Estatisticas da Green Distribution ------------------------------------------------'), nl, nl,
	writeln('-    1 - Identificar o Estafeta que utilizou mais vezes um Meio de Transporte mais Ecologico.'),
	writeln('-    2 - Identificar que Estafetas entregaram determinadas Encomendas a um determinado Cliente.'),
	writeln('-    3 - Identificar os Clientes servidos por um determinado Estafeta.'),
	writeln('-    4 - Calcular o Valor Faturado pela Green Distribution num determinado dia.'),
	writeln('-    5 - Identificar quais as zonas (e.g., rua ou freguesia) com maior Volume de Entregas por parte da Green Distribution.'),
	writeln('-    6 - Calcular a Classificacao Media de Satisfacao de Cliente para um determinado Estafeta.'),
	writeln('-    7 - Identificar o Numero Total de Entregas pelos diferentes Meios de Transporte, num determinado Intervalo de Tempo.'),
	writeln('-    8 - Identificar o Numero Total de Entregas pelos Estafetas, num determinado Intervalo de Tempo.'),
	writeln('-    9 - Calcular o Numero de Encomendas Entregues e nao Entregues pela Green Distribution, num determinado Periodo de Tempo.'),
	writeln('-    10 - Calcular o Peso Total transportado por Estafeta num determinado dia.'),
	writeln('-    11 - Sair.'), nl,
	write('----------------------------------------------------------------------------------------------------------------------------------------------'), nl, nl,
	read(Choice), run_query(Choice), main.

run_query(1) :- estafetaMaisEcologico(IdEstafeta),
	write('O Estafeta que utilizou mais vezes o Meio de Transporte mais Ecologico foi o '),  writeln(IdEstafeta).

run_query(2) :- write('Indique qual/quais a(s) Encomenda(s) que pretende analisar : '), read(IdEncomenda),
	estafetasParaCliente(IdEncomenda, IdEstafeta), write('O Estafeta que entregou a encomenda '), write(IdEncomenda), write(' foi o '), writeln(IdEstafeta).

run_query(3) :- write('Indique qual/quais o(s) Estafeta(s) que pretende analisar : '), read(Estafeta),
	clientesServidosEstafeta(Estafeta,Clientes), write('Os Clientes servidos por um determinado Estafeta foram : '), writeln(Clientes).

run_query(4) :- write('Indique qual a Dia que pretende analisar, no formato "YYYY-MM-DD" : '), read(Data),
	valorFaturadoDia(Data,TotalFaturado), write('O Valor Faturado pela Green Distribution no dia '), write(Data),
	write(' foi '), writeln(TotalFaturado).

run_query(5) :- ruaMaisEntregas(RuaMaisEntregas), freguesiaMaisEntregas(FreguesiaMaisEntregas),
	write('A Freguesia com maior volume de Entregas e a : '),  writeln(FreguesiaMaisEntregas),
	write('A Rua com maior volume de Entregas e a : '), writeln(RuaMaisEntregas).

run_query(6) :- write('Indique qual o Estafeta que pretende analisar : '), read(Estafeta),
	classificacaoMediaEstafeta(Estafeta,Media), write('A Classificacao do Estafeta '), write(Estafeta), write(' é '), writeln(Media).

run_query(7) :- write('Indique qual a Data Inicial que pretende analisar, no formato "YYYY-MM-DD" : '), read(Initial_Time),
	write('Indique qual a Data Final que pretende analisar, no formato "YYYY-MM-DD" : '), read(Final_Time),
	query7(Initial_Time,Final_Time,"Bicicleta"/X,"Mota"/Y,"Carro"/Z),
	writeln('O Numero Total de Entregas realizadas por Bicicleta foi : '), write(X), write(', por Mota foi : '), write(Y), write('e por Carro foi : '), writeln(Z).

run_query(8) :- write('Indique qual o Estafeta que pretende analisar : '), read(Estafeta),
	write('Indique qual a Data Inicial que pretende analisar, no formato "YYYY-MM-DD" : '), read(Initial_Time),
	write('Indique qual a Data Final que pretende analisar, no formato "YYYY-MM-DD" : '), read(Final_Time),
	query8(Initial_Time,Final_Time,R), write('O Numero Total de Entregas realizadas entre as Datas escolhidas foram : '),  writeln(R).

run_query(9) :- write('Indique qual a Data Inicial que pretende analisar, no formato "YYYY-MM-DD" : '), read(Initial_Time),
	write('Indique qual a Data Final que pretende analisar, no formato "YYYY-MM-DD" : '), read(Final_Time),
	query9(Initial_Time,Final_Time,"Efetuada"/X,"A ser Entregue"/Y,"Entregue"/Z),
	write('O Numero de Encomendas Entregues pela Green Distribution e : '), write(Z),
	write(' e o Numero de Encomendas nao Entregues pela Green Distribution e : '), writeln((X+Y)).

run_query(10) :- write('Indique qual o Estafeta que pretende analisar : '), read(Estafeta),
	write('Indique qual a Dia que pretende analisar, no formato "YYYY-MM-DD" : '), read(Data),
	totalPesoEstafetaDia(Estafeta,Data,TotalPesos), write('O Estafeta '), write(Estafeta), write(' transportou '),
	write(TotalPesos), write('Kg no dia '), writeln(Data).

run_query(11) :- nl, halt.

run_query(_) :- writeln("Escolha uma Opcao Valida!").