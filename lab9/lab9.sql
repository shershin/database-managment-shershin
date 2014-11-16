--michael shershin--
--lab 9--
--i am assuming that coaches can not be players and players can not be coaches--

drop table if exists players;
drop table if exists coaches;
drop table if exists teams;
drop table if exists plays_on;
drop table if exists coaches_on;

create table players(
	pid char(4) not null,
	fname text,
	lname text,
	phone_num int,
	address text,
	age int,
	primary key (pid));

create table coaches(
	cid char(4) not null,
	fname text,
	lname text,
	phone_num int,
	address text,
	years_coaching int,
	primary key (cid));

create table teams(
	tid char(4) not null,
	team_name text,
	age_group text,
	primary key (tid));

create table plays_on(
	pid char(4) not null references players(pid), 
	tid char(4) not null references teams(tid),
	prefered_position text,
	primary key (pid, tid));

create table coaches_on(
	cid char(4) not null references coaches(cid),
	tid char(4) not null references teams(tid),
	coaching_position text,
	primary key (cid, tid));

--fuctional relationships--
--if i am not mistaken every table is nothing but the key--
--i just wanted to add that if coaches could be players then i would just add a people table--


--my table is in bcnf because there are no overlapping information mainly with my canidite keys--

