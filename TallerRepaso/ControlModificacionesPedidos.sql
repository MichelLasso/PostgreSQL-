--------------------------------------------
--Reto: Control de Modificaciones en Pedidos
--------------------------------------------

-- Registrar cambios realizados sobre los pedidos (`orders`) mediante funciones, 
-- procedimientos y triggers, incluyendo auditoría de actualizaciones y bloqueos 
-- de eliminación.

-- 1.Tabla de auditoría de actualizaciones
  CREATE TABLE orders_update_log (
    log_id SERIAL PRIMARY KEY,
    order_id INT,
    old_user_id INT,
    new_user_id INT,
    old_order_date DATE,
    new_order_date DATE,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

alter table orders_update_log alter column old_user_id type character varying;
alter table orders_update_log alter column new_user_id type character varying;

 -- 2. Crea una `FUNCTION` para registrar actualizaciones de la tabla `orders`  
 -- teniendo presente la siguiente instrucción` SQL` y las sugerencias.

create or replace function fn_log_order_update()
returns trigger as $$
begin

	insert into orders_update_log(order_id,old_user_id,new_user_id,old_order_date,new_order_date,changed_at) 
	values(new.id, old.user_id, new.user_id, old.orderdate, new.orderdate, current_timestamp);
	
	return new;
end;
$$ language plpgsql;

-- 3.Crea un ` TRIGGER` para registrar actualizaciones teniendo presente 
-- la siguiente instrucción `SQL` y las sugerencias.
create or replace trigger trg_log_order_update
after update on orders
for each row
	when (old.orderdate is distinct from new.orderdate or old.user_id=new.user_id)
execute function fn_log_order_update();

-- probar trigger
update orders set orderdate ='2025-01-01' where id=1;

-- consulta
select * from orders;

-- consulta en la tabla nueva
select * from orders_update_log;

-- 4. Crea una `FUNCTION` para evitar eliminación si el pedido ya tiene 
-- detalles teniendo presente la siguiente instrucción `SQL` y las sugerencias.

create or replace function fn_prevent_order_delete()
returns trigger as $$
declare 
	exists_detail boolean;
begin
	select 1 into exists_detail from orders inner join order_details
	on orders.id= order_details.order_id where order_id=old.id;

	if exists_detail then
		raise exception 'ADVERTENCIA: El registro no puede ser eliminado porque tiene detalles';
	end if;
	return old;
end;
$$ language plpgsql;

-- 5. Crea un `TRIGGER` para bloquear eliminación teniendo presente la 
-- siguiente instrucción `SQL` y las sugerencias.
create trigger trg_prevent_order_delete
before delete on orders
for each row
execute function fn_prevent_order_delete();

-- probar
delete from orders where id=4;

-- mostrar
select * from orders;

-- Crea dos `PROCEDURE` para actualizar pedidos de forma controlada para 
-- cuando se cambie de `user_id` y de `order_date` de la tabla `orders` .

-- FUNCION 1
create or replace procedure prc_update_order_user(p_order_id int, p_new_user_id character varying)
language plpgsql
as $$
begin
	update orders set user_id= p_new_user_id where id= p_order_id;
end;
$$;

-- probar
call prc_update_order_user(2,'00001');

-- mostrar
select * from orders;

-- FUNCION 2
create or replace procedure prc_update_order_user(p_order_date date, p_order_id int)
language plpgsql
as $$
begin
	update orders set orderdate= p_order_date where id= p_order_id;
end;
$$;

-- probar
call prc_update_order_user('2025-03-03', 2);

-- mostrar
select * from orders;