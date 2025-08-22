## **Documentation: E-commerce** **Customer Segmentation for Loyalty program**

**Tools:** SQL \+ Tableau  
**Dataset:** [E-commerce Customers Dataset](https://www.kaggle.com/datasets/carrie1/ecommerce-data)

**Project Overview**

This project analyzes customer transactions from an e-commerce retailer with the goal of enabling customer segmentation for marketing and business intelligence purposes. Using SQL, I cleaned and explored the dataset to prepare it for dashboarding and segmentation in Tableau.

### **Objectives:**

* Segment customers into champions, loyal, potential loyal, at risk and frequent buyers  
* Use RFM (Recency, Frequency, Monetary) analysis  
* Recommend tailored perks or offers per segment

**Data Source & Import**

The dataset was imported into SQL Server via the flat file method. It contains over 500,000 transaction records, including fields such as InvoiceNo, CustomerID, StockCode, Quantity, UnitPrice, Country, and InvoiceDate.  
**EDA and Cleaning (SQL)**

A report to show all the metrics about the business

- Total sales  
- Total quantity sold  
- Avg. selling price  
- Total No. Orders  
- Total No. Product  
- Total No. Of Customers

Checked for missing values in the dataset 

- Description have a 1,454 null values  
- CustomerID have 135,080 null values  
- Unit price have 2 null values

Created a new customer-focused dataset and dropped descriptive column, all the null columns in the customerID  
**Logic:** 

- StockCode is a product unique Identify for the description and if I need to do product-level analysis, I can rely on the StockCode column  
- Since I’m doing **Customer Segmentation Analysis,** I can’t group or segment anonymous users without CustomerID

Rows with NULL CustomerID could be:

* Guest checkouts  
* Data-entry issues  
* Test transactions

Checked and Removed non-numeric StockCodes such as:

- BANK CHARGES  
- C2  
- CRUK  
- D  
- DOT  
- M  
- PADS  
- POST

These **aren’t actual products** being sold — they’re *administrative* or *system-related* entries. Although the analysis focuses on customer segmentation (not product sales), these entries do not represent actual product purchases. Including them would distort key customer behavior metrics such as frequency, recency, and monetary value.

Identified 103 transactions where Quantity \> 1000\.

- These transactions were verified to be valid: they had real CustomerID, InvoiceNo, and realistic UnitPrice values (most expensive item \= $3.50).  
- Although these rows represent a small percentage of total transactions, they account for $400,062 in revenue, or about 5% of the total.

**Logic:** Kept these rows, as they appear to represent bulk buyers (e.g., resellers or corporate customers).

Found 8506 rows with Quantity \< 0, likely representing product returns.

* These rows had valid CustomerID, StockCode, and UnitPrice, so they weren’t removed.  
* Marked these as "Return" transactions to:  
- Track customer return behavior  
- Calculate net spending more accurately  
- Enable optional filtering in Tableau (e.g., exclude returns in some charts)

Added a Unique Identifier / Primary key— RowID

#### Split the Invoice Date Column into Separate Date and Time fields To improve time-based analysis by separating the InvoiceDate column into two distinct fields: one containing only the date, and the other containing only the time.

**Basic Descriptive Analysis**

1. First and Last Transaction: The dataset spans transactions from **Dec 2010 to Dec 2011**.  
2. Most Frequent Customers  
3. Order Distribution by date  
4. Hour of day analysis: Peak transaction hours occurred between **9am and 4pm**, suggesting business hours activity.  
5. Customers by country: Top customers placed up to **100+ orders**, mostly from **UK and Germany**.  
6. Cancelled Orders: 8506 transactions marked as returns.  
7. Repeat customers vs One-time Customers  
8. Top 10 highest unit prices: Most expensive product sold for **£649.5**

**Data Visualization TABLEAU**  
The key analyses include:

* RFM Segmentation (Recency, Frequency, Monetary)  
* Customer Cohort and Retention Analysis  
* Customer Distribution (by country, revenue contribution)  
* Product Affinity by Segment  
* Visualizations for executive insights

**Data Preparation**

* Invoice Date was used to derive multiple time-based fields such as Year-Month, Month Since First Purchase, and Recency.  
* Customer ID was the primary key for customer-level analysis.  
* Sales Measures such as Unit Sold, and Order Quantity were aggregated to support revenue and frequency calculations.  
* Parameters (Select Year-Month) were introduced to enable dynamic filtering and analysis over time.

**Total Sales & Total Customers**  
To provide a quick snapshot of business performance, I created two KPI indicators: Total Sales and Total Customers.

* A Year-Month parameter was built to allow filtering and trend analysis across specific periods.  
* The Total Sales KPI shows aggregated sales for the selected month, while the Total Customers KPI shows the number of unique customers in that period.

To provide more granularity, I added line charts under each KPI to display daily trends within the selected month. This highlights peaks and dips, making it easy to identify days with the highest and lowest sales and customer activity.

**RFM Segmentation**

* Recency: Number of days since the last purchase. Used to measure customer engagement and freshness.  
* Frequency: Number of purchases per customer over time. Captures loyalty and repeat behavior.  
* Monetary: Total spend per customer. Measures financial value.

**Segmentation logic:**  
Customers were bucketed into groups (1–4 scale) based on relative distribution (percentiles).

* **Recency (R):** How recently a customer purchased. Lower is better – 1 \= most recent, 4 \= least recent.  
* **Frequency (F):** How often a customer purchased. Higher is better – 1 \= most frequent, 4 \= least frequent.  
* **Monetary (M):** How much a customer spent. Higher is better – 1 \= top spenders, 4 \= lowest spenders.

Recency is reversed because fewer days since last purchase \= more valuable, while Frequency and Monetary improve with higher values.

* Each customer received an RFM Code (e.g., “111”, “244”), which was then mapped into human-readable segments:  
- Champions  
- Loyal Customers  
- Potential Loyalists  
- At Risk  
- Frequent Buyers

**Visualization: Triangular RFM Segmentation**  
A triangular scatter plot was built to visualize customers across the three RFM dimensions (Recency, Frequency, and Monetary) at the same time.

1. Normalization

Each RFM metric (Recency, Frequency, Monetary) is rescaled between 0 and 1 so they are comparable, even if they have different ranges.

2. Triangle Conversion

The three metrics are then converted into X and Y coordinates so they can be plotted inside a triangle.

- **Top corner \= Frequency** (customers who purchase most often)  
- **Right corner \= Monetary** (customers who spend the most)  
- **Left corner \= Recency** (customers who purchased most recently)  
3. Scatter Plot

Each customer is placed as a point inside the triangle based on their RFM balance.

- Customers near the top are very frequent buyers.  
- Customers near the right side are high spenders.  
- Customers near the left side are recent buyers.  
- Customers in the middle are balanced across all three.

In plain English: this chart gives a visual map of customer behavior. Instead of just labeling them as “1-4 buckets,” you can see whether someone is more of a frequent buyer, a big spender, or simply very recent.

**Customer Distribution Analysis**  
This analysis explores how customers are distributed across geography and revenue contribution. It helps identify where customers are located and which ones drive the majority of sales.  
**By Country** (Geographic Distribution)

* Created a map chart showing:  
- Customer counts (distinct Customer ID).  
- Total revenue per country (sum of sales).  
* Purpose: to visualize customer spread and market importance geographically.  
* **Sales % Contribution** per country was normalized against total global sales to calculate percentage contribution  
- This allowed comparison of regional performance relative to all markets..

**By Revenue Contribution:** (Pareto chart) 

* Ranked customers by their total revenue contribution.  
* Calculated each customer’s **% of total revenue** and cumulative share.  
* Built a **Pareto chart** showing the 80/20 rule.

**Cohort / Retention Analysis**  
To analyze customer retention over time, I created a cohort framework based on the customer’s first purchase month. This allows grouping customers by when they first started buying and then tracking their activity in subsequent months.  
**First Purchase Month (Cohort Assignment)**

- For each customer, I identified the month of their very first purchase.  
- This value stays constant for that customer and serves as their cohort group.

**Month Since First Purchase**

- For each transaction, I calculated the number of months between the transaction date and the customer’s first purchase month.  
- This creates an index (0, 1, 2, …) showing how long the customer has been active since joining their cohort.

**Customer Retention Matrix**

- I combined Cohort (First Purchase Month) on rows and Month Since First Purchase on columns.  
- For each cell, I counted the number of active customers (those who made a purchase in that period).

**Retention Rate (%)**

- To standardize across cohorts, I calculated the proportion of retained customers relative to the cohort size (number of customers in their first month).  
- This makes the analysis comparable between small and large cohorts.

**Visualization:**

- **Heatmap:** Each cell shows retention percentage, with darker shades for higher retention.

**Product Affinity (By Segment)**

* Segmented customers were analyzed to identify their top purchased products.  
* Horizontal bar charts were designed to show the top 10 products by revenue per segment.

**Tooltips & Interpretation Layer**

* Tooltips were enhanced to explain metrics (e.g., Recency \= Days since last purchase).  
* For retention analysis, tooltips included non-technical explanations for business users.  
* Example: Instead of just numbers, tooltips explained that “Customers in this cohort are still active after X months, showing Y% retention”.