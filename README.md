# 📱 Mobile Manufacturer Data Analysis

## 🎯 Objective
* To evaluate cellphone sales performance across different regions and locations.
* To determine the leading manufacturers and cellphone models based on sales volume.
* To examine customer purchasing and spending patterns across different years.
* To assess changes in manufacturer and model performance over time.
* To identify customer spending trends from transaction data.
* To apply SQL techniques to analyze the database and generate meaningful business insights.

## 🛠️ Tools Used
* **Database Management:** MySQL
* **Data Visualization:** Power BI

## 📊 Entity Relationship Diagram (ERD)
<img width="830" height="606" alt="image" src="https://github.com/user-attachments/assets/041afc8f-53d3-4a60-bc65-d84999617cc3" />


## ⚡ SQL Techniques Applied
* **Joins:** To combine data from multiple tables.
* **Filtering:** Using `WHERE` and `HAVING` conditions to analyse specific years, states, manufacturers, and customers.
* **Aggregation:** Using `SUM()`, `COUNT()`, and `AVG()` to calculate sales and customer metrics.
* **Grouping & Sorting:** Using `GROUP BY` and `ORDER BY` to segment data by manufacturer, model, state, ZIP code, and year.
* **Subqueries:** To perform calculations and comparisons using intermediate results.
* **Window Functions:** `LAG()` used to calculate previous year spend.
* **Set Operations:** `INTERSECT` and `EXCEPT` to compare manufacturer and model performance across different years.

## 📈 POWER BI DASHBOARD
An interactive dashboard was built to visualize key insights, trends, and operational metrics.
<img width="853" height="598" alt="image" src="https://github.com/user-attachments/assets/1111973c-77f2-402f-8fef-ac851367023f" />


## 🔍 Key Analysis
The cellphone transaction data was analyzed by joining information across the customer, location, model, manufacturer, date, and `fact_transactions` tables.

Key analytical steps included:
1. Filtering transaction data based on specific years, states, and manufacturers.
2. Using joins to combine related information from different tables.
3. Applying count, sum, and avg to measure transactions, sales, quantities, and customer spending.
4. Grouping data by state, zip code, model, manufacturer, customer, and year.
5. Using subqueries and ranking techniques to identify top manufacturers, models, and customers.
6. Comparing sales performance across 2008, 2009, and 2010.
7. Using lag() to calculate changes in customer spending between years.
8. Using except and intersect to compare manufacturer and model performance across different years.
