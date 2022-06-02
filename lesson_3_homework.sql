--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

with product_a as (
	select classes.class,
	case 
	when result = 'sunk' then 1 
	else 0 
	end flag
	from classes
	left join ships on classes.class = ships.class
	left join outcomes on ships.name = outcomes.ship
)
select class, sum(flag)
from product_a
group by class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, 
--определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

with query_1 as (
	select t1.class,
		case 
		when t1.class = t1.name then launched
		when launched is null then t2.min
		end first_launched_date
	from (select classes.class, ships.name, launched
		  from classes
		  left join ships on classes.class = ships.class) t1
	join (select classes.class, min(launched) 
	      from ships
	      right join classes on classes.class = ships.class
	      group by classes.class) t2
	on t1.class = t2.class
)
select *
from query_1
where first_launched_date is not null

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

with query_1 as (
	select class, sum(flag), count(name) 
	from (select classes.class, ships.name,
		  case 
		  when result = 'sunk' then 1 
		  else 0 
		  end flag
		  from classes
		  left join ships on classes.class = ships.class
		  left join outcomes on ships.name = outcomes.ship) foo
	group by class
)
select class, sum 
from query_1
where sum != 0 and count >= 3

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

with query_1 as (
	select *
	from (select ship
	      from outcomes
	      union
	      select name
	      from ships) foo_1
	left join ships on ship = name
	left join classes on classes.class = ships.class
)
select ship
from query_1
join (select displacement, max(numguns) 
      from query_1
      where displacement is not null
	  group by displacement) as foo_2 
on query_1.displacement = foo_2.displacement
where query_1.displacement = foo_2.displacement
and query_1.numguns = foo_2.max

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

with query_1 as (
	select maker, product.type, pc.speed, pc.ram
	from product
	left join printer on product.model = printer.model
	left join pc on product.model = pc.model
)
select distinct(query_1.maker)
from query_1
join (select * 
      from query_1
      where type = 'PC'
      and ram = (select min(ram) from pc)
      and speed = (select max(speed) from pc where ram = (select min(ram) from pc))) as foo 
on query_1.maker = foo.maker
where query_1.type = 'Printer'
