# вложен select

select
products.name as ProdName
from products
where products.id in ( 
					select productID
                    from item_products
                    where itemID in ( 
									select id
                                    from items
                                    where name = "Шопска салата"
									)

					);