# Отчет по курсовому проекту

## по курску "Логическое программирование"

**Студент: 	Храпова Н.С.**

## Результат проверки

| Преподаватель  | Дата | Оценка |
| -------------- | ---- | ------ |
| Сошников Д.В.  |      |        |
| Левинская М.А. |      |        |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*

## Задание

1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM с использованием сервиса MyHeritage.com
2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog c использованием предикатов `father(отец, потомок)` и `mother(мать, потомок)`
3. Реализовать предикат проверки/поиска ***свекрови***
4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве
5. [На оценки хорошо и отлично] Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы.
 

 
## Предикат поиска родственника

Реализация предиката поиска **свекрови(svekrov).**


```prolog
% Свекровь - это мать мужа.
% Проверяется, что Y это свекровь для X
svekrov(X, Y):-
	% Мать мужа
	mother(Y, Husb),
	% Проверяем, что есть общий потомок
	% То есть X это жена
	father(Husb, Potomok),
	mother(X, Potomok).
```

Результат работы:

```prolog
% Людмила Кострюкова - свекровь Татьяны Фуфлыгиной.

?- svekrov(X,'Людмила /Кострюкова/').
X = 'Татьяна /Фуфлыгина/' .

?- svekrov('Татьяна /Фуфлыгина/','Людмила /Кострюкова/').
true .

?- svekrov('Татьяна /Фуфлыгина/',Y).
Y = 'Людмила /Кострюкова/' .

% Ольга Храпова - свекровь Людмилы Кострюковой.

?- svekrov('Людмила /Кострюкова/',Y).
Y = 'Ольга //' .
```


## Определение степени родства


**Cтепень родства двух произвольных индивидуумов **

**Исходный код**

```prolog
simple_relative(sam, X, X):- (mother(X,_);father(X,_);mother(_,X);father(_,X)).
% Y - это мама X
simple_relative(mother, X, Y):-
	mother(Y, X).
% Y - это отец X
simple_relative(father, X, Y):-
	father(Y, X).
% Y свекровь для X
simple_relative(svekrov, X, Y):- 
	svekrov(X, Y).
% Y бабушка X
simple_relative(grandmother, X, Y):-
	% Смотрим потомков
	mother(Y, Predok),
	% Один из потомков должен быть предком для X
	(father(Predok, X);mother(Predok, X)).
% Y дедушка X
simple_relative(grandfather, X, Y):-
	% Смотрим потомков
	father(Y, Predok),
	% Один из потомков должен быть предком для X
	(father(Predok, X);mother(Predok, X)).
% Y - это жена X
simple_relative(wife, X, Y):-
	% Проверяем, что у них есть общий ребенок
	mother(Y, Potomok),
	father(X, Potomok).
% Y - это муж X
simple_relative(husband, X, Y):-
	% Проверяем, что у них есть общий ребенок
	mother(X, Potomok),
	father(Y, Potomok).
% Y - это потомок X
simple_relative(potomok, X, Y):-
	mother(X, Y);father(X, Y).
% Y - это сын X
simple_relative(son, X, Y):-
	(mother(X, Y);father(X, Y)),
	% Так же проверяем, что это сын, то есть у них есть дети (таким способом узнаем, что это мужчина)
	father(Y, _).
% Y - это дочь X
simple_relative(daughter, X, Y):-
	(mother(X, Y);father(X, Y)),
	% Так же проверяем, что это дочь, другими словами, есть дети (таким способом узнаем, что это женщина)
	mother(Y, _).
% Y - это брат или сестра X от одного и того же прямого родственника, но не обязательно от двоих (например, от мамы)
simple_relative(sibling, X, Y):-
	(
		% Либо одна и та же мама
		(mother(Mam, X), mother(Mam, Y));
		% Либо один и тот же отец
		(father(Dad, X), father(Dad, Y))
	),
	% Разные люди
	not(X=Y).

% Теперь, решаем саму задачу relative
% Простые отношения
relative(Rel, X, Y):-
	% Просматриваем все возможные введенные простые отношения
	simple_relative(Rel,X,Y).
	
	
% Это универсальный поиск путя от Y до X.
% Есть какие-то родственные взаимотношения, которые по шагам связывают Y с X
% Например, Y это потомок X1, X1 это потомок X2, X2 это мама X3 и вот этот X3 является мамой X 
% Если посмотреть по дереву, то Y - это внук или внучка X2, а для X этот X2 является бабушкой
% Стоит учитывать, что перебор в дереве осуществляется для всех возможных путей 
% у двух братьев мать одна и та же, бабушка с дедушкой те же и тд. Соответственно, и результатов может быть много

relative(Way, X, Y):-
	% Запускаем расширенный предикат для поиска
	relative(Way, [], [], X, Y, 0).
% В данном предикате добавлены Names, Path и DebugPrint
% Список Names (исходно пустой "[]") содержит всех встреченных людей (их имена), нужен для предотвращения зацикливания (чтобы не было повторений)
% Список Path включает в себя собственно путь в обратном порядке и наполняется по ходу поиска
% Флаг DebugPrint - если 1, то в случае, если найден путь, так же распечатываются имена (чтобы легче было проверять цепочки кто кому кем приходится)
% Первое описание предиката для 6 параметров
% Это точка остановка, так как достигли X из Y


relative(Way, RevNames, RevWay, X, X, DebugPrint):- 
	% Разворачиаем списки, так как они перевернуты
	reverse(SimpleWay, RevWay), 
	% Исключаем Y, как исходное (в самом начале добавляется, чтобы исключить лишние переборы)
	reverse([_|SimpleNames], RevNames),
	% Присваиваем путь
	Way = SimpleWay,
	% Если установлен DebugPrint, то распечатываем имена
	((DebugPrint=1,write(SimpleNames));not(DebugPrint=1)).
	
% Второе описание предиката для 6 параметров
% Здесь происходит расширенный перебор
relative(Way, Names, Path, X, Y, DebugPrint):-
	% Ограничиваем перебор только простыми утверждениями potomok, mother, father
	% так как все остальные строятся из них, а это лишь увеличивает перебор
	% Потомок включен только потому, что нужен отслеживать обратный путь
	(CurrRelative=potomok;CurrRelative=mother;CurrRelative=father),
	% Y и первый элемент из обратного пути должны что-то связывать
	simple_relative(CurrRelative, CurrName, Y),
	% Проверяем, что найденное имя не присутствует в списке, тем самым предотвращаем зацикливание
	
	not(member(CurrName, Names)),
	% Добавляем Y при первом проходе, чтобы через него не проходить еще раз
	% Но делаем это тогда, когда Y уже точно определен
	(
		(member(Y,Names), NamesInFirst=Names);
		(not(member(Y,Names)), NamesInFirst=[Y])
	),
	% Имя найденного человека и пройденные элементы заносим в список проверки для следующего хода
	NamesNext = [CurrName|NamesInFirst],
	% Найденное отношение и пройденные элементы заносим в список проверки для следующего хода
	% В данном списке, отношения находятся в обратном порядке
	PathNext = [CurrRelative|Path],
	% Запускаем проверку следующего отношения
	% но уже для текущего элемента (ищем связь с CurrName, то есть двигаемся к X)
	relative(Way, NamesNext, PathNext, X, CurrName, DebugPrint).

% Тот же расширенный поиск, но с распечаткой имен DebugPrint = 1
relative_debug(Way, X, Y):-
	% Запускаем расширенный предикат для поиска
	relative(Way, [Y], [], X, Y, 1).
```



**Пример работы**

```prolog
?- mother('Татьяна /Фуфлыгина/', 'Наталья /Храпова/').
true .
?- mother(X, 'Наталья /Храпова/').
X = 'Татьяна /Фуфлыгина/' ;
X = 'Татьяна1 /Фуфлыгина/'.


?- father('Семён //', 'Николай //').
true.
?- father('Семён //',Y).
Y = 'Николай //' ;
Y = 'Виктор //' ;
Y = 'Вера //'.
?- relative(D,'Семён //', 'Николай //').
D = potomok .
% то есть Николай - потомок Семена.
% правда, мы можем нажать на ";" и посмотреть более подробный путь, приведу небольшой кусочек.
?- relative(D,'Семён //', 'Николай //').
D = potomok ;
D = son ;
D = son ;
D = son ;
D = son ;
D = [potomok, mother, potomok] ;
D = [potomok, mother, potomok] ;
D = [potomok, mother, potomok] ;
D = [potomok, mother, potomok] ;
D = [potomok, potomok, father] ;
D = [potomok] ;
D = [father, potomok, potomok, mother, potomok, mother, mother, potomok, mother|...] ;
D = [father, potomok, potomok, mother, potomok, mother, mother, potomok] ;


?- mother('Павлина //', 'Елена /Кострюкова/').
true.
?- mother('Павлина //',Y).
Y = 'Людмила /Кострюкова/' ;
Y = 'Елена /Кострюкова/' ;
Y = 'Людмила /Кострюкова/'.

% длинный пример
?- relative(Way, 'Николай //', 'Екатерина //').
Way = [potomok, mother, potomok, father, mother, potomok] ;
Way = [potomok, mother, potomok, father, mother, potomok, mother] ;
Way = [potomok, mother, potomok, father, mother, potomok, mother] ;
Way = [potomok, mother, potomok, father, mother, potomok, mother, potomok, potomok|...] ;
Way = [potomok, mother, potomok, father, mother, potomok, mother, potomok, father] ;
Way = [potomok, mother, potomok, father, mother, potomok] ;
Way = [potomok, mother, potomok, father, mother, potomok, potomok, father, father] ;
Way = [potomok, mother, potomok, father, mother, potomok, father] ;
Way = [potomok, mother, potomok, father, mother, potomok, father, potomok, mother] ;
Way = [potomok, mother, potomok, father, mother, potomok, father, potomok, mother] ;
Way = [potomok, mother, potomok, father, mother, potomok] ;
Way = [potomok, mother, potomok, father, mother, mother, mother, potomok, potomok|...] ;
Way = [potomok, mother, potomok, father, mother, mother, mother, potomok, father|...] ;
Way = [potomok, mother, potomok, father, mother, mother, mother, potomok, potomok|...] ;
Way = [potomok, mother, mother, potomok] ;
;Way = [potomok, mother, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, potomok] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, mother, potomok, father, mother, potomok] ;
Way = [potomok, mother, potomok, father, mother, mother, mother, potomok, potomok|...] ;
Way = [potomok, mother, potomok, father, mother, mother, mother, potomok, potomok|...] ;
Way = [potomok, mother, potomok, father, mother, mother, mother, potomok, father|...] ;
Way = [potomok, mother, mother, potomok] ;
Way = [potomok, mother, mother, potomok, mother] ;
Way = [potomok, mother, mother, potomok, mother] ;
Way = [potomok, mother, mother, potomok, mother, potomok, potomok, father, father] ;
Way = [potomok, mother, mother, potomok, mother, potomok, father] ;
Way = [potomok, mother, mother, potomok] ;
Way = [potomok, mother, mother, potomok, potomok, father, father] ;
Way = [potomok, mother, mother, potomok, father] ;
Way = [potomok, mother, mother, potomok, father, potomok, mother] ;
Way = [potomok, mother, mother, potomok, father, potomok, mother] ;
Way = [potomok, mother, mother, potomok] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, mother, mother, mother, mother, potomok, potomok, potomok] ;
Way = [potomok, father, mother, potomok] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, potomok] ;
Way = [potomok, father, mother, potomok, mother] ;
Way = [potomok, father, mother, potomok, mother] ;
Way = [potomok, father, mother, potomok, mother, potomok, potomok, father, father] ;
Way = [potomok, father, mother, potomok, mother, potomok, father] ;
Way = [potomok, father, mother, potomok] ;
Way = [potomok, father, mother, potomok, potomok, father, father] ;
Way = [potomok, father, mother, potomok, father] ;
Way = [potomok, father, mother, potomok, father, potomok, mother] ;
Way = [potomok, father, mother, potomok, father, potomok, mother] ;
Way = [potomok, father, mother, potomok] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok] ;
Way = [potomok, father, mother, potomok] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok, mother|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, potomok] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
Way = [potomok, father, mother, potomok] ;
Way = [potomok, father, mother, potomok, mother] ;
Way = [potomok, father, mother, potomok, mother] ;
Way = [potomok, father, mother, potomok, mother, potomok, potomok, father, father] ;
Way = [potomok, father, mother, potomok, mother, potomok, father] ;
Way = [potomok, father, mother, potomok] ;
Way = [potomok, father, mother, potomok, potomok, father, father] ;
Way = [potomok, father, mother, potomok, father] ;
Way = [potomok, father, mother, potomok, father, potomok, mother] ;
Way = [potomok, father, mother, potomok, father, potomok, mother] ;
Way = [potomok, father, mother, potomok] ;
Way = [potomok, father, mother, mother, mother, potomok, potomok, mother, father|...] ;
Way = [potomok, father, mother, mother, mother, potomok, father, potomok, potomok|...] ;
false.
```

## Парсер


```c#
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace PrologGed
{
    class Program
    {
        static void Main(string[] args)
        {
            
            Dictionary<string, string> Peoples = new Dictionary<string, string>();

      // Здесь хранятся все полученные выражения mother(мать, потомок) и father(отец, потомок)
            List<string> MothersProlog = new List<string>();
            List<string> FathersProlog = new List<string>();

            // Входной файл (ANSI) с деревом
            StreamReader FileGed = new StreamReader("fam.ged", Encoding.Default);
            if (FileGed == null) return;

            // Тут сохраняем значение строки
            string Stroka = FileGed.ReadLine();
            while (Stroka != null)
            {
                // пользователь, делаем разбор данных пользователя
                if (Stroka.StartsWith("0 @I"))
                {
                    // Получаем идентификатор
                    string[] StrokaSlova = Stroka.Split(' ');
                    string Identificator = StrokaSlova[1];
                    Stroka = FileGed.ReadLine();

				  // Получаем имя
                    while (!Stroka.StartsWith("1 NAME") && Stroka != null)
                    {
                        Stroka = FileGed.ReadLine();
                    }
                    if (Stroka == null) break;
                    string Name = Stroka.Substring(7);
                    
                    // Сохраняем имя и идентификатор
                    Peoples.Add(Identificator, Name);
                }
                
           // Видим семью - делаем разбор данных пользователя. 
                else if (Stroka.StartsWith("0 @F"))
                {
                    string Mother = "";
                    string Father = "";

                    Stroka = FileGed.ReadLine();
                    while (Stroka != null)
                    {
                        // Если строка - это мама
                        if (Stroka.StartsWith("1 WIFE"))
                        {
                            // Идентификатор следует сразу после "1 WIFE ", то есть 7 символов
                            string Identificator = Stroka.Substring(7);
                            Mother = Peoples[Identificator];
                        }
                        // Если строка - это отец
                        else if (Stroka.StartsWith("1 HUSB"))
                        {
                            // Идентификатор следует сразу после "1 HUSB ", то есть 7 символов
                            string Identificator = Stroka.Substring(7);
                            Father = Peoples[Identificator];
                        }
                        // Если встретили потомка
                        else if (Stroka.StartsWith("1 CHIL"))
                        {
                            string Identificator = Stroka.Substring(7);
                            string PotomokName = Peoples[Identificator];
          // Записываем определение матери, если в семье мама указана (встретилось определение)
                            if (Mother != "")
                            {
                          MothersProlog.Add("mother('" + Mother + "', '" + PotomokName + "').");
                            }
          // Записываем определение отца, если в семье отец указан (встретилось определение)
                            if (Father != "")
                            {
                          FathersProlog.Add("father('" + Father + "', '" + PotomokName + "').");
                            }
                        }
                        // Если это какое-то определение
                        else if (Stroka.StartsWith("0")) break;
                        Stroka = FileGed.ReadLine();
                    }

                    // Если строка - определение, то не нужно считывать следующую строку
                    if (Stroka.StartsWith("0")) continue;
                }

                     Stroka = FileGed.ReadLine();
            }

            
            // А теперь, записываем файл в той же кодировке ANSI всех матерей и отцов
            StreamWriter FileFam = new StreamWriter("fam.pl", false, FileGed.CurrentEncoding);

            // Пишем всех матерей и далее отцов
            for(int cnt = 0; cnt < MothersProlog.Count; cnt++)
            {
                FileFam.WriteLine(MothersProlog[cnt]);
            }

            for (int cnt = 0; cnt < FathersProlog.Count; cnt++)
            {
                FileFam.WriteLine(FathersProlog[cnt]);
            }

            FileFam.Close();
            FileGed.Close();

            Console.WriteLine("Преобразовали файл");
        }
    }
}

```



## Выводы

При составлении родословного дерева моей семьи, некоторые фамилии были утрачены, поэтому в дереве они имеют название - неизвестный(ая). Мое родословное дерево насчитывает 67 человек.
После получения родословного дерева с сайта, мы экспортируем наше дерево. Для конвертации родословного дерева был выбран язык C#.
При переборке всех результатов в различных предикатах, возникоют повторения. Это обусловлено, например, тем, что муж и жена определяются только по наличию общего ребенка. Соответственно, если детей несколько, то будут повторения.
Для определения степени родства двух произвольных индивидуумов, чтобы можно было делать перебор, нужно отделить простые проверки от сложных, поэтому введем предикат simple_relative(Rel, X, Y).
В **relative**, например, если детей несколько, то опять же будут повторения, так как через каждого будет проходить перебор. Перебор в дереве осуществляется для всех возможных путей. Так, например, у двух братьев мать одна и та же, бабушка с дедушкой одни и те же и так далее. Это означает, что различных решений много.
Так как алгоритм расширенного поиска relative это, по сути, - перебор в глубину, то короткие пути не всегда будут в первых результатах поиска.

Prolog - это язык, с помощью которого можно обрабатывать сложные иерархические структуры, представленные в виде деревьев. Программа на Прологе может простым образом читаться на естественном языке, а также исполняться простейшим интерпретатором. Prolog — это золотая середина, между простым интерпретатором и машиной для доказательства теорем, сдвиг в любую сторон приводит к потери одного из свойств.
Prolog похож на то, как мыслят люди. Мне нравится, как в Прологе можно структурировать генеалогическое дерево своей семьи и затем, без лишнего анализа, можно узнавать связь между интересующими нас родственниками. То есть пришлось потратить время на написание программы, но зато в будущем больше никогда не нужно обращаться к собственным ресурсам и пытаться разобраться в довольно сложной связи родственников, а это очень удобно. Поэтому я думаю, что в ближайшем будущем логические языки программирования будут развиваться все больше и больше.