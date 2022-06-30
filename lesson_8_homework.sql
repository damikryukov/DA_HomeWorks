--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

select Department.name as Department, foo.name as Employee, foo.salary as Salary
from (
	select departmentId, name, salary,
	dense_rank() over (partition by departmentId order by salary desc) as drn
	from Employee
) foo
join Department on foo.departmentId = Department.id
where drn <= 3

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

select member_name, status, SUM(amount * unit_price) as costs
from FamilyMembers
join Payments on FamilyMembers.member_id = Payments.family_member
where YEAR(Payments.date) = 2005
group by member_name, status

--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

select name 
from (
    select *,
    rank() over (partition by name order by id) as rnk
    from Passenger
) foo
where rnk >= 2

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(*) as count
from Student
where first_name = 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

select count(distinct (classroom)) as count
from Schedule
where DATE_FORMAT(date, '%d.%m.%Y') = '02.09.2019'

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(*) as count
from Student
where first_name = 'Anna'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

select ROUND(AVG((CAST(CURRENT_DATE() as date) - CAST(birthday as date)) / 10000),0) as age
from FamilyMembers

--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

select good_type_name, SUM(amount * unit_price) as costs
from GoodTypes
join Goods on GoodTypes.good_type_id = Goods.type 
join Payments on Goods.good_id = Payments.good
where YEAR(Payments.date) = 2005
group by good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select FLOOR(MIN((CAST(CURRENT_DATE() as date) - CAST(birthday as date)) / 10000)) as year
from Student

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

select FLOOR(MAX((CAST(CURRENT_DATE() as date) - CAST(birthday as date)) / 10000)) as max_year
from Student
join Student_in_class on Student.id = Student_in_class.student 
join Class on Student_in_class.class = Class.id
where Class.name LIKE '10%'

--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

select status, member_name, SUM(amount * unit_price) as costs
from FamilyMembers
join Payments on FamilyMembers.member_id = Payments.family_member
join Goods on Payments.good = Goods.good_id
join GoodTypes on Goods.type = GoodTypes.good_type_id
where GoodTypes.good_type_name = 'entertainment'
group by status, member_name

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

delete
from Company
where id in (
    select company
    from (
        select *,
        dense_rank() over (order by max_trip) as min_trip
        from (
            select company, MAX(rn_max) as max_trip
            from (
                select company, row_number() over (partition by company order by id) as rn_max
                from Trip
            ) foo_1
            group by company
        ) foo_2
    ) foo_3
    where min_trip = 1
)

--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

select classroom
from (
    select *,
    dense_rank() over (order by max_count desc) as most_popular
    from (
        select classroom, MAX(rn) as max_count
        from (
            select classroom, row_number() over (partition by classroom order by id) as rn
            from Schedule
        ) foo_1
        group by classroom
    ) foo_2
) foo_3
where most_popular = 1

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

select Teacher.last_name 
from Subject
join Schedule on Subject.id = Schedule.subject
join Teacher on Schedule.teacher = Teacher.id
where Subject.name = 'Physical Culture'
order by Teacher.last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

select concat(last_name, '.', SUBSTRING(first_name, 1, 1), '.', SUBSTRING(middle_name , 1, 1), '.') as name
from Student
order by name 
