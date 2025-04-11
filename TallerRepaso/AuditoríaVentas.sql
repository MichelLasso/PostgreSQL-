----------------------------
-- Reto: Auditoría de Ventas
----------------------------
-- Registrar automáticamente cada venta realizada en una tabla de auditoría, 
-- con la ayuda de un `TRIGGER`, un `FUNCTION`, una `VIEW` y una `MATERIALIZED VIEW`.

-- 1. Crea una tabla de auditoría

CREATE TABLE sales_audit (
  audit_id SERIAL PRIMARY KEY,
  order_id INT,
  user_id INT,
  total_value NUMERIC default 0,
  audit_date TIMESTAMP DEFAULT NOW()
);

alter table sales_audit alter column user_id type character varying;

select * from order_details;
select sum(quantity* price), order_id from order_details group by 2;

-- 2. Cree una función que se active al insertar una nueva orden teniendo presente 
-- la siguiente instrucción SQL y las sugerencias.

create or replace function fn_register_audit(NEWid_order int)
returns void as $$
declare
	total numeric;
	idUser character varying;
begin
	select sum(quantity* price), user_id into total , idUser from order_details 
	inner join orders on order_details.order_id=orders.id where orders.id=NEWid_order
	group by 2;
	
	insert into sales_audit (order_id,user_id,total_value,audit_date) 
	values(NEWid_order, idUser, total, current_date);
end;
$$ language plpgsql;

create or replace function fn_insert_details()
returns trigger as $$
begin
	perform fn_register_audit(new.order_id);
	return new;
end;
$$ language plpgsql;

-- rollback;

-- 3. Crea el trigger asociado
create trigger trg_audit_sale
after insert on order_details
for each row 
execute function fn_insert_details();

-- inserción de prueba
--INSERT INTO orders ("id", "orderdate", "user_id")
--VALUES (12, '2025-02-13', '00001');

--INSERT INTO order_details ("id", "order_id", "product_id", "quantity", "price")
--VALUES (14, 10, 9, 5, 544.2);

-- Hacer una consulta para ver si insertó
-- select * from sales_audit;

-- eliminar datos de prueba
-- delete from sales_audit;

-- Probar consulta para la vista
-- select audit_id,first_name, total_value,audit_date from sales_audit
-- inner join users on sales_audit.user_id=users.id;

-- 4. Crea una `VIEW` que muestre el historial de ventas con información del usuario y total.
create view view_purchase_users as 
select audit_id,first_name, total_value,audit_date from sales_audit
inner join users on sales_audit.user_id=users.id;

-- probar vista
select * from view_purchase_users;

-- Probar consulta
-- select sum(total_value), audit_date  from view_purchase_users
-- group by 2;

-- 5. Crea una `MATERIALIZED VIEW` que resuma los ingresos diarios.
create materialized view view_materialized as
select sum(total_value), audit_date  from view_purchase_users
group by 2;

-- Mostrar la vista materialized
select * from view_materialized;

-- Refrescar los datos de la vista
-- refresh materialized view view_materialized;