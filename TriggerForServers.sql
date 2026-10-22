delimiter $

create trigger OnlyServerCanTakeOrders before insert on orders
for each row
begin
	declare emp_role varchar(50);
    
    select roles.name into emp_role
    from employees
    join roles on role.id = employees.roleID
    where employees.id = new.employeeID;
    
    if (emp_role != "Сервитьор") then
		signal sqlstate "45000" set message_text = "Само сервитьор може да поема поръчки";
	end if;
    
    
    
end; $

delimiter ;


