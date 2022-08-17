show databases;

use orders;

select * from address;

-----07

select carton_id, (c.len*c.width*c.height) as cartoon_vol from carton c 
where (c.len*c.width*c.height)>=(select sum(p.len*p.width*p.height*product_quantity) as req_vol 
from order_header oh inner join order_items oi on oh.order_id=oi.order_id
inner join product p on oi.product_id=p.product_id where oh.order_id=10006)
order by (c.len*c.width*c.height) asc limit 1;

------08

select oc.customer_id, concat(oc.customer_fname," ",oc.customer_lname) as customer_fullname, oi.order_id, sum(oi.product_quantity) as total_order 
from online_customer oc inner join order_header oh on oc.customer_id=oh.customer_id inner join order_items oi on oh.order_id=oi.order_id
where oh.payment_mode='credit card' or 'net banking'
group by oi.order_id
having total_order>10
order by customer_id;

-------09

select oc.customer_id, concat(oc.customer_fname," ",oc.customer_lname) as customer_fullname, oh.order_id, 
sum(oi.product_quantity) as total_quantity 
from online_customer oc inner join order_header oh on oc.customer_id=oh.customer_id inner join order_items oi on oh.order_id=oi.order_id
where oh.order_status='shipped' and oh.order_id>10030
group by oh.order_id
having customer_fullname like 'a%'
order by customer_id;

------10

select pc.product_class_desc, 
sum(oi.product_quantity) as total_quantity,
(oi.product_quantity*p.product_price) as total_value
from order_items oi inner join order_header oh on oi.order_id=oh.order_id
inner join online_customer oc on oh.customer_id=oc.customer_id
inner join address a on oc.address_id=a.address_id
inner join product p on oi.product_id=p.product_id
inner join product_class pc on p.product_class_code=pc.product_class_code
where oh.order_status='shipped' and a.country not in ('India','USA')
group by pc.product_class_code, pc.product_class_desc
order by total_quantity limit 1;