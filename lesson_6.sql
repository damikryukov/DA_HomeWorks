--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index как объединение всех данных по ключу code (union all). Сделать индекс по полю type

create table all_products_with_index as
with query_1 as (
	select code, model, price
	from pc
	union all
	select code, model, price 
	from laptop
	union all
	select code, model, price 
	from printer
)
select code, product.model, maker, type, price
from query_1
join product on product.model = query_1.model

create index type_idx on all_products_with_index (type)

--task2  (lesson6)
--Компьютерная фирма: Вывести список всех уникальных PC и производителя с ценой выше хотя бы одного принтера. Вывод: model, maker

select pc.model, maker
from pc
join product on product.model = pc.model
where price > any(select price from printer)

--task3  (lesson6)
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

with query_1 as (
      select foo.model, price
      from (
		select model, price
	    from pc
	    union all  
	    select model, price 
	    from laptop
	    union all
	    select model, price 
	    from printer) as foo
      join product on product.model = foo.model
)
select model
from query_1
where price = (select max(price) from query_1)

--task4  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task4 как объединение всех данных по ключу code (union all) и сделать флаг (flag) по цене > максимальной по принтеру. Сделать индекс по flag

create table all_products_with_index_task4 as
with query_1 as (
	select code, model, price
	from pc
	union all
	select code, model, price 
	from laptop
	union all
	select code, model, price 
	from printer
)
select code, product.model, maker, type, price,
case  
	when price > (select max(price) from printer) then 1 
	else 0 
end flag
from query_1
join product on product.model = query_1.model

create index flag_idx on all_products_with_index_task4 (flag)

--task5  (lesson6)
-- Компьютерная фирма: Создать таблицу all_products_with_index_task5 как объединение всех данных по ключу code (union all) и сделать флаг (flag) по цене > максимальной по принтеру. 
-- Также добавить нумерацию (через оконные функции) по каждой категории продукта в порядке возрастания цены (price_index). По этому price_index сделать индекс

create table all_products_with_index_task5 as
with query_1 as (
	select code, model, price
	from pc
	union all
	select code, model, price 
	from laptop
	union all
	select code, model, price 
	from printer
)
select code, product.model, maker, type, price,
row_number() over (partition by type order by price) as price_index,
case  
	when price > (select max(price) from printer) then 1 
	else 0 
end flag
from query_1
join product on product.model = query_1.model

create index flag_idx2 on all_products_with_index_task5 (price_index)
