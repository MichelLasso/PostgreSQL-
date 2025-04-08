---------------------------
--  TABLA
---------------------------
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
