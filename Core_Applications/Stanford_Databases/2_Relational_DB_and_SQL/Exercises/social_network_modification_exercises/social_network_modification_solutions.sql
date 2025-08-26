
-- 1. It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
delete from highschooler where grade = 12;

-- 2. If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
delete from likes as l1
where (id1, id2) in (select id1, id2 from friend)
and l1.id1 not in (select l2.id2 from likes l2 where l2.id1 = l1.id2);

-- 3. For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. 
--    Do not add duplicate friendships, friendships that already exist, or friendships with oneself. 
--    (This one is a bit challenging; congratulations if you get it right.)
insert into friend
select distinct f1.id1, f2.id2       -- select unique pairs
from friend f1, friend f2
where f1.id2 = f2.id1 and f1.id1 <> f2.id2  -- join f1 and f2 using (f1.id2 as f2.id1) and keep only friends of B that are not A
and (f1.id1, f2.id2) not in (select id1, id2 from friend); -- keep only pairings that not exist already in friends

