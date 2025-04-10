----------
-- TABLAS
----------

create table full_order_info(
	order_id serial primary key,
	product_id integer not null,
	quantity smallint not null,
	price numeric(10,2) not null,
	orderdate date not null,
	user_id varchar(10) not null,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	email varchar(50) not null,
	last_connection inet,
	webside varchar(150),
	name varchar(50),
	descripcion text not null,
	stock smallint default 0,
	stock_price numeric(10,2) not null,
	stock_min smallint default 0,
	stock_max smallint default 0
);
-- cambiar el nombre de una tabla
alter table full_order_info rename column stock_min to stockmin;
alter table full_order_info rename column stock_max to stockmax;
alter table full_order_info rename column webside to website;
alter table full_order_info rename column descripcion to description;

-- cambiar los tipos
alter table full_order_info alter column stockmin type integer;

create table users(
	id varchar(5) primary key,
	first_name varchar(30) not null,
	last_name varchar(30) not null,
	email varchar(60) not null,
	last_connection inet not null,
	website text not null
);

create table products(
	name varchar(30) not null,
	description text not null,
	stock integer not null,
	price numeric(10,2) not null,
	stockmin integer not null,
	stockmax integer not null
);

-- Agregar columna id como llave primaria
alter table products add column id serial primary key;

create table orders(
	id serial primary key,
	orderdate date not null,
	user_id varchar(5) not null,
	foreign key (user_id) references users(id)
);

create table orders_details(
	id serial primary key,
	order_id integer not null,
	product_id integer not null,
	quantity integer not null,
	price numeric(10,2) not null,
	foreign key(order_id) references orders(id),
	foreign key(product_id) references products(id)
);

-- cambiar el nombre para las inserciones
alter table orders_details rename  to order_details;
