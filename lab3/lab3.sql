--one--
select name, city
from agents
where name = 'Bond';
--two--
select pid, name, quantity
from products
where priceUSD > 0.99;
--three--
select ordno, qty
from orders;
--four--
select name, city
from customers
where city = 'Duluth';
--five--
select name
from agents
where city != 'New York' and city != 'London';
--six--
select *
from products
where city != 'Dallas' and city != 'Duluth' and priceUSD <= 1;
--seven--
select *
from orders
where mon = 'jan' or mon = 'apr';
--eight--
select *
from orders
where mon = 'feb' and dollars > 200;
--nine--
select *
from orders
where cid = 'c005';