DROP DATABASE IF EXISTS insurance;

-- comments (start with '--')
-- --------
show databases; -- works only in MySQL, not standard SQL
create database insurance;
-- drop database insurance; -- TO remove DB

-- create user which uses this databases
DROP USER IF EXISTS 'myuser'@'localhost';
DROP USER IF EXISTS 'myuser'@'%';
CREATE USER 'myuser'@'localhost' IDENTIFIED WITH mysql_native_password BY 'FinoAllaFine!';
GRANT ALL PRIVILEGES ON insurance.* TO 'myuser'@'localhost';
CREATE USER 'myuser'@'%' IDENTIFIED WITH mysql_native_password BY 'FinoAllaFine!';
GRANT ALL PRIVILEGES ON insurance.* TO 'myuser'@'%';

create table insurance.driver(
	licno varchar(20),
	name varchar(30) not null,
	surname varchar(30) not null,
	gender varchar(1) not null,
	primary key (licno),
	check (gender in ('M', 'F'))
);

create table insurance.car(
	numplate varchar(6),
	make varchar(15) not null,
	colour varchar(10) not null,
	price int(5) not null,
	licno varchar(20),
	primary key (numplate),
	foreign key (licno) references insurance.driver (licno) on update set null on delete cascade 
);

alter table insurance.driver drop gender;
alter table insurance.driver add gender varchar(1) not null;
alter table insurance.driver add constraint check (gender in ('M', 'F'));

desc insurance.driver;

insert into insurance.driver(licno, name, surname, gender) values ('111111', 'Jean-Paul', 'Ebejer', 'M');
insert into insurance.driver(licno, name, surname, gender) values ('222222', 'Alan', 'Aguis', 'F');
insert into insurance.driver(licno, name, surname, gender) values ('333333', 'Eman', 'Borg', 'M');
insert into insurance.driver(licno, name, surname, gender) values ('444444', 'Carlo', 'Mamo', 'M');

insert into insurance.driver(licno, name, surname, gender) values ('555555', 'Joe', 'Tonna', 'M');
insert into insurance.driver(licno, name, surname, gender) values ('666666', 'John', 'Grech', 'M');
insert into insurance.driver(licno, name, surname, gender) values ('777777', 'Jon', 'Pires', 'M');
insert into insurance.driver(licno, name, surname, gender) values ('888888', 'Alba', 'Mamo', 'F');

insert into insurance.car(numplate, make, colour, price, licno) values ('JPE123', 'Audi', 'Silver', 25000, '111111');
insert into insurance.car(numplate, make, colour, price, licno) values ('CAR123', 'BMW', 'Black', 30000, '444444');
insert into insurance.car(numplate, make, colour, price, licno) values ('ALA123', 'SKODA', 'Red', 500, '222222');
insert into insurance.car(numplate, make, colour, price, licno) values ('EMA123', 'FORD', 'Red', 2500, '333333');
insert into insurance.car(numplate, make, colour, price, licno) values ('LAD123', 'LADA', 'Green', 1500, null);
insert into insurance.car(numplate, make, colour, price, licno) values ('ABZ123', 'SKODA', 'Black', 1000, null);

-- commented for now otherwise we delete everything
-- delete from insurance.driver; 
-- delete from insurance.car where price < 5000; 
-- delete from insurance.car where price < 5000 and colour = 'Red'; 
-- delete from insurance.car where price between 1000 and 3000; 

update insurance.car set make = 'Mercedes' where numplate = 'ABC123';


update insurance.car
set price = price * 1.15;

update insurance.car
set price = price * 0.5
where make = 'BMW' or make = 'Mercedes';

update insurance.driver
set name = 'Carla', gender = 'F'
where name = 'Carlo';

-- selects everything (all columns and rows) from car table
select * from insurance.car;

-- selects all columns from driver with a as second char
select * from insurance.driver where name like '_a__';

-- aggregate functions
select avg(price) from insurance.car where make = 'Skoda';
select max(price) from insurance.car;
select min(price) from insurance.car;
select sum(price) as 'Total Chogm revenue', avg(price) as 'Average Price' from insurance.car;

select count(name) from insurance.driver where gender = 'F';

select count(licno) from insurance.car;

select * from insurance.car where price > (select avg(price) from insurance.car);

select * from insurance.car order by price desc;

select * from insurance.driver order by surname, name;

select distinct gender from insurance.driver;


select gender, count(gender) from insurance.driver group by gender;

select make, count(price) from  insurance.car group by make having make = 'BMW' or make = 'LADA';
select make, count(price) from  insurance.car where make = 'BMW' or make = 'LADA' group by make;

-- cross product, almost never what we want
select c.numplate, c.make, d.name, d.surname, d.licno 
from insurance.car c, insurance.driver d;

-- where with join condition
select c.numplate, c.make, d.name, d.surname, d.licno 
from insurance.car c, insurance.driver d where c.licno = d.licno;

-- same as above, more modern syntax
select c.numplate, c.make, d.name, d.surname, d.licno 
from insurance.car c join insurance.driver d on c.licno = d.licno;

-- left outer join, gives us all cars (and drivers if present)
select c.numplate, c.make, d.name, d.surname, d.licno 
from insurance.car c left outer join  insurance.driver d on c.licno = d.licno;

-- left outer join, gives us all cars (and drivers if present)
select c.numplate, c.make, d.name, d.surname, d.licno 
from insurance.car c right outer join  insurance.driver d on c.licno = d.licno;

commit;
-- T h e   E n d  --


