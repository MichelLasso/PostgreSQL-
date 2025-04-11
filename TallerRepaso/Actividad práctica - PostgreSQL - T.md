#  🧑‍🏫 Actividad práctica - PostgreSQL

> *Triggers, Procedures, Functions, Views y Materialized Views.*



Basado en el siguiente **Diagrama Entidad-Relación** (`ER`), que representa un sistema de gestión de ventas con entidades como usuarios, productos, órdenes y detalles de órdenes, desarrolle las actividades propuestas a continuación. Estas tienen como objetivo aplicar conceptos fundamentales de `SQL` avanzado en `PostgreSQL`, haciendo uso de funciones (`FUNCTION`), procedimientos almacenados (`PROCEDURE`), y disparadores (`TRIGGER`) para gestionar operaciones de actualización, eliminación y auditoría de datos.
El propósito principal es fortalecer la capacidad para diseñar soluciones robustas y seguras que respondan a escenarios comunes en sistemas transaccionales reales.

![](https://i.ibb.co/6JrWq3v5/Screenshot-2025-04-10-142148.png)

## SQL Base

```sql
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
    PRIMARY KEY ("id")
);

CREATE TABLE order_details (
    "id" serial,
    "order_id" integer, 
    "product_id" integer,
    "quantity" smallint,
    "price" double precision CHECK (price > 0),
    PRIMARY KEY ("id")
);
```



## Reto: Auditoría de Ventas

**Propósito**: Registrar automáticamente cada venta realizada en una tabla de auditoría, con la ayuda de un `TRIGGER`, un `FUNCTION`, una `VIEW` y una `MATERIALIZED VIEW`.

1. Crea una tabla de auditoría

```sql
CREATE TABLE sales_audit (
  audit_id SERIAL PRIMARY KEY,
  order_id INT,
  user_id INT,
  total_value NUMERIC,
  audit_date TIMESTAMP DEFAULT NOW()
);
```

2. Cree una función que se active al insertar una nueva orden teniendo presente la siguiente instrucción SQL y las sugerencias.
   ```sql
   CREATE OR REPLACE FUNCTION fn_register_audit()
   RETURNS TRIGGER AS $$
   DECLARE
     total NUMERIC;
   BEGIN
   	-- Defina un SELECT para  obtener la información del total de la venta
   	-- Usa SUM() de quantity * price
   	-- Recuerda que puedes obtener los datos de la nueva orden con NEW e.g.
   	-- NEW.order_id
   	-- Recuerda el uso de -> INTO total
     
     
   	-- Registra los datos de auditoria en la tabla sales_audit 
   	-- Los values los puedes obtener con NEW e.g. 
   	-- NEW.order_id, NEW.user_id, total
   
     RETURN NEW;
   END;
   $$ LANGUAGE plpgsql;
   ```

3. Crea el `TRIGGER` asociado:
   ```sql
   CREATE TRIGGER trg_audit_sale
   AFTER INSERT ON orders
   FOR EACH ROW
   EXECUTE FUNCTION fn_register_audit();
   ```

   

4. Crea una `VIEW` que muestre el historial de ventas con información del usuario y total.
   ```sql
   -- Cree la vista teniendo presente la información de la tabla sales_audit 
   -- Datos sugeridos a mostrar -> audit_id, username, total_value, audit_date
   
   ```

   

5. Crea una `MATERIALIZED VIEW` que resuma los ingresos diarios.

   ```sql
   -- Cree la vista MATERIALIZED teniendo presente la información de la tabla sales_audit 
   -- Datos sugeridos a mostrar -> sale_date(DATE de audit_date), daily_total(Suma de los valores de total)
   -- Ten presente el GROUP BY y si requieres actualizar la vista puedes usar
   -- REFRESH MATERIALIZED VIEW mi_nombre_de_materialized_view;
   
   ```

   

## Reto: Gestión de Stock y Ventas con Procedimiento

**Propósito**: Automatizar el proceso de venta de productos mediante un `PROCEDURE` que reste el stock y registre la venta, apoyado con validaciones y consultas en una `VIEW`.

1. Crea un procedimiento llamado `prc_register_sale` que permita recibir los valores de `user_id`, `product_id` y `quantity`:
   ```sql
   CREATE OR REPLACE PROCEDURE prc_register_sale(
     p_user_id INT,
     p_product_id INT,
     p_quantity INT
   )
   LANGUAGE plpgsql
   AS $$
   DECLARE
     -- Define las variables requeridas aqui
   BEGIN
     -- Verificar stock
     SELECT stock INTO stock_actual FROM products WHERE product_id = p_product_id;
     IF stock_actual < p_quantity THEN
       RAISE EXCEPTION 'Stock insuficiente';
     END IF;
   	-- Pasos sugeridos:
     	-- 1. Registrar orden
     	-- 2. Registrar detalle
     	-- 3. Actualizar stock
   
   END;
   $$;
   ```

2. Crea una `VIEW` llamada `vw_products_low_stock` para mostrar productos con stock menor a 10:
   ```sql
   CREATE VIEW vw_products_low_stock AS
   SELECT column, column, column
   FROM table
   WHERE stock < 10;
   ```

3. Llama al procedimiento y observa la magia:
   ```sql
   CALL prc_register_sale(1, 3, 2);
   ```



## Reto: Control de Modificaciones en Pedidos

**Propósito:** Registrar cambios realizados sobre los pedidos (`orders`) mediante funciones, procedimientos y triggers, incluyendo auditoría de actualizaciones y bloqueos de eliminación.

- Tabla de auditoría de actualizaciones
  ```sql
  CREATE TABLE orders_update_log (
    log_id SERIAL PRIMARY KEY,
    order_id INT,
    old_user_id INT,
    new_user_id INT,
    old_order_date DATE,
    new_order_date DATE,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );
  ```

  

- Crea una `FUNCTION` para registrar actualizaciones de la tabla `orders`  teniendo presente la siguiente instrucción` SQL` y las sugerencias.
  ```sql
  CREATE OR REPLACE FUNCTION fn_log_order_update()
  RETURNS TRIGGER AS $$
  BEGIN
  	-- Insert
    RETURN NEW;
  END;
  $$ LANGUAGE plpgsql;
  ```

  

- Crea un ` TRIGGER` para registrar actualizaciones teniendo presente la siguiente instrucción `SQL` y las sugerencias.
  ```sql
  CREATE TRIGGER trg_log_order_update
  AFTER UPDATE ON orders
  FOR EACH ROW
  -- Cuando la fecha de la orden o el usuario cambie.
  -- Usa WHEN, OLD y NEW.
  EXECUTE FUNCTION fn_log_order_update();
  ```

  

- Crea una `FUNCTION` para evitar eliminación si el pedido ya tiene detalles teniendo presente la siguiente instrucción `SQL` y las sugerencias.
  ```sql
  CREATE OR REPLACE FUNCTION fn_prevent_order_delete()
  RETURNS TRIGGER AS $$
  DECLARE
    exists_detail BOOLEAN;
  BEGIN
  	-- Valida si existe un detalle asociado al pedido con OLD
  
    IF exists_detail THEN
      -- Usa RAISE para mostrar un mensaje adecuado.
    END IF;
  
    RETURN OLD;
  END;
  $$ LANGUAGE plpgsql;
  ```

  

-  Crea un `TRIGGER` para bloquear eliminación teniendo presente la siguiente instrucción `SQL` y las sugerencias.
  ```sql
  CREATE TRIGGER trg_prevent_order_delete
  -- Completa.
  FOR EACH ROW
  -- Completa.
  ```

  

- Crea dos `PROCEDURE` para actualizar pedidos de forma controlada para cuando se cambie de `user_id` y de `order_date` de la tabla `orders` .
  ```sql
  CREATE OR REPLACE PROCEDURE prc_update_order_user(
    p_order_id INT,
    p_new_user_id INT
  )
  LANGUAGE plpgsql
  AS $$
  BEGIN
    UPDATE orders
  	-- Completa
  END;
  $$;
  
  CREATE OR REPLACE PROCEDURE prc_update_order_user(
    p_order_date DATE,
    p_order_id INT
  )
  LANGUAGE plpgsql
  AS $$
  BEGIN
    UPDATE orders
  	-- Completa
  END;
  $$;
  ```

  