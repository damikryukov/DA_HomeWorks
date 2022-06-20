--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

https://colab.research.google.com/drive/1oYFY-FAlFbIMG8NpCpe2u2CrhhBusyJn#scrollTo=exTkKn1ImCgw

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select email
from(
    select email, count(*) as c
    from Person
    group by email
    )
where c >= 2

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

select Emp_1.name as Employee
from Employee Emp_1, Employee Emp_2
where Emp_1.managerId = Emp_2.id 
and Emp_1.salary > Emp_2.salary

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

select score, dense_rank() over (order by score desc) as rank
from scores

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select firstName, lastName, city, state
from person
left join address on address.personId = person.personId