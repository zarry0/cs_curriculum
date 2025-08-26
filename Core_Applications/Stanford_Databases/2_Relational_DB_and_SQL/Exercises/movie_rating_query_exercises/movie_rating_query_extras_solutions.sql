
-- 1. Find the names of all reviewers who rated Gone with the Wind.
select distinct name
from rating join reviewer using (rid)
where mid in (select mid from movie where title = 'Gone with the Wind');

-- 2. For any rating where the reviewer is the same as the director of the movie, 
--    return the reviewer name, movie title, and number of stars.
select name, title, stars
from rating join movie using(mid)
	 join reviewer using(rid)
where director = name;

-- 3. Return all reviewer names and movie names together in a single list, alphabetized. 
--    (Sorting by the first name of the reviewer and first word in the title is fine; 
--     no need for special processing on last names or removing "The".)
select name as names
from reviewer
union
select title as names
from movie
order by names;

-- 4. Find the titles of all movies not reviewed by Chris Jackson.
select title
from movie
except
select title
from rating join movie using(mid)
where rid = (select rid from reviewer where name = 'Chris Jackson');

-- 5. For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
--    Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
--    For each pair, return the names in the pair in alphabetical order.
select distinct r1.name, r2.name
from (rating join reviewer using(rid)) r1
	 join
     (rating join reviewer using(rid)) r2
     using(mid)
where r1.name < r2.name
order by r1.name, r2.name;

-- 6. For each rating that is the lowest (fewest stars) currently in the database, 
--    return the reviewer name, movie title, and number of stars.
select name, title, stars
from rating join  reviewer using(rid)
	 join movie using(mid)
where stars = (select min(stars) from rating);

-- 7. List movie titles and average ratings, from highest-rated to lowest-rated.
--    If two or more movies have the same average rating, list them in alphabetical order.
select title, avg(stars) as rating
from rating join movie using(mid)
group by mid
order by rating desc, title;

-- 8. Find the names of all reviewers who have contributed three or more ratings. 
--    (As an extra challenge, try writing the query without HAVING or without COUNT.)
-- Solution with having and count
select name
from rating join reviewer using(rid)
group by rid
having count(rid) >= 3;
-- Solution without having nor count
select name
from (select rid, name, sum(rid)/rid as cnt
	  from rating join reviewer using(rid)
	  group by rid)
where cnt >= 3;

-- 9. Some directors directed more than one movie. 
--    For all such directors, return the titles of all movies directed by them, along with the director name. 
--    Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)
-- With count
select title, director
from movie
where director in (select director from movie group by director having count(director) > 1)
order by director, title;
-- Without count
select title, director
from movie
where director in (select director from movie group by director having sum(length(director)) / length(director) > 1)
order by director, title;

-- 10. Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
--     (Hint: This query is more difficult to write in SQLite than other systems; 
--     you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)
select title, avg
from (select *, avg(stars) as avg from rating group by mid)
	  join movie using(mid)
where avg = (select max(avg) from (select avg(stars) as avg from rating group by mid));

-- 11. Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.
--     (Hint: This query may be more difficult to write in SQLite than other systems; 
--     you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)
select title, avg
from (select *, avg(stars) as avg from rating group by mid)
	  join movie using(mid)
where avg = (select min(avg) from (select avg(stars) as avg from rating group by mid));

-- 12. For each director, return the director's name together with the title(s) of the movie(s) 
--     they directed that received the highest rating among all of their movies, and the value of that rating. 
--     Ignore movies whose director is NULL.
select director, title, stars
from movie join rating using(mid)
where director is not null
group by director
having stars = max(stars);
-- same query but each director with each of ther movies and their highest rating
select director, title, stars
from movie join rating using(mid)
where director is not null
group by director, mid
having stars = max(stars);