% В педагогическом институте Аркадьева, Бабанова, Корсакова, Дашков, Ильин и Флеров преподают географию, английский язык, французский язык, немецкий язык, историю и математику.
% Преподаватель немецкого языка и преподаватель математики в студенческие годы занимались художественной гимнастикой. Ильин старше Флерова, но стаж работы у него меньше,
% чем у преподавателя географии. Будучи студентками, Аркадьева и Бабанова учились вместе в одном университете. Все остальные окончили педагогический институт.
% Флеров отец преподавателя французского языка. Преподаватель английского языка самый старший из всех и по возрасту и по стажу. Он работает в этом институте с тех пор,
% как окончил его. Преподаватели математики и истории его бывшие студенты. Аркадьева старше преподавателя немецкого языка. Кто какой предмет преподает?

% [Вспомогательные предикаты]
% Слияние списков
myApp([], X, X).
myApp([H|T1], X, [H|T2]):-
	myApp(T1, X, T2).
	
% Перестановки списка
myPer([], []).
myPer([X], [X]):- !.
myPer([H|T], X):-
	myPer(T, T1),
	myApp(L1, L2, T1),
	myApp(L1, [H], X1),
	myApp(X1, L2, X).
	
% Сравнение возраста и стажа преподавателей
greater0(_, teacher(_, "english", _, _), _):- !.
greater0(age, teacher("Ilyin", _, _, _), teacher("Flerov", _, _, _)):- !.
greater0(age, teacher("Flerov", _, _, _), teacher(_, "french", _, _)):- !.
greater0(age, teacher("Arkadieva", _, _, _), teacher(_, "german", _, _)).
greater0(exp, teacher(_, "geography", _, _), teacher("Ilyin", _, _, _)).

greater(Parameter, Teacher1, Teacher2):-
	not(Teacher1 == Teacher2),
	greater0(Parameter, Teacher1, Teacher2),
	not(greater0(Parameter, Teacher2, Teacher1)).

% [Основная программа]
% Главный предикат
whoIsWho(List):-
	generate(List),
	solve(List).
	
% Перестановки предметов
generate(Teachers):-
	% Будучи студентками, Аркадьева и Бабанова учились вместе в одном университете. Все остальные окончили педагогический институт.
	Teachers = [teacher("Arkadieva", A, f, uni), teacher("Babanova", B, f, uni), teacher("Korsakova", K, f, ins), teacher("Dashkov", D, m, ins), teacher("Ilyin", I, m, ins), teacher("Flerov", F, m, ins)],
	Subjects = ["geography", "english", "french", "german", "history", "math"],
	myPer([A, B, K, D, I, F], Subjects).

% Критерии
solve(List):-
	% Преподаватель немецкого языка и преподаватель математики
	% в студенческие годы занимались художественной гимнастикой.
	member(teacher(_, "german", f, _), List),
    member(teacher(_, "math", f, _), List),
	% Ильин старше Флерова, но стаж работы у него меньше,
	% чем у преподавателя географии.
    member(Flerov, List), Flerov = teacher("Flerov", _, _, _),
    member(Ilyin, List), Ilyin = teacher("Ilyin", _, _, _),
    greater(age, Ilyin, Flerov),
    member(GeoT, List), GeoT = teacher(_, "geography", _, _),
    greater(exp, GeoT, Ilyin),
	% Флеров - отец преподавателя французского языка        
    member(FreT, List), FreT = teacher(_, "french", _, _),
    greater(age, Flerov, FreT),
	% Преподаватель английского - самый старший из всех и по возрасту и по стажу.
	% Он работает в этом институте с тех пор, как окончил его.
    member(teacher(_, "english", _, ins), List),
	% Преподаватели математики и истории - его бывшие студенты. 
    member(teacher(_, "math", _, ins), List),
    member(teacher(_, "history", _, ins), List),
	% Аркадьева старше преподавателя немецкого языка. 
    member(Arkadieva, List), Arkadieva = teacher("Arkadieva", _, _, _),
    member(GerT, List), GerT = teacher(_, "german", _, _),
    greater(age, Arkadieva, GerT).
	
% Результат: whoIsWho(List).
% формат результата: teacher("Фамилия", "предмет", пол, образование)
