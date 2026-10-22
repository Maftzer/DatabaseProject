# OUTER JOIN
# Списък с имената на всички ястия/напитки от менюто и имената на алергените, които съдържат, както и тези, които нямат алергени


select 
items.name, 
allergens.name
from items
left outer join item_allergens
on items.id = item_allergens.itemID
left outer join allergens 
on allergens.id = item_allergens.allergenID;
