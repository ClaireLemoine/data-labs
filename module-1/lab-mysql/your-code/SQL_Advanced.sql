use publications;
select st.stor_name as store,count(distinct s.ord_num) as orders, count(s.title_id) as item,
        sum(s.qty)
from sales s
inner join stores st on s.stor_id=st.stor_id
group by store;
select store, item/orders as avgtitle, qty/item as avgamountofitems
from(
select st.stor_name as store,count(distinct s.ord_num) as orders, count(s.title_id) as item,
        sum(s.qty) as qty
from sales s
inner join stores st on s.stor_id=st.stor_id
group by store) nonavg;
select store, ord_num, ord_date, title, sales.qty, price, type
from (
select st.stor_id as storeid, st.stor_name as store, count(distinct ord_num) as orders, 
count(title_id) as items, sum(qty) as qty
from sales s
inner join stores st on s.stor_id=st.stor_id
group by store) summary
inner join sales on summary.storeid=sales.stor_id
inner join titles t on sales.title_id = t.title_id
where items/orders>1;
create temporary table store_sales_summary
select st.stor_id as storeid, st.stor_name as store, count(distinct ord_num) as orders, 
count(title_id) as items, sum(qty) as qty
from sales s
inner join stores st on s.stor_id=st.stor_id
group by store;
select *
from store_sales_summary;
select store, ord_num, ord_date, title, sales.qty, price, type
from store_sales_summary
inner join sales on store_sales_summary.storeid=sales.stor_id
inner join titles t on sales.title_id = t.title_id
where items/orders>1;