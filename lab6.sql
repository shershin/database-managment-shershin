--Shershin--
--lab 6--
--one--
select distinct p.city, c.name
from customers c, products p
where c.city = p.city and p.city in
	(select city
	from products
	group by city
	order by count(city)asc
	limit 1);

--two--
select distinct c.name, p.city
from customers c, products p
where c.city = p.city and p.city in
	(select city
	from products
	group by (city)
	order by count(city) asc
	limit 2);

--three--
select *
from products
where priceUSD > (
	select avg(priceUSD)
	from products)
order by pid asc;

--four--
select c.name, o.pid, o.dollars
from customers c, orders o
where c.cid = o.cid
order by o.dollars asc; 

--five--
select c.name, coalesce(sum(o.qty),0) as "Boom Total Ordered"
from customers c
inner join orders o 
	on c.cid = o.cid
group by c.name
order by c.name asc;

--six--
select c.name, p.name, a.name
from customers c, products p, agents a, orders o
where c.cid = o.cid and p.pid = o.pid and a.aid = o.aid and a.city = 'New York'
order by c.name asc;

--seven--
select c.name, o.ordno, p.pid, o.qty, p.priceUSD, c.discount, o.dollars
from customers c, orders o, products p
where c.cid = o.cid and o.pid = p.pid and 
	(o.qty * p.priceUSD) - 
	(((o.qty * p.priceUSD) * c.discount)/ 100)!= o.dollars
order by o.ordno asc;