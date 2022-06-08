--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300 as
with query_1 as (
	select model, price
	from pc
	union all  
	select model, price 
	from laptop
	union all
	select model, price 
	from printer
)
select model, price,
case
	when price > 300 then 1
	else 0
end flag
from query_1

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as
with query_1 as (
	select model, price
	from pc
	union all  
	select model, price 
	from laptop
	union all
	select model, price 
	from printer
)
select model, price,
case
	when price > (select avg(price) from query_1) then 1
	else 0
end flag
from query_1

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with query_1 as (
	select maker, product.model, price 
	from printer
	join product on product.model = printer.model
)
select model
from query_1
where maker = 'A'
and price > (select avg(price) 
             from query_1
             where maker = 'C'
             or maker = 'D')

--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model
             
with query_1 as (
	select model, price
	from pc
	union all  
	select model, price 
	from laptop
	union all
	select model, price 
	from printer
)
select product.model, price
from query_1
join product on product.model = query_1.model
where maker = 'A'
and price > (select avg(price) 
             from query_1
             join product on product.model = query_1.model
             where maker = 'C' or maker = 'D'
             and type = 'printer')

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
             
with query_1 as (
	select model, price
	from pc
	union  
	select model, price 
	from laptop
	union
	select model, price 
	from printer
)
select avg(price)
from query_1
join product on product.model = query_1.model
where maker = 'A'

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as
with query_1 as (
	select model, price
	from pc
	union all
	select model, price 
	from laptop
	union all
	select model, price 
	from printer
)
select maker, count(type)
from query_1
join product on product.model = query_1.model
group by maker

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

https://colab.research.google.com/drive/1Z1E8HPtVvPvv9RuyGSptVdwFWRVRlJWo#scrollTo=1aETfy2dlPFZ

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as
select code, printer.model, color, printer.type, price
from printer
join product on product.model = printer.model
where maker != 'D'

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as
select code, printer_updated.model, color, printer_updated.type, price, maker
from printer_updated
join product on product.model = printer_updated.model

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create view sunk_ships_by_classes as
with query_1 as (
	select ship,
	case
		when class is null then '0'
		else class
	end
	from outcomes
	left join ships on outcomes.ship = ships.name
	where result = 'sunk'
)
select class, count(ship)
from query_1
group by class

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

https://colab.research.google.com/drive/1Z1E8HPtVvPvv9RuyGSptVdwFWRVRlJWo#scrollTo=aULFMBy2Q-7F

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as
select *,
	case
		when numguns >= 9 then 1
		else 0
	end
from classes

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

https://colab.research.google.com/drive/1Z1E8HPtVvPvv9RuyGSptVdwFWRVRlJWo#scrollTo=82ZMwKPvmN9A

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select count(*) 
from ships
where name like 'O%' or name like 'M%'

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(*) 
from ships
where name like '% %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

https://colab.research.google.com/drive/1Z1E8HPtVvPvv9RuyGSptVdwFWRVRlJWo#scrollTo=FrmK6ly2xfaN
