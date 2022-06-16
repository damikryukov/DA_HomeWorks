--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

sample:
1 1
2 1
1 2
2 2
1 3
2 3

create view pages_all_products as
with query_1 as (
      select maker, product.model, type,
      case
		when code % 2 = 0 then 1
		else 2
      end prod_number
      from (
		select code, model, price
	    from pc
	    union all  
	    select code, model, price 
	    from laptop
	    union all
	    select code, model, price 
	    from printer) as foo
      join product on product.model = foo.model
)
select *,
row_number() over (partition by  prod_number) as page_number
from query_1
order by page_number, prod_number

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)

create view distribution_by_type as
with query_1 as (
      select *,
      row_number() over (partition by maker order by type) as rn
      from (
		select model
	    from pc
	    union all  
	    select model 
	    from laptop
	    union all
	    select model 
	    from printer) as foo
      join product on product.model = foo.model
)
select query_1.maker, type, (count(*)*100/max(all_prod)) as percent
from query_1
join (select maker, max(rn) as all_prod from query_1 group by maker) as foo on query_1.maker = foo.maker
group by query_1.maker, type
order by maker

--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/

https://colab.research.google.com/drive/1nokPnultSBCDVsvmn5WYEnVUBGPx6Dpj#scrollTo=1aETfy2dlPFZ

--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов

create table ships_two_words as
select *
from ships
where name like '% %'

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select *
from ships
where class is null
and name like 'S%'

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model

with query_1 as (
	select maker, product.model, price,
	rank() over (partition by maker order by price desc) as rnk
	from printer
	join product on product.model = printer.model
)
select model
from query_1
where maker = 'A'
and price > (select avg(price) 
             from query_1
             where maker = 'C')
and rnk <= 3
