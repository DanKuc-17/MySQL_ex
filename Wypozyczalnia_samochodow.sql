create database rental_db;

use rental_db;

create table customer (cust_id smallint unsigned not null primary key auto_increment, first_name varchar(15) not null,
last_name varchar(15) not null, addres varchar(30) not null,  postal_code varchar(6) not null);

create table car (reg_number varchar(8) not null primary key, mark varchar(15) not null, model varchar(15) not null, 
rate tinyint not null default '1');

create table rent (rent_id smallint unsigned not null primary key auto_increment, cust_id smallint unsigned  not null, 
foreign key(cust_id) references customer(cust_id), reg_number varchar(8) not null, foreign key(reg_number) references car(reg_number),
 rent_date date not null, return_date date);
 
 alter table customer add email varchar(30);
 
 alter table customer modify last_name varchar(25);
 
 insert into customer(first_name, last_name, addres, postal_code, email) values('Adam', 'Nowak', 'Malinowa 15','40-101', 'adam.nowak@o2.pl');
 insert into customer(first_name, last_name, addres, postal_code, email) values('Ewa', 'Zabawa', 'Agrestowa 1','41-100', 'ewa.zabawa@wp.pl');
 insert into customer(first_name, last_name, addres, postal_code) values('Leszek', 'Szczotka', 'Mieszka 1','41-130');
 insert into customer(first_name, last_name, addres, postal_code, email) values('Celina', 'Kowal', 'Centralna 10','41-111', 'celina.kowal@gmail.com');

insert into car values ('SK 12345', 'Toyota', 'Yaris', 4);
insert into car values ('SI 60606', 'Fiat', '126p', 1);
insert into car values ('SL234455', 'Opel', 'Astra', 8);
insert into car values ('SJ 00001', 'Fiat', '125p', 1);
insert into car values ('SB 00002', 'FSO', 'Syrena', 1);

insert into rent(cust_id, reg_number, rent_date, return_date) values(1, 'SK 12345', '2015-01-01', '2015-02-03');
insert into rent(cust_id, reg_number, rent_date) values(1, 'SL234455', '2015-02-05');
insert into rent(cust_id, reg_number, rent_date, return_date) values(2, 'SI 60606', '2015-03-07', '2016-03-08');
insert into rent(cust_id, reg_number, rent_date, return_date) values(3, 'SL234455', '2014-03-05', '2015-02-01');
insert into rent(cust_id, reg_number, rent_date, return_date) values(3, 'SK 12345', '2016-03-05', '2016-12-01');

select * from rent;
select * from customer limit 3;
select distinct reg_number from rent;

select mark from car order by mark asc;
select model as marka_samochodu from car;
select rent_date from rent order by rent_date asc limit 1;

select concat(lower(first_name), ' ', upper(last_name)) from customer limit 3;
select upper(reg_number), length(mark) from car limit 2;
select substring(first_name,1,4) from customer;

select now();
select datediff(return_date, rent_date) from rent;
select max(rent_date) from rent;

select max(rent_date), min(rent_date) from rent;
select reg_number, count(*) from rent group by reg_number;
select reg_number, count(*) from rent group by reg_number having count(*) > 1;

select reg_number from rent where rent_date = '2014-03-05';
select mark from car where mark <> 'Fiat';
select reg_number from car where reg_number <> 'SI 60606' and reg_number <> 'SL234455';
select model from car where model like '%p';
select reg_number from rent where rent_date >= '2015-01-05' and rent_date <= '2015-12-31';

select distinct c.first_name, c.last_name, r.reg_number from customer c join rent r on c.cust_id = r.cust_id;
select c.model, count(*) from car c join rent r on c.reg_number = r.reg_number group by r.reg_number;
select distinct c.last_name, r.reg_number from customer c left join rent r on c.cust_id = r.cust_id;
select c.reg_number, r.rent_date from car c left join rent r on c.reg_number = r.reg_number;
select reg_number from car union select reg_number from rent;

select mark, model from car where rate > (select avg(rate) from car);
select mark, model from car c where reg_number > 
(select reg_number from rent r  where c.reg_number = r.reg_number group by count(reg_number) > 1);

update rent set cust_id = 4 where rent_date = '2016-03-05';
update car set rate = 2 where rate = 1;
update customer set email = 'leszek.szczotka@o3.pl' where first_name = 'Leszek';

delete from car where reg_number = 'SB 00002';
delete from rent where cust_id = 4;
delete from customer where first_name = 'Adam' and last_name = 'Nowak';

create index first_last_name_idx on customer (first_name, last_name);
create index mark_idx on car (mark);
drop index first_last_name_idx on customer;

create view customer_rents as select c.first_name, c.last_name, r.reg_number, r.rent_date, r.return_date 
from customer c join rent r on c.cust_id = r.cust_id;
select * from customer_rents where return_date is null;

create table rent_log (log_id smallint unsigned not null primary key auto_increment, log_date timestamp not null default current_timestamp, 
description varchar(50) not null);

create trigger car_add_trg after insert on car for each row insert into rent_log (description) 
values (concat('Nowy samochód o nr rejestracyjnym: ', new.reg_number));

insert into car values ('DI 00023', 'BMW', 'M3', 10);

create user 'sda' identified by 'sda_pass';
grant all privileges on rental_db.* to sda;
flush privileges;
revoke insert on rental_db.car from sda;
