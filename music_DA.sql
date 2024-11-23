#1.	Who is the senior most employee based on job title? 
select concat(last_name ," ",first_name ) as Name , title, levels from employee
order by levels desc
limit 1;

#2.	Which countries have the most Invoices? 
select COUNT(invoice_id) as no_of_invoice, billing_country 
from invoice
group by billing_country
order by no_of_invoice DESC
limit 5;

#3.	What are top 3 values of total invoice? 
select billing_country,billing_city,total  from invoice
order by total desc
limit 3;

#4.	Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals 
select billing_city, sum(total) as invoicetotal from invoice 
group by billing_city
order by invoicetotal desc
limit 5;

#5.	Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money 
select customer.customer_id ,concat(customer.first_name, " ", customer.last_name) as cust_name, invoice.billing_city,invoice.billing_country, sum(invoice.total) as invoicetotal from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id,cust_name,invoice.billing_city,invoice.billing_country
order by invoicetotal desc
limit 5;

#6.	Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A 
select customer.email,concat(customer.first_name," ",customer.last_name) as cust_name , genre.name
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id= invoice_line.invoice_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id=track.genre_id
where genre.name ="Rock"
group by customer.email,cust_name 
order by customer.email 
limit 20;

#7.	Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands 
select artist.artist_id, artist.name,COUNT(track.track_id)total_track_count
from track
join genre on genre.genre_id = track.genre_id
join album2 on album2.album_id = track.album_id
join artist on artist.artist_id = album2.artist_id
#join playlist_track on playlist_track.track_id=track.track_id
where genre.name = "Rock"
group by artist.artist_id,artist.name
order by total_track_count desc;

#8.	Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first 
select name, milliseconds
from track
where milliseconds > (
    select avg(milliseconds) as avg_track_length
    from track
)
order by milliseconds desc
limit 20 ;

#9.	Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent 
select customer.customer_id,concat(customer.first_name, " ", customer.last_name) as cust_name,artist.name,sum(invoice_line.unit_price * invoice_line.quantity) as toral_spent 
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
join track on track.track_id=invoice_line.track_id
join album2 on track.album_id=album2.album_id
join artist on artist.artist_id=album2.album_id
group by customer.customer_id,cust_name,artist.name
order by toral_spent desc
limit 10;

#10.	We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres 
with cte as (
select invoice.billing_country as country, genre.name as genre, sum(invoice_line.quantity)as no_of_purchase, dense_rank() over(partition by invoice.billing_country order by sum(invoice_line.quantity)desc) as ran
from invoice
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
join track on track.track_id=invoice_line.track_id
join genre on genre.genre_id = track.genre_id
group by invoice.billing_country, genre.name)
select country,genre from cte
where ran=1;

#11.	Write a query that determines the customer that has spent the most on music for each country. Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount 
with cte as(
select invoice.billing_country as country, concat(customer.first_name," ", customer.last_name)as cust_name, sum(invoice.total) as total_spending , dense_rank() over(partition by invoice.billing_country order by sum(invoice.total) desc) as ran
from customer 
join invoice on customer.customer_id=invoice.customer_id
group by invoice.billing_country,cust_name)
select country,cust_name,total_spending
from cte 
where ran=1;


