--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson5)
-- Компьютерная фирма: Вывести список самых дешевых принтеров по каждому типу (type)

select *
from (select *, 
      row_number() over (partition by type order by price) as rn
      from printer) as foo
where rn = 1

--task2  (lesson5)
-- Компьютерная фирма: Вывести список самых дешевых PC по каждому типу скорости

select *
from (select *, 
      row_number() over (partition by speed order by price) as rn
      from pc) as foo
where rn = 1

--task3  (lesson5)
-- Компьютерная фирма: Найти производителей, которые производят более 2-х моделей PC (через RANK, не having).

select *
from (select *, 
      rank() over (partition by maker order by model) as rnk
      from product
      where type = 'PC') as foo
where rnk > 2

--task4 (lesson5)
-- Компьютерная фирма: Вывести список самых дешевых PC по каждому производителю. Вывод: maker, code, price

select maker, code, price
from (select *, 
      rank() over (partition by maker order by price) as rnk
      from product
      join pc on product.model = pc.model
      where type = 'PC') as foo
where rnk = 1

--task5 (lesson5)
-- Компьютерная фирма: Создать view (all_products_050521), в рамках которого будет только 2 самых дорогих товаров по каждому производителю

create view all_products_050521 as
select maker, model, type 
from (select maker, product.model, type, 
      rank() over (partition by maker order by price desc) as rnk
      from (
		select model, price
	    from pc
	    union all  
	    select model, price 
	    from laptop
	    union all
	    select model, price 
	    from printer) as foo_1
      join product on product.model = foo_1.model) as foo_2
where rnk = 1 or rnk = 2

--task6 (lesson5)
-- Компьютерная фирма: Сделать график со средней ценой по всем товарам по каждому производителю (X: maker, Y: avg_price) на базе view all_products_050521

https://colab.research.google.com/drive/16WGl1318b9F9vhG08kr0pjHkV9zE7mFp#scrollTo=1aETfy2dlPFZ

--task7 (lesson5)
-- Компьютерная фирма: Для каждого принтера из таблицы printer найти разность между его ценой и минимальной ценой на модели с таким же значением типа (type, в долях)

-- Мое решение
select code, model, color, printer.type, price,
case
	when price = min_price then 0
	else price - min_price
end diff
from (
	with query_1 as (
		select *,
		rank() over (partition by type order by price) as rnk
		from printer
	)
	select type, price as min_price
	from query_1
	where rnk = 1
) as foo
join printer on foo.type = printer.type

-- Решение Марата
select *,
price - min(price) over (partition by type) as diff
from printer

--task8 (lesson5)
-- Компьютерная фирма: Для каждого принтера из таблицы printer найти разность между его ценой и минимальной ценой на модели с таким же значением color (type, в долях)

select *,
price - min(price) over (partition by color) as diff
from printer

--task9 (lesson5)
-- Компьютерная фирма: Для каждого laptop  из таблицы laptop вывести три самых дорогих устройства (через оконные функции).

select*
from(
	select *,
	dense_rank () over (order by price desc) as drnk
	from laptop
) as foo
where drnk <= 3

--task10 (lesson5)
-- Компьютерная фирма: Для каждого производителя вывести по три самых дешевых устройства в отдельное view (products_with_lowest_price).

create view products_with_lowest_price as
select maker, model, type, price
from (select maker, product.model, type, price,
      rank() over (partition by maker order by price) as rnk
      from (
		select model, price
	    from pc
	    union  
	    select model, price 
	    from laptop
	    union
	    select model, price 
	    from printer) as foo_1
      join product on product.model = foo_1.model) as foo_2
where rnk <= 3

--task11 (lesson5)
-- Компьютерная фирма: Построить график с со средней и максимальной ценами на базе products_with_lowest_price (X: maker, Y1: max_price, Y2: avg)price

https://colab.research.google.com/drive/16WGl1318b9F9vhG08kr0pjHkV9zE7mFp#scrollTo=aULFMBy2Q-7F