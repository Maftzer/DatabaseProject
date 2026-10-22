# Тригер

delimiter $
create trigger after_salarypayment_update after update on salarypayments 
for each row
begin
insert into salarypayments_log(
operation,
old_employee_id,
new_employee_id ,
old_month,
new_month,
old_year,
new_year,
old_salary_amount,
new_salary_amount,
old_date_of_payment,
new_date_of_payment,
date_of_log)
values(
"UPDATE",
old.employeeID,
case new.employeeID when old.employeeID then NULL else new.employeeID end,
old.month,
case new.month when old.month then NULL else new.month end,
old.year,
case new.year when old.year then NULL else new.year end,
old.salaryAmount,
case new.salaryAmount when old.salaryAmount then NULL else new.salaryAmount end,
old.date_of_payment,
case new.date_of_payment when old.date_of_payment then NULL else new.date_of_payment end,
now());

end $

delimiter ;

