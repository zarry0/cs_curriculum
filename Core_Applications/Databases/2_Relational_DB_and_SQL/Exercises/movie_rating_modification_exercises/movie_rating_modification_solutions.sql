
-- 1. Add the reviewer Roger Ebert to your database, with an rID of 209.
insert into reviewer values (209, 'Roger Ebert');

-- 2. For all movies that have an average rating of 4 stars or higher, add 25 to the release year.
--    (Update the existing tuples; don't insert new tuples.)
update movie
set year = year + 25
where mid in (select mid from rating group by mid having avg(stars) >= 4);

-- 3. Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.
delete from rating
where stars < 4 
and mid in (select mid from movie where year < 1970 or year > 2000);
