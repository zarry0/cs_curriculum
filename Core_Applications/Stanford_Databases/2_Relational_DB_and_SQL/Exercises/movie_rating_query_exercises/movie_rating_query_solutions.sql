
-- 1. Find the titles of all movies directed by Steven Spielberg.
select title
from movie
where director = 'Steven Spielberg';

-- 2. Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
select year
from movie
where mID in (select mID from rating where stars >= 4)
order by year;
-- alternative
select distinct year
from movie join rating using(mID)
where stars >= 4
order by year;

-- 3. Find the titles of all movies that have no ratings.
select title
from movie
where mID not in (select mID from rating);
-- alternative
select title 
from movie
where mid in (select mid from movie
			  except
			  select distinct mid from movie natural join rating);
              
 -- 4. Some reviewers didn't provide a date with their rating. 
 --    Find the names of all reviewers who have ratings with a NULL value for the date.
 select name
 from reviewer
 where rid in (select rid from rating where ratingDate is null);
 
-- 5. Write a query to return the ratings data in a more readable format: 
--                     reviewer name, movie title, stars, and ratingDate.
--    Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
select name as 'Reviewer name', title as 'Movie title', stars, ratingDate
from (reviewer join rating using(rid)) join movie using(mid)
order by name, title, stars;
-- alternative
select rev.name as 'Reviewer name', title as 'Movie title', stars, ratingDate
from reviewer rev, rating rat, movie m
where rev.rID = rat.rID and rat.mID = m.mID
order by rev.name, title, stars;*/

-- 6. For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
--    return the reviewer's name and the title of the movie.

-- The process for my (terrible yet correct) first attempt:
    -- 1. Get reviewer id an movie id for movies that got rated twice by the same person
    select rid, mid, count(mid)
    from rating
    group by rID, mID
    having count(mid) = 2;
    -- 2. Get ratings repeated twice
    select *
    from rating
    where (rID, mID) in (select rid, mID from rating group by rID, mID having count(mid) = 2)
    order by rID, mID, ratingDate;
    -- 3.1 Get highest ratings for any given movie reviewed twice
    select rID, mID, max(stars), ratingDate
    from rating
    where (rID, mID) in (select rid, mID from rating group by rID, mID having count(mid) = 2)
    group by rID, mID;
    -- 3.2 Get lowest ratings for any given movie reviewed twice
    select rID, mID, min(stars), ratingDate
    from rating
    where (rID, mID) in (select rid, mID from rating group by rID, mID having count(mid) = 2)
    group by rID, mID;
    -- 4. Get reviewer id and movie id of movies rated twice with a higher score the second time
    select rID, maxRating.mid 
    from (select rID, mID, max(stars), ratingDate
        from rating
        where (rID, mID) in (select rid, mID from rating group by rID, mID having count(mid) = 2)
        group by rID, mID) as maxRating
        join 
        (select rID, mID, min(stars), ratingDate
        from rating
        where (rID, mID) in (select rid, mID from rating group by rID, mID having count(mid) = 2)
        group by rID, mID) as minRating
        using(rID)
    where minRating.ratingDate < maxRating.ratingDate;
    -- 5. Get reviewer name and movie title of movies rated twice with a higher score the second time
    select reviewer.name, movie.title
    from (select rID, maxRating.mid 
        from (select rID, mID, max(stars), ratingDate
                from rating
                where (rID, mID) in (select rid, mID from rating group by rID, mID having count(mid) = 2)
                group by rID, mID) as maxRating
        join 
            (select rID, mID, min(stars), ratingDate
                from rating
                where (rID, mID) in (select rid, mID from rating group by rID, mID having count(mid) = 2)
                group by rID, mID) as minRating
        using(rID)
        where minRating.ratingDate < maxRating.ratingDate) as killMe, reviewer, movie
    where killMe.rid = reviewer.rid and killMe.mid = movie.mid;

-- Process for my second (much better) attempt
    -- self join rating
    select *
    from rating r1 join rating r2 using(rid, mid);

    -- self join rating but keep tuples where the left table has lower rating than the right
    select *
    from rating r1 join rating r2 using(rID, mid)
    where r1.stars < r2. stars;

    -- from the previous table, keep tuples where the right date is greater than the left one
    select *
    from rating r1 join rating r2 using(rID, mid)
    where r1.stars < r2. stars and r1.ratingDate < r2.ratingDate;

    -- FINAL SOLUTION
    -- join with reviewers and movies to get names and title
    select name, title
    from rating r1 join 
        rating r2 using(rID, mid) 
        join reviewer using(rid) 
        join movie using(mid)
    where r1.stars < r2. stars and r1.ratingDate < r2.ratingDate;

-- 7. For each movie that has at least one rating, find the highest number of stars that movie received.
--    Return the movie title and number of stars. Sort by movie title.
    -- group ratings by mID and max(stars)
    select mid, max(stars)
    from rating
    group by mid;
    -- from the previous table, join wiht movies and get the names instead of mIDs, then sort by title
    select title, max(stars)
    from rating join movie using(mid)
    group by mid
    order by title;
    -- alternative
    select title, mstar
    from (select mid, max(stars) mStar from rating group by mid) join movie using(mid)
    order by title;

-- 8. For each movie, return the title and the 'rating spread', 
--    that is, the difference between highest and lowest ratings given to that movie.
--    Sort by rating spread from highest to lowest, then by movie title.

    -- self join rating
    select mID, r1.stars as s1, r2.stars as s2
    from rating r1 join rating r2 using(mID)
    order by mID;
    -- get max and min rating for each movie
    select mID, min(r1.stars), max(r2.stars)
    from rating r1 join rating r2 using(mID)
    group by mID;
    -- get the spread, movie title, and sort the result
    select title, max(r2.stars) - min(r1.stars) as spread
    from rating r1 join 
         rating r2 using(mID) join
         movie using(mid)
    group by mID
    order by spread desc, title;
    -- alternative
    select title, max(stars) - min(stars) as spread
    from rating join movie using(mid)
    group by mID
    order by spread desc, title;

-- 9. Find the difference between the average rating of movies released before 1980 
--    and the average rating of movies released after 1980.   
--    (Make sure to calculate the average rating for each movie, 
--    then the average of those averages for movies before 1980 and movies after. 
--    Don't just calculate the overall average rating before and after 1980.)
-- average rating for every movie
    select mid, avg(stars)
    from rating
    group by mid;

    -- movies released before 1980 and their avg rating
    select mid, title, avg(stars)
    from rating join movie using(mid)
    where year <= 1980
    group by mid;

    -- movies released after 1980 and their avg rating
    select mid, title, avg(stars)
    from rating join movie using(mid)
    where year > 1980
    group by mid;

    -- difference between avg ratings
    select avg(b1980.mstars) - avg(a1980.mstars) 
    from (select mid, title, avg(stars) as mStars
          from rating join movie using(mid)
          where year <= 1980
          group by mid) as b1980,
         (select mid, title, avg(stars) mStars
          from rating join movie using(mid)
          where year > 1980
          group by mid) as a1980;