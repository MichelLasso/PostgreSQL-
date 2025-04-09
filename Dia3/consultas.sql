---------------------------
--  CONSULTAS
---------------------------
-- 1. Listar los id de los usuarios que tengan la letra s
select id from usuarios where id ilike '%s%';

-- 2. listar los nombre de los usuarios
select nombre from usuarios;

-- 3. Listar el usuario de los usuarios
select usuario from usuarios;

-- 4. Mostrar usuarios
select * from usuarios;

-- 5. Ingresar datos a otra tabla
insert into credenciales(UserName, contrasena, user_rol)
select usuario, 'password' as contraseña, 'Usuario' as usuario from usuarios; 

-- 6. Mostrar los datos que se agregaron anteriormente de una tabla a otra
select * from credenciales;

-- 7. Mostrar los integrantes, que tienen una restricción de edad
select * from integrante;

-- 8. saber la cantidad de caracteres
select length('0123456789abcdefghijklmnopqrstuvwxyz.!');

-- 9. crear un numero aleatorio pero entero con el rango de los caracteres
select round(random()* 40);

-- 10. Crear un texto de manera aleatoria pero siguiendo los caracteres que estan dentro del substring.
select string_agg(substring('0123456789abcdefghijklmnopqrstuvwxyz.!', round(random()* 40)::integer, 1), '')from generate_series(1,5);
-- en esta parte usamos el generate_series como un delimitador de carcateres. pero tambien se podria usar desp del integer, en vez de  1 la cantidad q uno quiere

-- 11. Crear un texto de 5 caracteres sin el generate_series
select string_agg(substring('0123456789abcdefghijklmnopqrstuvwxyz.!', round(random()* 40)::integer, 5),'');

-- 12. genera 10 filas en donde el dato empieza desde 20 y disminue 1
select generate_series(20,10,-1);

-- 13. generar 10 filas con datos de 1 a 20 con salto de 3
select generate_series(1,10,3);

-- 14. Mostrar las contraseñas que se crearon conl afunción
select * from credenciales;

-- 15. no mostrar las contraseñas, ocultarlas porq no todos los usuarios no deberian ver las contraseñas de los demás
select sha512(contrasena::bytea), UserName from credenciales;

-- 16. Mostrar al usuario con la contraseña qkzxh7 tipo bytea y que tenga el nombre de dear46
select * from credenciales where sha512('qkzxh7'::bytea) =contrasena_sha  and UserName='dear46';
