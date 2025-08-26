
-- 1. Find the names of all students who are friends with someone named Gabriel.
select h1.name
from friend f, highschooler h1, highschooler h2
where f.id1 = h1.id and f.id2 = h2.id and h2.name = 'Gabriel';

-- 2. For every student who likes someone 2 or more grades younger than themselves, 
--    return that student's name and grade, and the name and grade of the student they like.
select h1.name, h1.grade, h2.name, h2.grade
from likes l, highschooler h1, highschooler h2
where l.id1 = h1.id and l.id2 = h2.id and (h1.grade - h2.grade) >= 2;

-- 3. For every pair of students who both like each other, return the name and grade of both students.
--    Include each pair only once, with the two names in alphabetical order.
select h1.name, h1.grade, h2.name, h2.grade
from likes l, highschooler h1, highschooler h2
where l.id1 = h1.id and l.id2 = h2.id 
and l.id1 in (select id2 from likes) and l.id2 in (select id1 from likes)
and h1.name < h2.name;

-- 4. Find all students who do not appear in the Likes table (as a student who likes or is liked) 
--    and return their names and grades. Sort by grade, then by name within each grade.
select name, grade
from highschooler
where id not in (select id1 from likes union select id2 from likes)
order by grade, name;
-- alternative
select name, grade
from highschooler
where id not in (select id1 from likes) and id not in (select id2 from likes)
order by grade, name;

-- 5. For every situation where student A likes student B, but we have no information about whom B likes
--    (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
select h1.name, h1.grade, h2.name, h2.grade
from likes, highschooler h1, highschooler h2
where id2 not in (select id1 from likes) and id1 = h1.id and id2 = h2.id;

-- 6. Find names and grades of students who only have friends in the same grade. 
--    Return the result sorted by grade, then by name within each grade.
select n1, g1
from (select h1.id as id1, h1.name as n1, h1.grade as g1, h2.grade as g2
	  from friend, highschooler h1, highschooler h2
	  where id1 = h1.id and id2 = h2.id 
	  group by h1.id, h2.grade)
group by id1
having g1 = g2 and count(id1) = 1
order by g1, n1;
-- alternative
select name, grade
from highschooler
where id not in (select h1.id
				 from friend, highschooler h1, highschooler h2
				 where h1.id = id1 and h2.id = id2 and h1.grade <> h2.grade)
order by grade, name;

-- 7. For each student A who likes a student B where the two are not friends, 
--    find if they have a friend C in common (who can introduce them!). 
--    For all such trios, return the name and grade of A, B, and C.
select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from likes, friend, highschooler h1, highschooler h2, highschooler h3
where (likes.id1, likes.id2) not in (select id1, id2 from friend) -- select pairs that id1 likes id2 but are not friends
and friend.id1 = likes.id1 
and friend.id2 in (select id2 from friend where likes.id2 = id1)  -- friends of likes.id1 that are also friends of likes.id2
and h1.id = likes.id1 and h2.id = likes.id2 and h3.id = friend.id2; -- get each student info

-- 8. Find the difference between the number of students in the school and the number of different first names.
select count(id) - count(distinct name) from highschooler;

-- 9. Find the name and grade of all students who are liked by more than one other student.
select h.name, h.grade
from likes, highschooler h
where h.id = id2
group by id2
having count(id1) > 1;