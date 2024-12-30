Use Netflix
select * from netflix_movies

select COUNT(*) as total_counts From netflix_movies

select  Distinct type from netflix_movies

select Distinct country  from netflix_movies
--1. Count the Number of Movies vs TV Shows
select  
	type,Count(*) as total_counts
from netflix_movies
group by type
--2. Find the Most Common Rating for Movies and TV Shows
SELECT 
    type,
    rating,
    COUNT(*) AS movie_count,
    RANK() OVER (PARTITION BY type ORDER BY COUNT(*)) AS ranking
FROM 
    netflix_movies
GROUP BY 
    type, rating
ORDER BY 
    rating DESC;

SELECT 
    type,
    rating,
    COUNT(*) AS movie_count,
    RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM 
    netflix_movies
GROUP BY 
    type, rating
--ORDER BY rating DESC;

 --3. List All Movies Released in a Specific Year (e.g., 2020)
 select * from netflix_movies where type='movie'
 select * from netflix_movies where type='movie'and release_year=2020

 --4 Find the Top 5 Countries with the Most Content on Netflix
 select country from netflix_movies
 select country, count(show_id)as total_contant from netflix_movies group by country
 SELECT 
    TRIM(value) AS new_country
FROM 
    netflix_movies
CROSS APPLY 
    STRING_SPLIT(country, ',')

	SELECT 
    TRIM(value) AS new_country,
    COUNT(show_id) AS total_content
FROM 
    netflix_movies
CROSS APPLY 
    STRING_SPLIT(country, ',')
GROUP BY 
    TRIM(value)
ORDER BY 
    total_content DESC
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;

--5-Find the movie with the longest duration

select * from netflix_movies where type='Movie' and 
duration=(select MAX(duration) from netflix_movies)

--6 Retrieve content added to Netflix in the last 5 years.
SELECT DATEADD(DAY, -5, GETDATE()) AS new_date;

SELECT 
    title, 
    type, 
    date_added
FROM 
    netflix_movies
WHERE 
    date_added >= DATEADD(YEAR, -5, GETDATE());


--7 Find All Movies/TV Shows by Director 'Rajiv Chilaka'
select type,title, release_year from netflix_movies where director='Rajiv Chilaka'

select * from netflix_movies where director like '%Rajiv Chilaka'

select * from netflix_movies where director like '%Rajiv Chilaka%'

--8. List All TV Shows with More Than 5 Seasons
select * from netflix_movies 
where 
		type = 'TV Show' and 
		duration > '5 Seasons' 

--9. Count the Number of Content Items in Each Genre
SELECT 
    TRIM(value) AS genre, 
    COUNT(*) AS total_content
FROM 
    netflix_movies
CROSS APPLY 
    STRING_SPLIT(listed_in, ',')
GROUP BY 
    TRIM(value)

--10. Find each year and the average numbers of content release in India on netflix

SELECT 
    release_year,
    COUNT(*) AS content_count
FROM (
    SELECT 
        YEAR(date_added) AS release_year
    FROM 
        netflix_movies
    WHERE 
        country LIKE '%India%'  -- Filter content available in India
) AS subquery
GROUP BY 
    release_year
ORDER BY 
    release_year;

-- 11.List All Movies that are Documentaries

SELECT 
    *
FROM 
    netflix_movies
WHERE 
    type = 'Movie'
    AND listed_in LIKE '%Documentaries%'
ORDER BY 
    title;

--12. Find All Content Without a Director
select * from netflix_movies
where director is null

--13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
select * from netflix_movies where [cast] like '%Salman Khan%' 

SELECT show_id,type,title,director,[cast],COUNT(*) OVER () AS movie_count FROM  netflix_movies
WHERE 
    type = 'Movie'
    AND [cast] LIKE '%Salman Khan%'
    AND YEAR(date_added) >= YEAR(GETDATE()) - 10;

 Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

SELECT 
    TRIM(value) AS actor, 
    COUNT(*) AS movie_count
FROM 
    netflix_movies
CROSS APPLY 
    STRING_SPLIT(cast, ',')  
WHERE 
    country = 'India' 
GROUP BY 
    TRIM(value) 
ORDER BY 
    movie_count DESC;

 --14.Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
 SELECT TOP 10
    TRIM(value) AS actor, 
    COUNT(*) AS movie_count
FROM 
    netflix_movies
CROSS APPLY 
    STRING_SPLIT(cast, ',') 
WHERE 
    country = 'India' 
GROUP BY 
    TRIM(value)
ORDER BY 
    movie_count DESC; 


--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN LOWER(description) LIKE '%kill%' OR LOWER(description) LIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM 
        netflix_movies
) AS categorized_content
GROUP BY 
    category;










