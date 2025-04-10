------------
-- Consultas
------------

-- Calcular el dinero total que se ha invertido en el stock, por un cliente
select sum(stock_price*stock) as total$  from full_order_info where user_id='5';

-- Calcular el dinero total que se ha invertido en el stock, de cada cliente
select sum(stock_price*stock), user_id, name from full_order_info group by 2,3;


select user_id, users.first_name,orders.orderdate from users left outer join 
orders on users.id=orders.user_id where orders.id is null;
