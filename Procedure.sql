delimiter $
create procedure NightShift(in target_month int, in target_year year)
begin
	declare beforeupdaterows int;
    declare afterupdaterows int;
   
    declare temp_emp_id int;
    declare nightOrderCount int;
    declare bonusPerOrder decimal(4,2) default 2.5;
    declare done int;
    
    declare order_cursor cursor for
		select orders.employeeID, count(*)
        from orders
        where month(order_time) = target_month
        and year(order_time) = target_year
        and (TIME(order_time) >= '22:00:00' or time(order_time) <= '02:00:00')
        and is_night_bonus_paid = 0
        group by employeeID;

    declare continue handler for not found set done = 1;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        SELECT 'Възникна SQL грешка!' AS ErrorMessage;
    END;

    drop temporary table if exists tempBonus;
    create temporary table tempBonus(
		id int primary key auto_increment,
        employeeID int,
        ordersAmount int,
        totalBonus decimal(10,2),
        bonusMonth int,
        bonusYear year
    ) Engine = Memory;

	select count(*) into beforeupdaterows
    from orders
    where month(order_time) = target_month
        and year(order_time) = target_year
        and (TIME(order_time) >= '22:00:00' or time(order_time) <= '02:00:00')
        and is_night_bonus_paid = 0;
	
		
    
	start transaction;
    
    set done = 0;
    open order_cursor;
    
    while_label: while(done = 0) do
		fetch order_cursor into temp_emp_id, nightordercount;
        if(done = 1) then
			leave while_label;
		else

			insert into tempBonus(employeeID, ordersAmount,totalBonus, bonusMonth, bonusYear)
			values(temp_emp_id, nightOrderCount,nightOrderCount*bonusPerOrder, target_month, target_year);
            
		end if;
        
	end while;
    
    close order_cursor;
    
    insert into salarypayments(employeeID, month, year, salaryAmount, date_of_payment)
    select tempBonus.employeeID, bonusMonth, bonusYear, totalBonus, now()
    from tempBonus
	on duplicate key update
		salaryAmount = salaryAmount + values(salaryAmount),
		date_of_payment = now();
        
	update orders
    set is_night_bonus_paid = 1
    where month(order_time) = target_month
        and year(order_time) = target_year
        and (time(order_time) >= '22:00:00' or time(order_time) <= '02:00:00')
        and is_night_bonus_paid = 0;

    
	select row_count() into afterupdaterows;
    
    if(beforeupdaterows = afterupdaterows) then
		commit;
	else
		rollback;
	end if;
    
    drop table tempBonus;

end $

delimiter ;
