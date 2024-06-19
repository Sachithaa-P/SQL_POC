1.Display top 5 categories by duration
select netflix_titles_category.listed_in ,
SUM(netflix_titles.duration_minutes) as duration
from netflix_titles join netflix_titles_category
on netflix_titles.show_id = netflix_titles_category.show_id
group by netflix_titles_category.listed_in
order by duration desc
limit 5;

2. Display top 5 movies by watch time
select title,duration_minutes from netflix_titles
where type="Movie"
order by duration_minutes desc 
limit 5;  

3.Display an actor who has most films
select ntcast.cast from
netflix_titles_cast ntcast join netflix_titles nt on
ntcast.show_id = nt.show_id 
where type='Movie'
group by ntcast.cast
order by count(*) desc
limit 1;

4.Which country has highest TV-ma rated movies
select ntcount.country ,count(nt.rating) as rating
from netflix_titles_countries ntcount join netflix_titles nt on 
ntcount.show_id = nt.show_id
where rating='TV-MA' and type='Movie'
group by ntcount.country
order by rating desc
limit 1;

5.Which country has more number of movies released
select ntcount.country from
netflix_titles_countries ntcount join netflix_titles nt on
ntcount.show_id =nt.show_id
where type='Movie'
group by ntcount.country 
order by count(*) desc
limit 1;

6.Display year wise top3 category that has been released in descending order
select listed_in ,release_year 
from (Z
select nt.release_year,ntcat.listed_in, row_number() Over  (partition by nt.release_year order by count(*)desc) as category_ranked
from netflix_titles_category ntcat join netflix_titles nt on
ntcat.show_id = nt.show_id
group by nt.release_year,ntcat.listed_in) as ranked_category
where category_ranked <= 3
order by release_year desc

7.Display unique set of actors utilized by directors for different movies  
select distinct(ntcast.cast) from 
netflix_titles_cast ntcast join netflix_titles_directors ntd on
ntcast.show_id = ntd.show_id;

8.Find the sequence between the title name based on the released year starting
   with 1?
select title , release_year,row_number () over (order by release_year asc) as sequence_number from 
netflix_titles;

9.Check whether the id mentioned when loaded has any duplicates. If duplicates present,
    skip it or else insert the record
select show_id, COUNT(*) as duplicate_count
from netflix_titles_category
group by show_id
having COUNT(*) > 1;

10. Display country wise actors who did max no of movies/tv shows every year in descending order?
select ntcount.country, max(ntcast.cast) as Max_Cast , nt.release_year 
from netflix_titles nt join netflix_titles_cast ntcast on nt.show_id = ntcast.show_id
join netflix_titles_countries ntcount on nt.show_id = ntcount.show_id
where nt.type = 'Movie'
group by ntcount.country, nt.release_year
order by  nt.release_year desc;
