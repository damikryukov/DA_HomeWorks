--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select 
   case 
      when Grades.Grade > 7 then Students.Name 
      else 'NULL' 
   end as Name_Null
    , Grades.Grade
    , Students.Marks
from Students
join Grades on Students.Marks between Grades.Min_Mark and Grades.Max_Mark
order by Grades.Grade desc, Name_Null asc, Students.Marks asc;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

select min(Doctor), min(Professor), min(Singer), min(Actor)
from (
    Select  
    rank() over (partition by occupation order by name) as rnk,
    case 
        when occupation = 'Doctor' then name 
    end as Doctor,
    case 
        when occupation = 'Professor' then name 
    end as Professor,
    case 
        when occupation = 'Singer' then name 
    end as Singer,
    case 
        when occupation = 'Actor' then name 
    end as Actor
from occupations) foo
group by rnk
order by rnk;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city
from station
where not (city like 'A%' or  city  like 'E%' or city  like 'I%' or city  like 'O%' or city  like 'U%');

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city
from station
where not (city like '%a' or  city  like '%e' or city  like '%i' or city  like '%o' or city  like '%u');

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct city
from station
where regexp_like(City, '^[^AEIOU]|[^aeiou]$');

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct city
from station
where regexp_like(City, '^[^AEIOU].*[^aeiou]$');

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name
from Employee
where salary > 2000
and months < 10;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select 
   case 
      when Grades.Grade > 7 then Students.Name 
      else 'NULL' 
   end as Name_Null
    , Grades.Grade
    , Students.Marks
from Students
join Grades on Students.Marks between Grades.Min_Mark and Grades.Max_Mark
order by Grades.Grade desc, Name_Null asc, Students.Marks asc;