create database music;
use music;
----------------------------------------------------------------------------------
/*Who is the senior most employee based on job title?*/

select * from employee
order by levels desc
limit 3;
----------------------------------------------------------------------------------

/*Which countries have the most Invoices?*/

select distinct billing_country, count(invoice_id) from invoice
group by billing_country;

----------------------------------------------------------------------------------

select billing_country, count(invoice_id) from invoice
group by billing_country;

select * from invoice;

select * from customer;
select *from invoice_line;

----------------------------------------------------------------------------------

/*Who is the best customer? The customer who has spent the most money will be 
declared the best customer. Write a query that returns the person who has spent the 
most money*/

select c.customer_id, c.first_name, c.last_name, sum(i.total) as total_buy
from customer as c
join invoice as i on i.customer_id = c.customer_id
group by i.customer_id, c.first_name, c.last_name
order by total_buy desc;

----------------------------------------------------------------------------------

/*Write query to return the email, first name, last name, & Genre of all Rock Music 
listeners. Return your list ordered alphabetically by email starting with A*/

select c.customer_id, c.first_name, c.last_name, c.email, g.genre_id, g.name
from genre as g
join track as t on g.genre_id = t.genre_id
join invoice_line as l on l.track_id = t.track_id
join invoice as i on i.invoice_id = l.invoice_id
join customer as c on c.customer_id = i.customer_id
where g.name = 'rock'
and c.email like 'a%'
group by c.customer_id, c.first_name, c.last_name, c.email, g.genre_id;

----------------------------------------------------------------------------------

/* Let's invite the artists who have written the most rock music in our dataset. Write a 
query that returns the Artist name and total track count of the top 10 rock bands*/

select a.name, g.name, count(al.artist_id) as 'number_of_songs'
from artist as a
join album2 as al on al.artist_id = a.artist_id
join track as t on t.album_id = al.album_id
join genre as g on g.genre_id = t.genre_id
where g.name = 'rock'
group by a.name, g.name
order by number_of_songs desc;

----------------------------------------------------------------------------------

/*Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the 
longest songs listed first*/

select avg(milliseconds) from track;
select name, composer, milliseconds, minute(milliseconds)
from track
where milliseconds >= (select avg(milliseconds) from track)
order by milliseconds desc;

----------------------------------------------------------------------------------

/*Find how much amount spent by each customer on artists? 
Write a query to return customer name, artist name and total spent*/

select * from invoice_line;

select c.customer_id, c.first_name, c.last_name, a.artist_id, a.name, sum(l.unit_price * l.quantity) as total_amount
from customer as c
join invoice as i on i.customer_id = c.customer_id
join invoice_line as l on l.invoice_id = i.invoice_id
join track as t on t.track_id = l.track_id
join album2 as al on al.album_id = t.album_id
join artist as a on a.artist_id = al.artist_id
group by 1,2,3,4,5
order by total_amount desc;

----------------------------------------------------------------------------------

/* We want to find out the most popular music Genre for each country. We determine the 
most popular genre as the genre with the highest amount of purchases. Write a query 
that returns each country along with the top Genre. For countries where the maximum 
number of purchases is shared return all Genres */



select i.billing_country, g.name, count(i.invoice_id) as number_of_purchase
from invoice as i
join invoice_line as l on l.invoice_id = i.invoice_id
join track as t on t.track_id = l.track_id
join genre as g on g.genre_id = t.genre_id 
group by 1, 2;

----------------------------------------------------------------------------------


/*  Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

select c.customer_id, c.first_name, c.last_name, c.country, sum(i.total) as total_spent
from customer as c
join invoice as i on c.customer_id = i.customer_id
group by 1,2,3,4
order by total_spent desc;

----------------------------------------------------------------------------------

/*Write a query that determines the customer that has spent the most on music for each 
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all 
customers who spent this amount*/
select * from customer;
select * from invoice_line;
select * from invoice;

select c.customer_id, c.first_name, c.last_name, i.billing_country,
sum(i.total) over(partition by c.customer_id) as money_spent,
row_number () over(partition by i.billing_country) as row_no
from customer as c
join invoice as i on i.customer_id = c.customer_id
order by 5 desc;
----------
----------

select * from (select c.customer_id, c.first_name, c.last_name, i.billing_country,
sum(i.total) over(partition by c.customer_id) as money_spent,
row_number () over(partition by i.billing_country) as row_no
from customer as c
join invoice as i on i.customer_id = c.customer_id
order by 5 desc) x
where x.row_no = 1;

