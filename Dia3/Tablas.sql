---------------------------
--  TABLA
---------------------------
create type rol as enum('Usuario', 'Admin');

create table usuarios(
	id varchar(40) not null default gen_random_uuid(),
	nombre varchar(20) not null,
	apellido varchar(20) not null,
	correo varchar(150) not null,
	ip inet not null,
	ciudad varchar(50) not null,
	block text not null,
	usuario varchar(50) not null,
	siguiendo int not null,
	seguidores int not null
);

create table credenciales(
	UserName varchar(100) primary key,
	contrasena text not null,
	user_rol rol not null
);

-----------------
-- Crear una llave primaria si se nos olvida ingresarla al crear la tabla 
-------------
-- alter table credenciales add primary key (UserName);

-----------------
-- Crear una llave foranea si se nos olvida ingresarla al crear la tabla 
-------------
alter table usuarios add constraint fk_UserName foreign key (usuario) references credenciales(UserName);

create table integrante(
	id serial primary key,
	nombre varchar(30) not null,
	edad smallint not null check(edad >9)
);


------------
-- Ingresar un insert violando la restricción (EJECUTA ERROR!)
------------
insert into integrante(nombre, edad) values
('rafael', 11),
('pedro', 8); -- viola la restricción

---------------------
-- Inserción correcta
---------------------
insert into integrante(nombre, edad) values
('Rafael', 11);

---------------------
-- Crear una nueva columna
---------------------
update credenciales set contrasena = generate_ramdon_password(5);

---------------------
-- Insertar contraseña tipo bytea
---------------------
alter table credenciales add column contrasena_sha byTea null;

---------------------
-- Insertar los datos en la nueva columna
---------------------
update credenciales set contrasena_sha= sha512(contrasena::bytea);

-----------------
-- Crear un atributo si se nos olvida ingresarlo al crear la tabla 
-------------
-- alter table integrante add constraiint check_edad check(edad >9);

