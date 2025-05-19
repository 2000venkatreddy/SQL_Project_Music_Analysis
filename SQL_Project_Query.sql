

-- Who is the senior most employee based on job title?

SELECT * 
FROM employee
order by levels desc
limit 1

-- Which countries have the most Invoices?

select count(*) as c,billing_country 
from invoice
group by billing_country
order by c desc
limit 1


-- What are top 1 values of total invoice?

SELECT total
FROM invoice
order by total desc
limit 1

-- Which city has the best customers? We would like to throw a promotional Music
-- Festival in the city we made the most money. Write a query that returns one city that
-- has the highest sum of invoice totals. Return both the city name & sum of all invoice totals


select sum(total) as total,billing_city
from invoice
group by billing_city
order by total desc

-- Who is the best customer? The customer who has spent the most money will be
-- declared the best customer. Write a query that returns the person who has spent the
-- most money

select customer.customer_id, customer.first_name,customer.last_name,SUM(invoice.total) as total
from customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
order BY total desc
limit 1


-- 1. Write query to return the email, first name, last name, & Genre of all Rock Music
-- listeners. Return your list ordered alphabetically by email starting with A

select distinct email, first_name,last_name 
from customer
join invoice
on customer.customer_id = invoice.customer_id
join invoice_line
on invoice_line.invoice_id = invoice.invoice_id
where track_id IN(
	select track_id from track
	join genre on genre.genre_id = track.genre_id
	where genre.name LIKE 'Rock'
)
order by email ASC

-- Let's invite the artists who have written the most rock music in our dataset. Write a
-- query that returns the Artist name and total track count of the top 10 rock bands

select artist.artist_id,artist.name,count(artist.artist_id) as num_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name = 'Rock'
group by artist.artist_id
order by num_of_songs  desc
limit 10

-- 3. Return all the track names that have a song length longer than the average song length.
-- Return the Name and Milliseconds for each track. Order by the song length with the
-- longest songs listed first


select name,milliseconds
from track
where milliseconds >(
	select avg(milliseconds) from track
)
order by milliseconds desc


--  Find how much amount spent by each customer on artists? Write a query to return
-- customer name, artist name and total spent

with best_selling_artist AS (
	SELECT artist.artist_id AS artist_id, artist.name AS artist_name, 
	SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
 	FROM invoice_line
	JOIN track 
	ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
select c.customer_id, c.first_name, c.last_name,bsa.artist_name,
SUM(il.unit_price * il.quantity) AS amount_spent
From invoice i
join customer c ON c.customer_id = i.customer_id
join invoice_line il ON il.invoice_id = i.invoice_id
join track t ON t.track_id = il.track_id
join album alb ON alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 DESc


