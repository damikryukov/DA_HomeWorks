--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing


--task1
--Компьютерная фирма: Найдите среднюю цену всех устройств, сгруппированую по производителям.
--Вывод: цена, производитель

with product_a as (
	select maker, price
	from pc
	join product on product.model = pc.model
	union all  
	select maker, price 
	from laptop
	join product on product.model = laptop.model
	union all
	select maker, price 
	from printer
	join product on product.model = printer.model
)
select maker, avg(price) 
from product_a
group by maker

--task2
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL).

select *
from ships
where class is null

--task3
--Компьютерная фирма: Найти поставщиков/производителей компьютеров, моделей которых нет в продаже (то есть модели этих поставщиков отсутствуют в таблице PC)

with product_a as 
(
	select * 
	from product
	left join pc on product.model = pc.model
	where type = 'PC'
)
select distinct(maker) 
from product_a
where code is null

with model_pc_exists as (
  select distinct model 
  from pc
)
select distinct maker 
from product 
where model not in (select model from model_pc_exists)

--task4
--Компьютерная фирма: Найти модели и цены портативных компьютеров, стоимость которых превышает стоимость любого ПК

select model, price 
from laptop  
where price > any (select price from pc)

select model, price 
from laptop  
where price > (select min(price) from pc)

--task5 +++
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

with product_a as (
	select model, price 
	from pc
	union all  
	select model, price 
	from laptop 
	union all
	select model, price 
	from printer
)
select model
from product_a
where price = (select max(price) from product_a)

--task6
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена больше 300 - "1", у остальных - "0"

select *, 
case 
when price > 300 then 1 
else 0 
end flag
from printer

--task7
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней - "1", у остальных - "0"

select *, 
case 
when price > (select avg(price) from printer) then 1 
else 0 
end flag
from printer

--task9
--Компьютерная фирма: Вывести список всех уникальных PC и производителя с ценой выше хотя бы одного принтера. Вывод: model, maker

select distinct (product.model), maker 
from pc
join product on product.model = pc.model
where price > any (select price from printer)

--task10
--Компьютерная фирма: Вывести список всех уникальных продуктов и производителя в рамках БД. Вывести model, maker

with product_a as (
	select pc.model, maker
	from pc
	join product on product.model = pc.model
	union all  
	select laptop.model, maker 
	from laptop
	join product on product.model = laptop.model
	union all
	select printer.model, maker
	from printer
	join product on product.model = printer.model
	union all
	select model, maker
	from product
)
select distinct (model), maker
from product_a

--task11
--Корабли: Вывести список всех кораблей и класс. Для тех у кого нет класса - вывести 0, для остальных - class

with product_a as (
	select name, class
	from ships
	union all
	select ship, class
	from outcomes
	left join ships on outcomes.ship = ships.name
	where class is null
)
select name,
case 
when class is null then '0' 
else class
end
from product_a

--task12
--Корабли: Для каждого класса определить год, когда был спущен на воду первый корабль этого класса. Вывести: класс, год

select classes.class, min(launched)
from ships
right join classes on classes.class = ships.class
group by classes.class

--task13
--Компьютерная фирма: Вывести список всех продуктов и происзводителя с указанием типа продукта (pc, printer, laptpo). Вывести: model, maker, type

select model, maker, type 
from product

--task14
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *, 
case 
when price > (select avg(price) from pc) then 1 
else 0 
end flag
from printer

--task15
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

with product_a as (
	select name, class
	from ships
	union
	select ship, class
	from outcomes
	left join ships on outcomes.ship = ships.name
)
select name
from product_a
where class is null

--task16
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. (через with)

with product_a as (
	select battles.name, ship, date_part('year', date) as date_battle
	from battles
	left join outcomes on outcomes.battle = battles.name
	left join ships on ships.name = outcomes.ship
)
select product_a.name
from product_a
left join ships on ships.launched = product_a.date_battle
where launched is null

--task17
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select battle
from ships
join outcomes on outcomes.ship = ships.name
where class = 'Kongo'