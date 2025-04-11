CREATE TABLE users (
    "id" varchar(20),
    "first_name" character varying(50) NOT NULL,
    "last_name" character varying(50) NOT NULL,
    "email" character varying(50) NOT NULL UNIQUE,
    "last_connection" character varying(100) NOT NULL,
    "website" character varying(100) NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE products (
    "id" serial,
    "name" character varying(50) NOT NULL,
    "description" TEXT,
    "stock" integer CHECK (stock > 0),
    "price" double precision CHECK (price > 0),
    "stockmin" integer,
    "stockmax" integer,
    PRIMARY KEY ("id")
);

CREATE TABLE orders (
    "id" serial,
    "orderdate" date,
    "user_id" character varying(50) NOT NULL,
    PRIMARY KEY ("id"),
	foreign key(user_id) references users(id)
);

CREATE TABLE order_details (
    "id" serial,
    "order_id" integer, 
    "product_id" integer,
    "quantity" smallint,
    "price" double precision CHECK (price > 0),
    PRIMARY KEY ("id"),
	foreign key(product_id) references products(id),
	foreign key(order_id) references orders(id)
);