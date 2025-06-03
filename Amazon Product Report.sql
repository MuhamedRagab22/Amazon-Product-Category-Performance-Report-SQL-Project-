create view AmazonProductReport as 
with productavilability as (
select 
category_name,
p.category_id as ids ,
count(asin) as productsAvaliable,
SUM(CASE 
	WHEN isBestSeller = 'True' THEN 1 
	ELSE 0 
	END) AS BestSellers,
sum(case
	when listPrice > 0  THEN (listPrice - price)
	else 0
	end) AS discount_amount,
avg(case
	when listPrice > 0  THEN ((listPrice - price)/listPrice) *100
	else 0
	end) AS discount_percentage
from amazon_products p 
inner join amazon_categories c
on p.category_id = c.id
where price>0  
group by category_name,
p.category_id
)


select 
c.category_name,
productsAvaliable,
sum(boughtInLastMonth) as totalSales,
round(sum(price),2)as totalprice,
round(discount_amount,2)as discount_amount,
round(discount_percentage,2)as discount_percentage,
BestSellers,
count(asin) as numberofproducts,
round(avg(stars),2) as averagestars,
sum(reviews) as totalreviews
from amazon_products p 
inner join amazon_categories c
on p.category_id = c.id
inner join productavilability
on ids = c.id
group by c.category_name ,productsAvaliable,BestSellers,discount_amount,discount_percentage
order by totalSales desc



