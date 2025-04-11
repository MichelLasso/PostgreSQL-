-----------------------------------------------------
-- Reto: Gestión de Stock y Ventas con Procedimiento
-----------------------------------------------------
-- Automatizar el proceso de venta de productos mediante un `PROCEDURE` que reste 
-- el stock y registre la venta, apoyado con validaciones y consultas en una `VIEW`.

-- 1. Crea un procedimiento llamado `prc_register_sale` que permita recibir los 
-- valores de `user_id`, `product_id` y `quantity`

create or replace procedure prc_register_sale(p_user_id character varying, p_product_id int, p_quantity int)
language plpgsql
as $$
declare 
	stock_actual integer;
	idOrder int;
	Qprice double precision;
	newStock integer;
begin
	select stock, sum(p_quantity* price) into stock_actual,Qprice from products where id = p_product_id
	group by 1;
	
	if stock_actual < p_quantity then raise exception 'Stock insuficiente';
	end if;

	insert into orders (orderdate, user_id) values
	(current_date, p_user_id);

	select id into idOrder from orders order by 1 desc;
	
	insert into order_details(order_id, product_id, quantity,price)
	values (idOrder, p_product_id, p_quantity, Qprice);

	select stock - p_quantity into newStock from products where id= p_product_id; 
	update products set stock = newStock where id=p_product_id ;
end ;
$$;


-- 2. Crea una `VIEW` llamada `vw_products_low_stock` para mostrar productos 
-- con stock menor a 10:
create view vw_products_low_stock as
select name, stock , price from products where stock<10;

select * from vw_products_low_stock;

-- 3. Llama al procedimiento y observa la magia:
call prc_register_sale('00001',5,2);

select * from orders;
select * from order_details;
select * from products;