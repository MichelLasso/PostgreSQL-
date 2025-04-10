----------
-- VISTAS
----------

-- Vista 1
create view stock_price_client as
select sum(stock_price*stock), name from full_order_info group by 2;

-- Probar vista
-- 1. Mostrar todos las columnas de todos los productos
select * from stock_price_client;

-- 2. Mostrar todas las columnas de un producto en especifico
select * from stock_price_client where name='Webcam'; 

-- Eliminar vista
-- drop view stock_price_client;
--------------------------------

-- vista 2
create materialized view stock_avg as
select sum(stock_price) as stock_price, sum(stock) as stock, stockmin, stockmax, name from full_order_info group by 3,4,5;

-- Actualizar esa vista
refresh materialized view stock_avg;

-- Probar la vista materializada
select * from stock_avg;

-- Eliminar vista
-- drop materialized view stock_avg;