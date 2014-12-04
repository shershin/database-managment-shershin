--humans vs zombies--
--michael shershin, cameron meyer, ed sutka--
--11/21/2014--

--children--
DROP TABLE IF EXISTS zombie;
DROP TABLE IF EXISTS career;
DROP TABLE IF EXISTS passwords;
DROP TABLE IF EXISTS player_admin;
DROP TABLE IF EXISTS signed_up;
DROP TABLE IF EXISTS killed;

--parent--
DROP TABLE IF EXISTS people;
DROP TABLE IF EXISTS game;

--creation of enums--
CREATE TYPE year AS ENUM ('freshmen', 'sophmore', 'junior', 'senior');
CREATE TYPE area AS ENUM ('Bryne House', 'Cannacino Libary', 'Champagnat Hall', 'Our Lady Seat of Wisdom Chapel', 'Cornell Boathouse', 'Donnelly Hall', 'Dyson Center', 'Fern Tor', 'Fontaine Hall', 'Gartland Apartments', 'Greystone Hall', 'Hancock Center', 'Kieran Gatehouse', 'Kirk House', 'Leo Hall', 'Longview Park', 'Lowell Thomas Communications Center', 'Lower Townhouses', 'Marian Hall', 'Marist Boathouse', 'McCann Recreation Center', 'Mid-rise Hall', 'St. Anns Hermitage', 'St. Peter', 'Sheahan Hall', 'Steel Plant Studios and Gallery', 'Student Center', 'Foy Townhouses', 'Lower West Cedar Townhouses', 'Upper West Cedar Townhouses', 'Fulton street Townhouses', 'Lower Fulton Townhouses');

--creation of people table--
CREATE TABLE people(
	pid serial not null,
	fname text,
	lname text,
	grade_year year,
	code_name text UNIQUE,
	email text UNIQUE,
	phone_num bigint UNIQUE,
	primary key(pid));

--creation of game--
CREATE TABLE game(
	gid SERIAL not null,
	start_date TIMESTAMP,
	end_date TIMESTAMP,
	primary key(gid));

--creation of passwords--
CREATE TABLE passwords(
	pid SERIAL not null references people(pid),
	pass text,
	primary key(pid));

--creation of admin--
CREATE TABLE player_admin(
	pid SERIAL not null references people(pid),
	primary key(pid));

--creation of killed--
CREATE TABLE killed(
	preditor SERIAL not null references people(pid),
	prey SERIAL not null references people(pid),
	gid SERIAL not null references game(gid),
	location area,
	primary key(preditor, prey, gid));

--creation of signed_up--
CREATE TABLE signed_up(
	pid SERIAL not null references people(pid),
	gid SERIAL not null references game(gid),
	primary key(pid, gid));

--creation of career--
CREATE TABLE career(
	pid SERIAL not null references people(pid),
	zombie_kills int,
	fox_kills int,
	deaths int,
	primary key(pid));
--creation of zombies--
CREATE TABLE zombie(
	pid serial not null references people(pid),
	gid SERIAL not null references game(gid),
	time_turned TIMESTAMP,
	time_killed TIMESTAMP,
	primary key(pid, gid));
--stored procedures--
--shows who is signed up for that game--
CREATE OR REPLACE FUNCTION signed_up_to_battle(gid INTEGER, OUT fname text,
	OUT lname text,
	OUT code_name text,
	OUT email text) RETURNS SETOF RECORD AS $$

	BEGIN
	RETURN QUERY select p.fname, p.lname, p.code_name, p.email
	from people p, signed_up su, game g
	where p.pid = su.pid and su.gid = g.gid and g.gid = $1
	order by p.pid;
	END;
	$$ LANGUAGE plpgsql;
	--shows the zombies signed up for that game--
	CREATE OR REPLACE FUNCTION zombies_to_battle(gid INTEGER, OUT fname text,
		OUT lname text,
		OUT code_name text,
		OUT email text) RETURNS SETOF RECORD AS $$

		BEGIN
		RETURN QUERY select p.fname, p.lname, p.code_name, p.email
		from people p, signed_up su, zombie z, game g
		where p.pid = su.pid and z.pid = su.pid and z.gid= su.gid and su.gid = g.gid and g.gid = $1
		order by p.pid;
		END;
		$$ LANGUAGE plpgsql;
		--updating kills--
		CREATE OR REPLACE FUNCTION update_zombie_kill(pid integer)returns void AS $$

		BEGIN
		update career
			set zombie_kills = zombie_kills + 1
			where pid = $1;
			END;
			$$ LANGUAGE plpgsql;
			--updating human kills--
			CREATE OR REPLACE FUNCTION update_fox_kill(pid integer)returns void AS $$

			BEGIN
			update career
				set fox_kills = fox_kills + 1
				where pid = $1;
				END;
				$$ LANGUAGE plpgsql;
				--death update--
				CREATE OR REPLACE FUNCTION update_deaths(pid integer)returns void AS $$

				BEGIN
				update career
					set deaths = deaths + 1
					where pid = $1;
					END;
					$$ LANGUAGE plpgsql;
					--showing career of given player--
					create or replace function show_career(pid integer, out code_name text,
						out zombie_kills integer,
						out fox_kills integer,
						out deaths integer) returns setof record as $$
						begin
						return QUERY select p.code_name, c.zombie_kills, c.fox_kills, c.deaths
						from people p, career c
						where p.pid = c.pid and
						c.pid = $1;
						end;
						$$ language plpgsql;
--triggers--
--check all the people--
create function check_people() returns trigger as $check_people$
	begin
	if
	exists(select *
		from people
		where fname = NEW.fname and
		lname = NEW.lname and
		grade_year = NEW.grade_year and
		code_name = NEW.code_name and
		email = NEW.email and
		phone_num = NEW.phone_num)
		then
		raise exception 'Sorry, but you already exists and we do not want another one of you';
		end if;
		return NEW;
		end;
		$check_people$ language plpgsql;
		create trigger check_people before insert on people
			for each row execute procedure check_people();
			--logon trigger--
			create function admin_login_check() returns trigger as $admin_login_check$
				begin
				if
				exists(select p.code_name, ps.pass
					from people p, passwords ps, player_admin pa
					where p.pid = ps.pid and
					p.pid = pa.pid and
					p.code_name = NEW.code_name and
					ps.pass = NEW.pass)
					then
					return NEW;
					end if;
					return exception 'Sorry you are not an admin please never try again';
					end;
					$admin_login_check$ language plpgsql;
					--regular player check--
					create function login_check() returns trigger as $login_check$
						begin
						if
						exists(select p.code_name, ps.pass
							from people p, passwords ps
							where p.pid = ps.pid and
							p.code_name = NEW.code_name and
							ps.pass = NEW.pass)
							then
							return NEW;
							end if;
							return exception 'Sorry, you are not in the database. Please sign up for our amazing app';
							end;
							$login_check$ language plpgsql;
--views--
--amount of zombie wins--
CREATE VIEW amount_of_zombie_wins as
select count(z.pid)
from zombie z, signed_up s
where z.pid > s.pid and z.gid = s.gid
group by z.gid;
--amount of fox wins--
CREATE VIEW amount_of_fox_wins as
select count(s.pid)
from signed_up s, zombie z
where s.pid > z.pid and s.gid = z.gid
group by s.gid;
--listing all the prediors--
CREATE VIEW preditor as
select distinct p.pid, p.code_name, c.zombie_kills, c.fox_kills
from people p, killed k, signed_up s, career c
where p.pid = s.pid and s.pid = k.preditor and c.pid = p.pid;
--listing all the preys--
CREATE VIEW prey as
select distinct p.code_name, p.pid, c.deaths
from people p, killed k, signed_up s, career c
where p.pid = s.pid and s.pid = k.prey and c.pid = p.pid;
--security--
CREATE ROLE app
GRANT SELECT, INSERT, UPDATE
ON ALL TABLES IN SCHEMA PUBLIC
TO app

CREATE ROLE admin
GRANT SELECT, INSERT, UPDATE, ALTER, DELETE
ON ALL TABLES IN SCHEMA PUBLIC
TO admin
--small amount of data to be inserted--
--inserting data--
INSERT INTO people(fname, lname, grade_year, code_name, email, phone_num)
VALUES('mike', 'shershin', 'junior', 'beg2thefox', 'michael.shershin1@marist.edu', '8455184571'),
('ed', 'sutka', 'sophmore', 'new noble', 'edward.sutka1@marist.edu', '8451234567'),
('cameron', 'meyer', 'sophmore', 'bunnie king', 'cameron.meyer1@marist.edu', '1234561234');

--password--
INSERT INTO passwords(pid, pass)
VALUES('1', 'kitten'),
('2', 'chowder'),
('3', 'hat');
--admin--
INSERT INTO player_admin(pid)
values('1');
--killed--
INSERT INTO killed(preditor, prey, gid, location)
values('2', '1', '1', 'Hancock Center');
--game_set--
INSERT INTO game(start_date, end_date)
values(NOW(), '2015-1-01 00:00:00');
--signed_up--
INSERT INTO signed_up(pid, gid)
values('1', '1'),
('2', '1'),
('3', '1');
--zombie time--
INSERT INTO zombie(pid, gid, time_turned)
VALUES(1, 1, NOW());
