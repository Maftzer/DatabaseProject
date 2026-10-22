# INNER JOIN
# Заявка, която извежда имената и точното наименование на длъжността на всеки служител.

select 
employees.name, 
roles.rolename
from employees join roles
where employees.roleID = roles.id;