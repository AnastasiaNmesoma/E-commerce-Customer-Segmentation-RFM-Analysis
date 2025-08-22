# E-commerce-Customer-Segmentation-RFM-Analysis

![Tableau](https://img.shields.io/badge/Tool-Tableau-blue?logo=tableau)
![SQL Server](https://img.shields.io/badge/Database-SQL%20Server-red?logo=microsoftsqlserver)
[![Dataset](https://img.shields.io/badge/Dataset-Kaggle-blue)]((https://www.kaggle.com/datasets/carrie1/ecommerce-data))
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![GitHub repo size](https://img.shields.io/github/repo-size/AnastasiaNmesoma/E-commerce-Customer-Segmentation-RFM-Analysis)
![Last Commit](https://img.shields.io/github/last-commit/AnastasiaNmesoma/E-commerce-Customer-Segmentation-RFM-Analysis)

### Overview
This project analyzes **500K+ e-commerce transactions** to uncover customer behavior patterns and enable segmentation for a loyalty program. Using **SQL** for data preparation and **Tableau** for visualization, I developed dashboards that highlight customer value distribution, retention trends, and geographic revenue concentration.

## Tools & Dataset
- Dataset – [E-commerce transactions](https://www.kaggle.com/datasets/carrie1/ecommerce-data)
- SQL Server – Data cleaning & preparation
- Tableau – Dashboarding & segmentation analysis

## Important Note:
For full context, including project objectives, data preparation steps, and logic behind the analysis please refer to the [Project documentation](Documentation:%20Customer%20Segmentation%20for%20Loyalty%20program.md)

## Business Understanding & Goal
The primary goal of this analysis is to help the business understand its customer base in depth. who the most valuable customers are, how frequently they return, and which regions contribute most to overall revenue. 

With a single year of transactional data, the project aims to segment customers into **Champions**, **Loyal**, **At-Risk**, **Potential Loyalists**, and **Frequent Buyers** using RFM analysis to derive insights for customer retention strategies, identify at-risk segments, and guide revenue diversification efforts.

Ultimately, the business wants to reduce churn, improve loyalty, and grow revenue without over-relying on a few key markets or customers.

## Data Preparation (SQL)
#### 1. Cleaning & Null Handling
- Dropped 135k rows with missing CustomerID (guest checkouts / test data).
- Marked 8.5k negative quantities as Returns (not deleted).
- Removed non-product codes (e.g., “BANK CHARGES”, “POST”).

#### 2. Transformations
- Split InvoiceDate → Date + Time.
- Created RowID as primary key.
- Derived Year-Month, Months Since First Purchase, Recency.

#### 3. Descriptive Analysis
- Date range: Dec 2010 – Dec 2011.
- Peak hours: 9am–4pm (business hours).
- Top markets: UK & Germany.
- Identified bulk buyers (Quantity > 1000).

## Tableau Visualizations
### Feature Engineering
- Created **Unique RowID** as primary key
- Derived **Sales = Quantity * UnitPrice**
- Built time-based fields: Year-Month, Recency (days since last purchase)
- Aggregated at customer-level for RFM analysis

#### 1. Total Sales & Customers
- Sales = Quantity × UnitPrice (calculated field).
- Parameter for Year-Month to dynamically filter views.
- Line chart of daily sales trends within selected month.
- Line chart of daily active customers, showing customer volume per day.
- Highlighted highest and lowest sales/customers within each period.

#### 2. RFM Segmentation
- **Recency:** Days since last purchase (lower = more recent).
- **Frequency:** Total purchases (higher = more loyal).
- **Monetary:** Total spend (higher = more valuable).
- Assigned scores (1–4 scale) → Combined into RFM Code → Mapped to segments
- Customers mapped into Champions, Loyal, Potential Loyal, At Risk, Frequent Buyers.
- Triangular scatter plot → positions each customer within Recency, Frequency, and Monetary space.

#### 3. Cohort Retention Analysis
- Customers grouped by first purchase month.
- Retention tracked monthly → heatmap with retention % per cohort.
- Shows customer “stickiness” over time and month-to-month churn.

#### 4. Customer Distribution
- Map: Customer count and revenue contribution by country.
- Pareto Chart: Verified 80/20 rule → 16% of customers generate 80% of revenue.
- Revenue Concentration Risk: UK dominates total sales.

#### 5. Product Affinity by Segment
- Top 10 products purchased per customer segment.
- Enables personalized offer design by segment type.

## Insights
#### 1. Revenue Concentration
- UK market dominates → business is highly dependent on a single region.
- Other countries: many customers but <1% revenue individually.

#### 2. Customer Concentration
- Only 16% of customers drive 80% of revenue.
- Heavy reliance on a small elite group (Frequent Buyers & Champions).

#### 3. Retention
- Sharp drop-off after Month 2 → early churn risk.
- Some cohorts stabilize with consistent repeat buyers.

#### 4. Segmentation
- “Frequent Buyers” are strong contributors but under-recognized; could be upgraded into Champions via targeted strategies.
- “At Risk” group shows long inactivity despite good past spending.

## Business Recommendations
| Finding                              | Strategic Recommendation                                         |
| ------------------------------------ | ---------------------------------------------------------------- |
| UK dependency                        | Diversify revenue streams by activating non-UK regions.          |
| 16% customers = 80% revenue          | Provide **VIP programs** for high-value customers.               |
| Early churn (drop-off after month 2) | Strengthen **onboarding & engagement** in first 60 days.         |
| Frequent Buyers with high spend      | Convert into **Champions** via loyalty perks & recognition.      |
| At Risk customers                    | Deploy **win-back campaigns** (discounts, re-engagement offers). |

For full Executive stakeholder report refer to the [Executive report](Executive%20Report:%20Customer%20Distribution%20&%20Revenue%20Concentration.md)

## Conclusion
This Tableau dashboard provides a 360° view of customer behavior—from purchase recency and loyalty to geographic spread and retention trends. The analysis confirms that growth opportunities lie in market diversification, nurturing mid-tier customers, and protecting top contributors.

### Dashboard Preview
> [Veiw live dashboad](https://public.tableau.com/app/profile/chukwujieze.anastasia/viz/CustomerSegmentationAnalysis_17558007082470/Dashboard1)
<img width="960" height="518" alt="Screenshot 2025-08-22 153439" src="https://github.com/user-attachments/assets/8848cbb4-55a1-422b-88fe-0205aabc73b8" />

## Let’s Connect

- [Read My Blog on Substack](https://substack.com/@theanalysisangle)
- [Twitter](https://x.com/Anastasia_Nmeso)  
- [FaceBook](https://www.facebook.com/share/16JoCo9x4F/)  
- [LinkedIn](www.linkedin.com/in/anastasia-nmesoma-947b20317)
