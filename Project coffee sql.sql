CREATE database coffee_shop_sales_database;
USE coffee_shop_sales_database;
show tables;
DESC coffee_shop_sales;
select * FROM coffee_shop_sales;

update coffee_shop_sales 
set transaction_date= str_to_date(transaction_date,'%d-%m-%Y');
