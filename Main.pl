%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Inteligência Artificial - LEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Trabalho Prático. 
% Main do Trabalho Prático.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Includes necessários para o funcionamento da Main :

:- include('Queries.pl').

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Main.

main() :- nl,
	write('------------------------------------------------ Centro de Estatisticas da Green Distribution ------------------------------------------------'), nl, nl,
	write('-    1 - Identificar o Estafeta que utilizou mais vezes um Meio de Transporte mais Ecologico.'), nl,
	write('-    2 - Identificar que Estafetas entregaram determinadas Encomendas a um determinado Cliente.'), nl,
	write('-    3 - Identificar os Clientes servidos por um determinado Estafeta.'), nl,
	write('-    4 - Calcular o Valor Faturado pela Green Distribution num determinado dia.'), nl,
	write('-    5 - Identificar quais as zonas (e.g., Morada ou Freguesia) com maior Volume de Entregas por parte da Green Distribution.'), nl,
	write('-    6 - Calcular a Classificacao Media de Satisfacao de Cliente para um determinado Estafeta.'), nl,
	write('-    7 - Identificar o Numero Total de Entregas pelos diferentes Meios de Transporte, num determinado Intervalo de Tempo.'), nl,
	write('-    8 - Identificar o Numero Total de Entregas pelos Estafetas, num determinado Intervalo de Tempo.'), nl,
	write('-    9 - Calcular o Numero de Encomendas Entregues e nao Entregues pela Green Distribution, num determinado Periodo de Tempo.'), nl,
	write('-    10 - Calcular o Peso Total transportado por Estafeta num determinado dia.'), nl,
	write('-    11 - Sair.'), nl, nl,
	write('----------------------------------------------------------------------------------------------------------------------------------------------'), nl, nl,
	read(Choice), run_query(Choice), main.

% Função que faz com que os Inputs e os Outputs da 'query1' ocorram, quando chamados pela função 'main'.
run_query(1) :- query1(IdEstafeta),
	write('O Estafeta que utilizou mais vezes o Meio de Transporte mais Ecologico foi o '),  write(IdEstafeta), writeln('.').

% Função que faz com que os Inputs e os Outputs da 'query2' ocorram, quando chamados pela função 'main'.
run_query(2) :- write('Indique qual/quais a(s) Encomenda(s) que pretende analisar : '), read(IdEncomenda),
	query2(IdEncomenda, IdEstafeta), write('O Estafeta que entregou a(s) encomenda(s) '),
	write(IdEncomenda), write(' foi o '), write(IdEstafeta), writeln('.').

% Função que faz com que os Inputs e os Outputs da 'query3' ocorram, quando chamados pela função 'main'.
run_query(3) :- write('Indique qual o Estafeta que pretende analisar : '), read(Estafeta),
	query3(Estafeta,Clientes), write('Os Clientes servidos por um determinado Estafeta foram : '), write(Clientes), writeln('.').

% Função que faz com que os Inputs e os Outputs da 'query4' ocorram, quando chamados pela função 'main'.
run_query(4) :- write('Indique qual a Dia que pretende analisar, no formato "YYYY-MM-DD" : '), read(Data),
	query4(Data,TotalFaturado), write('O Valor Faturado pela Green Distribution no dia '), write(Data),
	write(' foi '), write(TotalFaturado), writeln('.').

% Função que faz com que os Inputs e os Outputs da 'query5' ocorram, quando chamados pela função 'main'.
run_query(5) :- query5_1(MoradaMaisEntregas), query5_2(FreguesiaMaisEntregas),
	write('A Freguesia com maior volume de Entregas e a : '),  write(FreguesiaMaisEntregas), writeln('.'),
	write('A Morada com maior volume de Entregas e a : '), write(MoradaMaisEntregas), writeln('.').

% Função que faz com que os Inputs e os Outputs da 'query6' ocorram, quando chamados pela função 'main'.
run_query(6) :- write('Indique qual o Estafeta que pretende analisar : '), read(Estafeta),
	query6(Estafeta,Media), write('A Classificacao do Estafeta '), write(Estafeta), write(' e '), write(Media), writeln('.').

% Função que faz com que os Inputs e os Outputs da 'query7' ocorram, quando chamados pela função 'main'.
run_query(7) :- write('Indique qual a Data Inicial que pretende analisar, no formato "YYYY-MM-DD" : '), read(Initial_Time),
	write('Indique qual a Data Final que pretende analisar, no formato "YYYY-MM-DD" : '), read(Final_Time),
	query7(Initial_Time,Final_Time,X,Y,Z),
	write('O Numero Total de Entregas realizadas por Bicicleta foi : '),
	write(X), write(', por Mota foi : '), write(Y), write(' e por Carro foi : '), write(Z), writeln('.').

% Função que faz com que os Inputs e os Outputs da 'query8' ocorram, quando chamados pela função 'main'.
run_query(8) :- write('Indique qual a Data Inicial que pretende analisar, no formato "YYYY-MM-DD" : '), read(Initial_Time),
	write('Indique qual a Data Final que pretende analisar, no formato "YYYY-MM-DD" : '), read(Final_Time),
	query8(Initial_Time,Final_Time,R), write('O Numero Total de Entregas realizadas entre as Datas escolhidas foram : '),  write(R), writeln('.').

% Função que faz com que os Inputs e os Outputs da 'query9' ocorram, quando chamados pela função 'main'.
run_query(9) :- write('Indique qual a Data Inicial que pretende analisar, no formato "YYYY-MM-DD" : '), read(Initial_Time),
	write('Indique qual a Data Final que pretende analisar, no formato "YYYY-MM-DD" : '), read(Final_Time),
	query9(Initial_Time,Final_Time,X,Y),
	write('O Numero de Encomendas Entregues pela Green Distribution e : '), write(Y),
	write(' e o Numero de Encomendas nao Entregues pela Green Distribution e : '), write(X), writeln('.').

% Função que faz com que os Inputs e os Outputs da 'query10' ocorram, quando chamados pela função 'main'.
run_query(10) :- write('Indique qual o Estafeta que pretende analisar : '), read(Estafeta),
	write('Indique qual a Dia que pretende analisar, no formato "YYYY-MM-DD" : '), read(Data),
	query10(Estafeta,Data,TotalPesos), write('O Estafeta '), write(Estafeta), write(' transportou '),
	write(TotalPesos), write('Kg no dia '), write(Data), writeln('.').

% Função que faz com que a função 'main' acabe de executar.
run_query(11) :- nl, halt.

% Função que invalida qualquer opção que não esteja na 'main'.
run_query(_) :- writeln("Escolha uma Opcao Valida!").