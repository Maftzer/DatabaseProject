# SELECT с ограничаващо условие

select 
name as ItemName,
category as ItemCategory, 
price as ItemPrice
from items
where category = "Основно"
and price < 15;