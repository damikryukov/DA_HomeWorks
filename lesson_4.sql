--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson4)
-- Корабли: Вывести список кораблей, у которых начинается с буквы "S"

select name
from ships
where name like 'S%'

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название: pc_with_flag_speed_price) над таблицей PC c флагом: flag = 1 для тех, у кого speed > 500 и price < 900, для остальных flag = 0

create view pc_with_flag_speed_price as
select *,
case
	when speed > 500 and price < 900 then 1
	else 0
end flag
from pc

--task3  (lesson4)
-- Компьютерная фирма: Сделать view (название: pc_maker_a) со всеми товарами производителя A. В view должны быть следующие колонки: model, price

create view all_maker_a as
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

select * 
from all_maker_a

--task4 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы laptop (название: laptop_under_1000) и удалить из нее все товары с ценой выше 1000.

create table laptop_under_1000 as
select *
from laptop
where price <= 1000

--task5 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы (название: all_products) со средней стоимостью всех продуктов, с максимальной ценой и количеством по каждому производителю. (дубликаты можно учитывать).

create table all_products as
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
select maker, avg(price), max(price), count(price)
from query_1
join product on product.model = query_1.model
group by maker

--task6 (lesson4)
-- Компьютерная фирма: Построить по all_products график в colab/jupyter (X: maker, Y: средняя цена)

https://colab.research.google.com/drive/1mtAHy7v_YuLA1XFb7qI0Jg9RkaK07PY0#scrollTo=1aETfy2dlPFZ

--task7 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы (название: all_products) со средней стоимостью всех продуктов, с максимальной ценой продукта и количеством продуктов по каждому производителю. (дубликаты можно учитывать).

--task8 (lesson4)
-- Компьютерная фирма: Сделать view (название products_price_categories), в котором по всем продуктам нужно посчитать количество продуктов всего в зависимости от цены:
-- Если цена > 1000, то category_price = 2
-- Если цена < 1000 и цена > 500, то  category_price = 1
-- иначе category_price = 0
-- Вывести: category_price, count

create view products_price_categories as
with all_products as (
	select model, price
	from pc
	union all  
	select model, price 
	from laptop
	union all
	select model, price 
	from printer
)
select count(*),
case
	when price > 1000 then 2
	when price < 1000 and price >= 500 then 1
	else 0
end category_price
from all_products
join product on product.model = all_products.model
group by category_price

--task9 (lesson4)
-- Сделать предыдущее задание, но дополнительно разбить еще по производителям (название products_price_categories_with_makers). Вывести: category_price, count, price

create view products_price_categories_with_makers as
with all_products as (
	select model, price
	from pc
	union all  
	select model, price 
	from laptop
	union all
	select model, price 
	from printer
)
select maker, count(price),
case
	when price > 1000 then 2
	when price < 1000 and price >= 500 then 1
	else 0
end category_price
from all_products
join product on product.model = all_products.model
group by category_price, maker

--task10 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по каждому производителю график (X: category_price, Y: count)

https://colab.research.google.com/drive/1mtAHy7v_YuLA1XFb7qI0Jg9RkaK07PY0#scrollTo=aULFMBy2Q-7F

--task11 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по A & D график (X: category_price, Y: count)

https://colab.research.google.com/drive/1mtAHy7v_YuLA1XFb7qI0Jg9RkaK07PY0#scrollTo=7Zcf01P6N1Ql

--task12 (lesson4)
-- Корабли: Сделать копию таблицы ships, но у название корабля не должно начинаться с буквы N (ships_without_n)

create table ships_without_n as
select *
from ships
where name not like 'N%'
