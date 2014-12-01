--michael shershin
--lab 10
create function preReqNum(num integer out num integer,
					     out name text,
					     out credits integer) returns set of record as 
$$
begin
      return query
      select c.num, c.name, c.credits
      from   Prerequisites p, Courses c
      where  p.courseNum = c.num and p.preReqNum = c.num and p.preReqNum = $1;
end;
$$ 
language plpgsql;

create or replace function isPreReqFor(courseNum int) returns int as 
$$
begin
      select Prerequisites.preReqNum
      from   Prerequisites
       where  Prerequisites.courseNum = $1;
end;
$$ 
language plpgsql;

