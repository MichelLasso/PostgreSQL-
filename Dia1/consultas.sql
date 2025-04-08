-----------------------------
-- Consultas sobre una tabla
-----------------------------

-- 1. Lista el nombre de todos los productos que hay en la tabla producto
select nombre from producto;

-- 2. Lista los nombres y los precios de todos los productos de la tabla producto.
select nombre, precio from producto;

-- 3. Lista todas las columnas de la tabla producto.
select codigo, nombre, precio_euros,precio_dolares, codigo_fabricante from producto;

-- 4. Lista el nombre de los productos, el precio en euros y el precio en dólares 
-- estadounidenses (USD).
select codigo, nombre, precio_euros,precio_dolares, codigo_fabricante from producto;

-- 5. Lista el nombre de los productos, el precio en euros y el precio en dólares 
-- estadounidenses (USD). Utiliza los siguientes alias para las columnas: nombre 
-- de producto, euros, dólares.
select nombre as nombre_de_producto, precio_euros as euros, precio_dolares as dolares from producto;

-- 6. Lista los nombres y los precios de todos los productos de la tabla producto, 
-- convirtiendo los nombres a mayúscula.
select upper(nombre),precio_euros,precio_dolares from producto;

-- 7. Lista los nombres y los precios de todos los productos de la tabla producto, 
-- convirtiendo los nombres a minúscula.
select upper(nombre),precio_euros,precio_dolares from producto;

-- 8. Lista el nombre de todos los fabricantes en una columna, y en otra columna 
-- obtenga en mayúsculas los dos primeros caracteres del nombre del 
-- fabricante.
select nombre, upper(substr(nombre, 1,2)) from fabricante;

-- 9. Lista los nombres y los precios de todos los productos de la tabla producto, 
-- redondeando el valor del precio.
select nombre, ceil(precio_euros), precio_euros from producto;

-- 10. Lista los nombres y los precios de todos los productos de la tabla producto, 
-- truncando el valor del precio para mostrarlo sin ninguna cifra decimal.
select nombre, trunc(precio_euros) from producto;

-- 11. Lista el identificador de los fabricantes que tienen productos en la 
-- tabla producto
select codigo_fabricante from producto;

-- 12. Lista el identificador de los fabricantes que tienen productos en la 
-- tabla producto, eliminando los identificadores que aparecen repetidos.
select distinct codigo_fabricante from producto;

-- 13. Lista los nombres de los fabricantes ordenados de forma ascendente.
select nombre from fabricante order by nombre asc;

-- 14. Lista los nombres de los fabricantes ordenados de forma descendente.
select nombre from fabricante order by nombre desc;

-- 15. Lista los nombres de los productos ordenados en primer lugar por el 
-- nombre de forma ascendente y en segundo lugar por el precio de forma 
-- descendente.
select nombre, precio_euros from producto order by 1 asc, 2 desc;

-- 16. Devuelve una lista con las 5 primeras filas de la tabla fabricante.
select nombre from fabricante limit 5;

-- 17. Devuelve una lista con 2 filas a partir de la cuarta fila de la tabla fabricante. 
-- La cuarta fila también se debe incluir en la respuesta.
select nombre from fabricante offset 3 limit 2;

-- 18. Lista el nombre y el precio del producto más barato. (Utilice solamente las 
-- cláusulas ORDER BY y LIMIT)
select nombre, precio_euros from producto order by 2 asc limit 1;

-- 19. Lista el nombre y el precio del producto más caro. (Utilice solamente las 
-- cláusulas ORDER BY y LIMIT)
select nombre, precio_euros from producto order by 2 desc limit 1;

-- 20. Lista el nombre de todos los productos del fabricante cuyo identificador de 
-- fabricante es igual a 2.
select nombre from producto where codigo_fabricante=2;

-- 21. Lista el nombre de los productos que tienen un precio menor o igual a 120€.
select nombre from producto where precio_euros=120;

-- 22. Lista el nombre de los productos que tienen un precio mayor o igual a 400€.
select nombre from producto where precio_euros=400;

-- 23. Lista el nombre de los productos que no tienen un precio mayor o igual a 
-- 400€
select nombre from producto where precio_euros <=400;

-- 24. Lista todos los productos que tengan un precio entre 80€ y 300€. Sin utilizar 
-- el operador BETWEEN.
select * from producto where precio_euros >=80 and precio_euros <=300;

-- 25. Lista todos los productos que tengan un precio entre 60€ y 200€. Utilizando 
-- el operador BETWEEN.
select * from producto where precio_euros >=60 and precio_euros <=600;

-- 26. Lista todos los productos que tengan un precio mayor que 200€ y que el 
-- identificador de fabricante sea igual a 6.
select * from producto where precio_euros >200 and codigo_fabricante=6;

-- 27. Lista todos los productos donde el identificador de fabricante sea 1, 3 o 5. 
-- Sin utilizar el operador IN. 
select * from producto where codigo_fabricante=1 or codigo_fabricante=3 or codigo_fabricante=5;

-- 28. Lista todos los productos donde el identificador de fabricante sea 1, 3 o 5. 
-- Utilizando el operador IN.
select * from producto where codigo_fabricante=1 or codigo_fabricante=3 or codigo_fabricante=5;

-- 29. Lista el nombre y el precio de los productos en céntimos (Habrá que 
-- multiplicar por 100 el valor del precio). Cree un alias para la columna que 
-- contiene el precio que se llame céntimos
select nombre, (precio_euros * 100) as centimos from producto;

-- 30. Lista los nombres de los fabricantes cuyo nombre empiece por la letra S.
select nombre from fabricante where nombre ilike 'S%';

-- 31. Lista los nombres de los fabricantes cuyo nombre termine por la vocal e.
select nombre from fabricante where nombre ilike '%e';

-- 32. Lista los nombres de los fabricantes cuyo nombre contenga el carácter w.
select nombre from fabricante where nombre ilike '%w%';

-- 33. Lista los nombres de los fabricantes cuyo nombre sea de 4 caracteres.
select nombre from fabricante where length(nombre)=4;

-- 34. Devuelve una lista con el nombre de todos los productos que contienen la 
-- cadena Portátil en el nombre.
select nombre from producto where nombre ilike '%Portátil%';

-- 35. Devuelve una lista con el nombre de todos los productos que contienen la 
-- pcadena Monitor en el nombre y tienen un precio inferior a 215 €.
select nombre from producto where nombre ilike '%Monitor%' and precio_euros <215;

-- 36. Lista el nombre y el precio de todos los productos que tengan un precio 
-- mayor o igual a 180€. Ordene el resultado en primer lugar por el precio (en 
-- orden descendente) y en segundo lugar por el nombre (en orden 
-- ascendente).
select nombre, precio_euros from producto where precio_euros>=180 order by 2 desc, 1 asc;

----------------------------------------------
-- Consultas multitabla (Composición interna)
----------------------------------------------
-- 1. Devuelve una lista con el nombre del producto, precio y nombre de 
-- fabricante de todos los productos de la base de datos.
select producto.nombre, precio_euros, fabricante.nombre from producto inner join fabricante on producto.codigo_fabricante=fabricante.codigo;

-- 2. Devuelve una lista con el nombre del producto, precio y nombre de 
-- fabricante de todos los productos de la base de datos. Ordene el resultado 
-- por el nombre del fabricante, por orden alfabético.
select producto.nombre, precio_euros, fabricante.nombre from producto inner join fabricante on producto.codigo_fabricante=fabricante.codigo
order by 3 asc;

-- 3. Devuelve una lista con el identificador del producto, nombre del producto, 
-- identificador del fabricante y nombre del fabricante, de todos los productos 
-- de la base de datos.
select producto.codigo, producto.nombre, fabricante.codigo, fabricante.nombre from producto
inner join fabricante on producto.codigo_fabricante= fabricante.codigo;

-- 4. Devuelve el nombre del producto, su precio y el nombre de su fabricante, 
-- del producto más barato.
select producto.nombre, precio_euros, fabricante.nombre from producto 
inner join fabricante on producto.codigo_fabricante=fabricante.codigo
order by 2 asc limit 1;

-- 5. Devuelve el nombre del producto, su precio y el nombre de su fabricante, 
-- del producto más caro.
select producto.nombre, precio_euros, fabricante.nombre from producto 
inner join fabricante on producto.codigo_fabricante=fabricante.codigo
order by 2 desc limit 1;

-- 6. Devuelve una lista de todos los productos del fabricante Lenovo.
select * from producto 
inner join fabricante on producto.codigo_fabricante= fabricante.codigo 
where fabricante.nombre= 'Lenovo';

-- 7. Devuelve una lista de todos los productos del fabricante Crucial que tengan 
-- un precio mayor que 200€.
select * from producto 
inner join fabricante on producto.codigo_fabricante= fabricante.codigo 
where precio_euros<200;

-- 8. Devuelve un listado con todos los productos de los 
-- fabricantes Asus, Hewlett-Packard y Seagate. Sin utilizar el operador IN.
select * from producto 
inner join fabricante on producto.codigo_fabricante= fabricante.codigo 
where fabricante.nombre= 'Asus' or fabricante.nombre= 'Hewlett-Packard' or fabricante.nombre='Seagate';

-- 9. Devuelve un listado con todos los productos de los 
-- fabricantes Asus, Hewlett-Packard y Seagate. Utilizando el operador IN.
select * from producto 
inner join fabricante on producto.codigo_fabricante= fabricante.codigo 
where fabricante.nombre= 'Asus' or fabricante.nombre= 'Hewlett-Packard' or fabricante.nombre='Seagate';

-- 10. Devuelve un listado con el nombre y el precio de todos los productos de los 
-- fabricantes cuyo nombre termine por la vocal e.
select producto.nombre, producto.precio_euros from producto 
inner join fabricante on producto.codigo_fabricante= fabricante.codigo 
where fabricante.nombre ilike'%e';

-- 11. Devuelve un listado con el nombre y el precio de todos los productos cuyo 
-- nombre de fabricante contenga el carácter w en su nombre.
select producto.nombre, producto.precio_euros from producto 
inner join fabricante on producto.codigo_fabricante= fabricante.codigo 
where fabricante.nombre ilike'%w%';

-- 12. Devuelve un listado con el nombre de producto, precio y nombre de 
-- fabricante, de todos los productos que tengan un precio mayor o igual a 
-- 180€. Ordene el resultado en primer lugar por el precio (en orden 
-- descendente) y en segundo lugar por el nombre (en orden ascendente)
select producto.nombre, producto.precio_euros ,fabricante.nombre from producto 
inner join fabricante on producto.codigo_fabricante= fabricante.codigo 
where precio_euros >=180 order by 2 desc , 1 asc;

-- 13. Devuelve un listado con el identificador y el nombre de fabricante, 
-- solamente de aquellos fabricantes que tienen productos asociados en la 
-- base de datos.
select fabricante.nombre, fabricante.codigo  from producto 
inner join fabricante on producto.codigo_fabricante= fabricante.codigo;