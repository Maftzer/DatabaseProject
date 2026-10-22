# Агрегатна функция и GROUP BY
# Sписък с всички категории в менюто, броя артикули във всяка една от тях и средната цена на всички продукти в една категория, като включва категории с повече от един продукт

select 
items.category, 
count(*) as ItemsCount, 
round(avg(items.price),2) as AvgPrice
from items
group by items.category;