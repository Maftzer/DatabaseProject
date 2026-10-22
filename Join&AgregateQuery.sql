# JOIN + Агрегатна функция
# Общият оборот, който всеки един сервитьор е реализирал, както и името на сервитьора и общата сума, като групирам по служител.

select employees.name, sum(orders.total_amount) as ObshtOborot
from employees 
join orders
on orders.employeeID = employees.id
group by employees.name, employees.id;
