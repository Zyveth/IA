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
	write('------------------------------------------------ Centro de Estatísticas da Green Distribution ------------------------------------------------'), nl, nl,
	write('-	1 - Identificar o Estafeta que utilizou mais vezes um Meio de Transporte mais Ecológico.												-'),
	write('-	2 - Identificar que Estafetas entregaram determinadas Encomendas a um determinado Cliente.												-'),
	write('-	3 - Identificar os Clientes servidos por um determinado Estafeta.																		-'),
	write('-	4 - Calcular o Valor Faturado pela Green Distribution num determinado dia.																-'),
	write('-	5 - Identificar quais as zonas (e.g., rua ou freguesia) com maior Volume de Entregas por parte da Green Distribution.					-'),
	write('-	6 - Calcular a Classificação Média de Satisfação de Cliente para um determinado Estafeta.												-'),
	write('-	7 - Identificar o Número Total de Entregas pelos diferentes Meios de Transporte, num determinado Intervalo de Tempo.					-'),
	write('-	8 - Identificar o Número Total de Entregas pelos Estafetas, num determinado Intervalo de Tempo.											-'),
	write('-	9 - Calcular o Número de Encomendas Entregues e não Entregues pela Green Distribution, num determinado Período de Tempo.				-'),
	write('-	10 - Calcular o Peso Total transportado por Estafeta num determinado dia.																-'),
	write('-	11 - Sair.																																-'), nl, nl,
	write('----------------------------------------------------------------------------------------------------------------------------------------------'), nl, nl,
	read(Choice), run_query(Choice), main.

run_query(1) :- estafetaMaisEcologico(idEstafeta),
	writeln('O Estafeta que utilizou mais vezes o Meio de Transporte mais Ecológico foi o ' + idEstafeta).

run_query(2) :- write('Indique qual/quais o(s) Estafeta(s) que pretende analisar : '), readln(idEncomenda),
	estafetasParaCliente(IdEncomenda, IdEstafeta), writeln('O Estafeta que entregou a encomenda' + idEncomenda + 'foi o ' + idEstafeta).

run_query(3) :- write('Indique qual/quais o(s) Estafeta(s) que pretende analisar : '), readln(Estafeta),
	clientesServidosEstafeta(Estafeta,Clientes), writeln('Os Clientes servidos por um determinado Estafeta foram : ' + Clientes).

run_query(4).

run_query(5) :- ruaMaisEntregas(RuaMaisEntregas), freguesiaMaisEntregas(FreguesiaMaisEntregas),
	write('A Freguesia com maior volume de Entregas é a : ' + FreguesiaMaisEntregas),
	writeln('A Rua com maior volume de Entregas é a : ' + RuaMaisEntregas).

run_query(6) :- write('Indique qual o Estafeta que pretende analisar : '), read(Estafeta),
	classificacaoMediaEstafeta(Estafeta,Media), writeln('A Classificação do Estafeta ' + Estafeta + 'é' + Media).

run_query(7) :- write('Indique qual a Data Inicial que pretende analisar, no formato "YYYY-MM-DD" : '), readln(Initial_Time),
	write('Indique qual a Data Final que pretende analisar, no formato "YYYY-MM-DD" : '), readln(Final_Time),
	query7(Initial_Time,Final_Time,"Bicicleta"/X,"Mota"/Y,"Carro"/Z),
	writeln('O Número Total de Entregas realizadas por Bicicleta foi : ' + X + ', por Mota foi : ' + Y + 'e por Carro foi : ' + Z).

run_query(8) :- write('Indique qual o Estafeta que pretende analisar : '), read(Estafeta),
	write('Indique qual a Data Inicial que pretende analisar, no formato "YYYY-MM-DD" : '), readln(Initial_Time),
	write('Indique qual a Data Final que pretende analisar, no formato "YYYY-MM-DD" : '), readln(Final_Time),
	query8(Initial_Time,Final_Time,R), writeln('O Número Total de Entregas realizadas entre as Datas escolhidas foram : ' + R).

run_query(9) :- write('Indique qual a Data Inicial que pretende analisar, no formato "YYYY-MM-DD" : '), readln(Initial_Time),
	write('Indique qual a Data Final que pretende analisar, no formato "YYYY-MM-DD" : '), readln(Final_Time),
	query9(Initial_Time,Final_Time,"Efetuada"/X,"A ser Entregue"/Y,"Entregue"/Z),
	writeln('O Número de Encomendas Entregues pela Green Distribution é : ' + Z + ' e o Número de Encomendas não Entregues pela Green Distribution é : ' + (X+Y)).

run_query(10) :- write('Indique qual o Estafeta que pretende analisar : '), read(Estafeta),
	write('Indique qual a Dia que pretende analisar, no formato "YYYY-MM-DD" : '), readln(Data),
	totalPesoEstafetaDia(Estafeta,Data,TotalPesos), writeln('O Estafeta ' + Estafeta + ' transportou ' + TotalPesos + 'Kb no dia ' + Data).

run_query(11) :- nl, halt.

run_query(_) :- writeln("Escolha uma Opção Válida!").