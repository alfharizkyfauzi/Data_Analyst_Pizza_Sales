-- Menampilkan semua isi pada Pizza DB di table pizza_sales
SELECT * FROM pizza_sales;

-- Menghitung jumlah data pada field/coloumn total_price
SELECT SUM(total_price) AS Total_Revenue from pizza_sales;

-- Menghitung rata-rata order value
SELECT SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value FROM pizza_sales;

-- Menghitung Total Pizzas Sold
SELECT SUM(quantity) AS Total_Pizza_Sold FROM pizza_sales;

-- Menghitung Jumlah Total Order (jika terdapat nilai sama pada kolom order_id maka hanya dihitung 1x)
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales;

-- Menghitung Rata-rata pizza per order (rata-rata pizza yang dipesan dalam 1x order)
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2)) Avg_Pizzas_Per_Order FROM pizza_sales;

-- Menampilkan Jumlah Order berdasarkan order_date (dengan menampilkan nama hari dan jam pada order_date)

-- Daily Trend
SELECT DATENAME(DW, order_date) AS Order_Day, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales 
GROUP BY DATENAME(DW, order_date);

-- Hourly Trend
SELECT DATEPART(HOUR, order_time) AS Order_hours, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time);

-- Menampilkan Persentase Sales (Penjualan) Pizza

-- Per Category (kategori)
SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Sales, CAST(SUM(total_price) * 100 /
(SELECT SUM(total_price) AS DECIMAL(10,2)) FROM pizza_sales WHERE MONTH(order_date) = 1)
AS Percentage_Of_Total FROM pizza_sales
WHERE MONTH(order_date) = 1
GROUP BY pizza_category;

-- Per Size (Ukuran)
SELECT pizza_size, CAST(SUM(total_price)AS DECIMAL(10,2)) AS Total_Sales, CAST(SUM(total_price) * 100 /
(SELECT SUM(total_price) FROM pizza_sales WHERE DATEPART(QUARTER, order_date) = 1) AS DECIMAL(10,2))
AS Percentage_Of_Total FROM pizza_sales
WHERE DATEPART(QUARTER, order_date) = 1
GROUP BY pizza_size
ORDER BY Percentage_Of_Total DESC;

-- Menghitung Total Sales Pizza berdasarkan Category
SELECT pizza_category, SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC

-- Menampilkan 5 Top Best Seller
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY SUM(quantity) DESC;

-- Menampilkan 5 Bottom Worst 
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Pizzas_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY SUM(quantity) ASC;