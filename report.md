## Отчет по лабораторной работе по курсу: «Искусственный интеллект»
## по теме: «Экспертные системы»

## Решение логических задач

## студент: Храпова Н.С.
## группа:	 8О-404Б

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В.     |              |               |
| Левинская М.А.    |              |               |


# Реализация экспертной системы выполнена на CLIPS.

# Код программы:
```CLIPS
(deftemplate Game (slot GameType))

(deftemplate Price (slot GamePrice))
(deftemplate Coop (slot GameCoop))
(deftemplate Plot (slot GamePlot))
(deftemplate Action (slot GameAction))
(deftemplate CreateOrShoot (slot GameCreateOrShoot))


(defrule GTAV 
	(Price (GamePrice yes))
	(Coop (GameCoop yes | no))
	(Plot (GamePlot yes | no))
	(Action (GameAction yes))
	(CreateOrShoot (GameCreateOrShoot yes | no))
=>
(assert (Game (GameType GTAV)))
	(printout t "Play GTA V." crlf))
	
(defrule OverWatch
	(Price (GamePrice yes))
	(Coop (GameCoop yes))
	(Plot (GamePlot no))
	(Action (GameAction yes))
	(CreateOrShoot (GameCreateOrShoot yes | no))
=>
(assert (Game (GameType OverWatch)))
	(printout t "Play OverWatch." crlf))
	
	
(defrule LOL 
	(Price (GamePrice no))
	(Coop (GameCoop yes))
	(Plot (GamePlot no))
	(Action (GameAction yes))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType LOL)))
	(printout t "Play League Of Legends." crlf))
	

(defrule WD2 
	(Price (GamePrice yes))
	(Coop (GameCoop yes | no))
	(Plot (GamePlot yes))
	(Action (GameAction yes))
	(CreateOrShoot (GameCreateOrShoot yes))
=>
(assert (Game (GameType WD2)))
	(printout t "Play Watch Dogs 2." crlf))	

	
	
(defrule SIMS 
	(Price (GamePrice yes))
	(Coop (GameCoop no))
	(Plot (GamePlot no))
	(Action (GameAction no))
	(CreateOrShoot (GameCreateOrShoot yes))
=>
(assert (Game (GameType SIMS)))
	(printout t "Play Sims 4." crlf))
	

(defrule CitiesSkylines
	(Price (GamePrice yes ))
	(Coop (GameCoop no ))
	(Plot (GamePlot no))
	(Action (GameAction no))
	(CreateOrShoot (GameCreateOrShoot yes))
=>
(assert (Game (GameType CitiesSkylines)))
	(printout t "Play Cities Skylines." crlf))
	
	
(defrule Simcity
	(Price (GamePrice yes))
	(Coop (GameCoop no))
	(Plot (GamePlot no ))
	(Action (GameAction no ))
	(CreateOrShoot (GameCreateOrShoot yes))
=>
(assert (Game (GameType Simcity)))
	(printout t "Play Simcity." crlf))

	
(defrule LIS
	(Price (GamePrice yes))
	(Coop (GameCoop no))
	(Plot (GamePlot yes))
	(Action (GameAction no))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType LIS)))
	(printout t "Play Life is Strange." crlf))
	
	
(defrule Skyrim
	(Price (GamePrice yes))
	(Coop (GameCoop no))
	(Plot (GamePlot yes | no))
	(Action (GameAction yes | no))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType Skyrim)))
	(printout t "Play The Elder Scrolls V: Skyrim." crlf))
	
	
(defrule WOW
	(Price (GamePrice yes))
	(Coop (GameCoop yes | no))
	(Plot (GamePlot yes | no))
	(Action (GameAction yes))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType WOW)))
	(printout t "Play World of Warcraft." crlf))
	
	
(defrule Stellaris
	(Price (GamePrice yes))
	(Coop (GameCoop yes | no))
	(Plot (GamePlot no))
	(Action (GameAction no))
	(CreateOrShoot (GameCreateOrShoot yes))
=>
(assert (Game (GameType Stellaris)))
	(printout t "Play Stellaris." crlf))


(defrule CIV
	(Price (GamePrice yes))
	(Coop (GameCoop yes | no))
	(Plot (GamePlot no))
	(Action (GameAction no))
	(CreateOrShoot (GameCreateOrShoot yes))
=>
(assert (Game (GameType CIV)))
	(printout t "Play Sid Meier's Civilization V." crlf))	

	
(defrule Wolf
	(Price (GamePrice yes))
	(Coop (GameCoop no))
	(Plot (GamePlot yes))
	(Action (GameAction no))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType Wolf)))
	(printout t "Play The Wolf Among Us." crlf))
	
	
(defrule DOTA
	(Price (GamePrice no))
	(Coop (GameCoop yes))
	(Plot (GamePlot no))
	(Action (GameAction yes))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType DOTA)))
	(printout t "Play DOTA 2." crlf))
	
	
(defrule Minecraft
	(Price (GamePrice yes))
	(Coop (GameCoop yes))
	(Plot (GamePlot no))
	(Action (GameAction no))
	(CreateOrShoot (GameCreateOrShoot yes))
=>
(assert (Game (GameType Minecraft)))
	(printout t "Play Minecraft." crlf))
	
	
(defrule Tropico
	(Price (GamePrice yes))
	(Coop (GameCoop no))
	(Plot (GamePlot no))
	(Action (GameAction no))
	(CreateOrShoot (GameCreateOrShoot yes))
=>
(assert (Game (GameType Tropico)))
	(printout t "Play Tropico 5." crlf))
	
	
(defrule Witcher
	(Price (GamePrice yes))
	(Coop (GameCoop no))
	(Plot (GamePlot yes))
	(Action (GameAction yes | no))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType Witcher)))
	(printout t "Play The Witcher 3." crlf))
	
	
(defrule OMD
	(Price (GamePrice yes))
	(Coop (GameCoop yes | no))
	(Plot (GamePlot no))
	(Action (GameAction yes))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType OMD)))
	(printout t "Play Orcs Must Die 2." crlf))
	
(defrule SC2
	(Price (GamePrice yes))
	(Coop (GameCoop yes | no))
	(Plot (GamePlot no | yes))
	(Action (GameAction no))
	(CreateOrShoot (GameCreateOrShoot yes))
=>
(assert (Game (GameType SC2)))
	(printout t "Play StarCraft 2." crlf))
	
	
(defrule PR2
	(Price (GamePrice yes))
	(Coop (GameCoop no))
	(Plot (GamePlot no | yes))
	(Action (GameAction no))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType PR2)))
	(printout t "Play Port Royale 2." crlf))
	
	
(defrule ES
	(Price (GamePrice no))
	(Coop (GameCoop no))
	(Plot (GamePlot yes))
	(Action (GameAction no))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType ES)))
	(printout t "Play Everlasting Summer." crlf))
	
	
(defrule FC3
	(Price (GamePrice yes))
	(Coop (GameCoop no | yes))
	(Plot (GamePlot yes | no))
	(Action (GameAction yes))
	(CreateOrShoot (GameCreateOrShoot yes))
=>
(assert (Game (GameType FC3)))
	(printout t "Play Far Cry games." crlf))
	
	
(defrule Limbo
	(Price (GamePrice yes))
	(Coop (GameCoop no))
	(Plot (GamePlot yes | no))
	(Action (GameAction yes))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType Limbo)))
	(printout t "Play Limbo." crlf))
	
(defrule Isaac
	(Price (GamePrice yes))
	(Coop (GameCoop no))
	(Plot (GamePlot no))
	(Action (GameAction yes))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType Isaac)))
	(printout t "Play The Binding Of Isaac." crlf))
	
(defrule RFTS
	(Price (GamePrice no))
	(Coop (GameCoop no))
	(Plot (GamePlot no))
	(Action (GameAction yes))
	(CreateOrShoot (GameCreateOrShoot no))
=>
(assert (Game (GameType RFTS)))
	(printout t "Play Race The Sun." crlf))
	

(defrule input
=>
	(printout t "Pay for the game (yes, no)?" crlf)
	(bind ?answer (read))
	(while (and (neq ?answer yes) (neq ?answer no)) do
		(printout t "Invalid input, enter yes or no." )
		(bind ?answer (read)))

	(assert (Price (GamePrice ?answer)))

	(printout t "Do you want to play with another people (yes, no)?" crlf)
	(bind ?answer (read))
	(while (and (neq ?answer yes) (neq ?answer no)) do
		(printout t "Invalid input, enter yes or no." )
		(bind ?answer (read)))
	(assert (Coop (GameCoop ?answer)))
	

	
	(printout t "Do you need an interesting plot in the game (yes, no)?" crlf)
	(bind ?answer (read))
	(while (and (neq ?answer yes) (neq ?answer no)) do
		(printout t "Invalid input, enter yes or no." )
		(bind ?answer (read)))
	(assert (Plot (GamePlot ?answer)))
	
	(printout t "Do you want to challenge yourself(yes, no)" crlf)
	(bind ?answer (read))
	(while (and (neq ?answer yes) (neq ?answer no)) do
		(printout t "Invalid input, enter yes or no." )
		(bind ?answer (read)))
	(assert (Action (GameAction ?answer)))
	
	(if (eq ?answer yes)
	then (printout t "Do you want to shoot (yes, no)?" crlf)
	else (printout t "Do you want to create (yes, no)?" crlf))
	
	(bind ?answer (read))
	(while (and (neq ?answer yes) (neq ?answer no)) do
		(printout t "Invalid input, enter yes or no." )
		(bind ?answer (read)))
	(assert (CreateOrShoot (GameCreateOrShoot ?answer))))
```
# Пример работы:
```CLIPS	
CLIPS> (facts) f-1     (Price (GamePrice yes))
f-2     (Coop (GameCoop yes))
f-3     (Plot (GamePlot no))
f-4     (Action (GameAction yes))
f-5     (CreateOrShoot (GameCreateOrShoot no))
f-6     (Game (GameType GTAV))
f-7     (Game (GameType OverWatch))
f-8     (Game (GameType WOW))
f-9     (Game (GameType OMD))
For a total of 9 facts.

Pay for the game (yes, no)?
yes
Do you want to play with another people (yes, no)?
yes
Do you need an interesting plot in the game (yes, no)?
no
Do you want to challenge yourself(yes, no)
yes
Do you want to shoot (yes, no)?
no
Play GTA V.
Play OverWatch.
Play World of Warcraft.
Play Orcs Must Die 2.
```
