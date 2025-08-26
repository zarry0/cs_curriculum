
-- 1. For every situation where student A likes student B, but student B likes a different student C, 
--    return the names and grades of A, B, and C.
select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from likes l1, likes l3, highschooler h1, highschooler h2, highschooler h3
where l1.id1 not in (select l2.id2 from likes l2 where l2.id1 = l1.id2) -- people who like someone who doesn't reciprocate
and l1.id2 = l3.id1  -- select the person that l1.id2 likes
and l1.id1 = h1.id and l1.id2 = h2.id and l3.id2 = h3.id; -- get student's info

-- 2. Find those students for whom all of their friends are in different grades from themselves.
--    Return the students' names and grades.
select distinct h1.name, h1.grade
from friend, highschooler h1
where id1 = h1.id 
and h1.grade not in (select grade 
                     from friend, highschooler h2 
                     where h1.id = id1 and id2 = h2.id);

-- 3. What is the average number of friends per student? (Your result should be just one number.)
select avg(cnt) from (select count(id1) cnt from friend group by id1);

-- 4. Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra.
--    Do not count Cassandra, even though technically she is a friend of a friend.
select count(id2)
from (select id2
      from friend, highschooler h1
      where h1.id = id1 and h1.name = 'Cassandra'
      union
      select id2
      from friend, highschooler h2
      where id1 in (select id2 from friend, highschooler h1 where h1.id = id1 and h1.name = 'Cassandra')
      and h2.id = id2 and h2.name <> 'Cassandra');

-- 5. Find the name and grade of the student(s) with the greatest number of friends.
select name, grade
from highschooler h, (select id1, count(id1) as cnt from friend group by id1)
where h.id = id1 
and cnt = (select max(cnt) from (select id1, count(id1) as cnt from friend group by id1));


