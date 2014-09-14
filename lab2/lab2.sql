----------------------------------------------------------------------------------------
-- Postgres create, load, and query script for CAP2.
--
-- SQL statements for the CAP2 database
-- 
-- Derived from the CAP examples in _Database Principles, Programming, and Performance_, 
--   Second Edition by Patrick O'Neil and Elizabeth O'Neil
-- 
-- Modified a few times by Alan G. Labouseur
-- 
-- Tested on Postgres 9.3.2    (For earlier versions, you may need
--   to remove the "if exists" clause from the DROP TABLE commands.)
----------------------------------------------------------------------------------------

-- Connect to your Postgres server and set the active database to CAP2.  Then . . .

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS agents;
DROP TABLE IF EXISTS products;


-- Customers --
CREATE TABLE customers (
  cid      char(4) not null,
  name     text,
  city     text,
  discount decimal(5,2),
 primary key(cid)
);


-- Agents --
CREATE TABLE agents (
  aid     char(3) not null,
  name    text,
  city    text,
  percent real,
 primary key(aid)
);        


-- Products --
CREATE TABLE products (
  pid      char(3) not null,
  name     text,
  city     text,
  quantity integer,
  priceUSD numeric(10,2),
 primary key(pid)
);


-- Orders -- 
CREATE TABLE orders (
  ordno   integer not null,
  mon     char(3),    
  cid     char(4) not null references customers(cid),
  aid     char(3) not null references agents(aid),
  pid     char(3) not null references products(pid),
  qty     integer,
  dollars numeric(12,2),
 primary key(ordno)
);



-- SQL statements for loading example data into the CAP2 database
-- Tested on Postgres 9.3.2
-- Connect to your Postgres server and set the active database to CAP2.  Then . . .

-- Customers --
INSERT INTO Customers( cid, name, city, discount )
  VALUES('c001', 'Tiptop', 'Duluth', 10.00);

INSERT INTO Customers( cid, name, city, discount )
  VALUES('c002', 'Basics', 'Dallas', 12.00);

INSERT INTO Customers( cid, name, city, discount )
  VALUES('c003', 'Allied', 'Dallas', 8.00);

INSERT INTO Customers( cid, name, city, discount )
  VALUES('c004' ,'ACME' ,'Duluth', 8.00);

INSERT INTO Customers( cid, name, city, discount )
  VALUES('c005' ,'Weyland-Yutani', 'Acheron', 0.00);

INSERT INTO Customers( cid, name, city, discount )
  VALUES('c006' ,'ACME' ,'Kyoto' ,0.00);


-- Agents --
INSERT INTO Agents( aid, name, city, percent )
  VALUES('a01', 'Smith', 'New York', 6 );

INSERT INTO Agents( aid, name, city, percent )
  VALUES('a02', 'Jones', 'Newark', 6 );

INSERT INTO Agents( aid, name, city, percent )
  VALUES('a03', 'Brown', 'Tokyo', 7 );

INSERT INTO Agents( aid, name, city, percent )
  VALUES('a04', 'Gray', 'New York' ,6 );

INSERT INTO Agents( aid, name, city, percent )
  VALUES('a05', 'Otasi', 'Duluth', 5 );

INSERT INTO Agents( aid, name, city, percent )
  VALUES('a06', 'Smith', 'Dallas', 5 );

INSERT INTO Agents( aid, name, city, percent )
  VALUES('a08', 'Bond', 'London', 7 );


-- Products --
INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p01', 'comb', 'Dallas', 111400, 0.50 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p02', 'brush', 'Newark', 203000, 0.50 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p03', 'razor', 'Duluth', 150600, 1.00 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p04', 'pen', 'Duluth', 125300, 1.00 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p05', 'pencil', 'Dallas', 221400, 1.00 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p06', 'folder','Dallas', 123100, 2.00 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p07', 'case', 'Newark', 100500, 1.00 );

INSERT INTO Products( pid, name, city, quantity, priceUSD )
  VALUES('p08', 'clip', 'Newark', 200600, 1.25 );


-- Orders --
INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1011, 'jan', 'c001', 'a01', 'p01', 1000, 450.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1013, 'jan', 'c002', 'a03', 'p03', 1000, 880.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1015, 'jan', 'c003', 'a03', 'p05', 1200, 1104.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1016, 'jan', 'c006', 'a01', 'p01', 1000, 500.00);
  
INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1017, 'feb', 'c001', 'a06', 'p03',  600, 540.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1018, 'feb', 'c001', 'a03', 'p04',  600, 540.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1019, 'feb', 'c001', 'a02', 'p02',  400, 180.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1020, 'feb', 'c006', 'a03', 'p07',  600, 600.00);
  
INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1021, 'feb', 'c004', 'a06', 'p01', 1000, 460.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1022, 'mar', 'c001', 'a05', 'p06',  400, 720.00);
    
INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1023, 'mar', 'c001', 'a04', 'p05',  500, 450.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1024, 'mar', 'c006', 'a06', 'p01',  800, 400.00);
  
INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1025, 'apr', 'c001', 'a05', 'p07',  800, 720.00);

INSERT INTO Orders( ordno, mon, cid, aid, pid, qty, dollars )
  VALUES(1026, 'may', 'c002', 'a05', 'p03',  800, 740.00);


-- SQL statements for displaying example data into the CAP2 database
-- Connect to your Postgres server and set the active database to CAP2.  Then . . .



select *
from orders;