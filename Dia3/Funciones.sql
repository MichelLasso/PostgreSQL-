----------------------
-- FUNCIONES
----------------------

----------------------
-- 1. 
create function generate_ramdon_password(long INTEGER)
returns text as $$ 
declare password text;
BEGIN
	password = (SELECT string_agg(SUBSTRING('0123456789abcdefghijklmnñopqrstuvwxyz$.!', round(random() * length('0123456789abcdefghijklmnñopqrstuvwxyz$.!'))::integer, 1), '') as NewPassword 
	FROM generate_series(0, long));
	return password;
END;
$$ LANGUAGE plpgsql;

-- prueba
select generate_ramdon_password(1);
-------------

-------------
-- 2. Función de suma con parametros
create function sumar(n1 integer, n2 integer)
returns integer as $$
begin
	return n1 + n2;
end;
$$ language plpgsql;

-- Probar la función
select sumar(10,5);
---------------