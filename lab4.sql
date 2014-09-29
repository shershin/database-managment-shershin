--one--
select distinct city
from agents
where aid in 
	(select distinct aid
	from orders 
	where cid in 
		(select cid
		from customers
		where name = 'Tipthelop')
	)
order by city asc;

--two--
select distinct pid
from orders
where aid in 
	(select aid
	from orders
	where cid in 
		(select cid
		from customers
		where city = 'Kyoto')
	)
order by pid asc;

--three--
select cid, name
from customers
where cid not in 
	(select cid
	from orders
	where aid = 'a04')
order by cid asc;

--four--
select cid, name
from customers
where cid in 
	(
	(select distinct cid
	from orders
	where pid ='p01')
		intersect
	(select cid
	from orders
	where pid = 'p07')
	)
order by cid asc;

--five--
select distinct pid
from orders
where cid in
	(select cid
	from orders
	where aid = 'a04')
order by pid asc;

--six--
select name, discount
from customers
where cid in 
	(select cid
	from orders
	where aid in
		(select aid
		from agents
		where city = 'Dallas' or city = 'Newark')
	)
order by name asc;

--seven--
select *
from customers
where city != 'Dallas'and city != 'Kyoto'and discount in 
	(select discount
	from customers
	where city = 'Dallas' or city = 'Kyoto')
order by cid asc;