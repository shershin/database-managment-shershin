--shershin the michael you forget that is in your class 
--due i have no idea when 

--one--
select distinct a.city
from agents a
inner join orders o
	on a.aid = o.aid
inner join customers c
	on c.cid = o.cid and c.name = 'Tiptop'
order by city asc;

--two--
select distinct p.pid
from products p
inner join orders o
	on p.pid = o.pid
inner join customers c
	on o.cid = c.cid and c.city = 'Kyoto'
order by pid asc;
--three--
select name
from customers
where cid not in
	(select cid
	from orders)
order by name asc;

--four--
select c.name
from customers c
left outer join orders o
	on o.cid = c.cid
	where o.cid is null
order by name asc;

 --five--
select distinct c.name, a.name
from customers c, orders o, agents a
where c.cid = o.cid and a.aid = o.aid and c.city = a.city
order by c.name asc;

--six--
select distinct c.name, a.name, c.city 
from customers c, agents a
where c.city = a.city
order by city asc;

--seven--
select distinct c.name, p.city, p.quantity
from customers c, products p
where c.city = p.city and p.city in
	(select city
	from products
	group by city
	order by Min(quantity) asc);
	