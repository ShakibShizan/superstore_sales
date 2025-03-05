# 📊 Superstore Sales

## 📌 Overview
This project involves analyzing the **Superstore Sales Data** to segment customers based on **Recency, Frequency, and Monetary (RFM)** metrics. The analysis aims to understand customer behaviour and categorize them accordingly.

## 📂 Files
| File Name                     | Description                                              |
|-------------------------------|----------------------------------------------------------|
| **Final Superstore Sales.sql** | The main SQL script for creating and populating the dataset. |
| **Superstore Sales Data.csv**  | The raw sales data file.                                |
| **Create Database.sql**        | This SQL script will create the database and tables.    |
| **Data Cleaning & EDA.sql**    | Data checks, cleaning, and exploratory data analysis.   |
| **Rfm Segmentation.sql**       | The script for implementing RFM segmentation.          |

**Note:** The database management system used is **MySQL**. Data was imported using the **Data Import Wizard Tool**.

## 🛠 Methodology
### ✅ Data Verification
- Ensured completeness and accuracy of the imported data.

### 🧹 Data Cleaning
- Removed duplicates, handled missing values, and corrected inconsistencies.

### 📊 Exploratory Data Analysis (EDA)
- Analyzed product count, sales distribution, and customer demographics.

### 🎯 Findings/Results
#### 📌 Customer Segmentation
| Segment                          | Customers | Total Transactions |
|----------------------------------|------------|------------------|
| **Loyal Customers**              | 424        | 8,430            |
| **Slipping Away, Cannot Lose**   | 336        | 7,000            |
| **Churned Customers**            | 611        | 497              |
| **Potential Churners**           | 326        | 1,013            |
| **Active Customers**             | 383        | 944              |
| **New Customers**                | 20         | 180              |
| **Other**                        | 568        | 3,122            |

🛠 **Key Insight:** A significant number of customers are **slipping away (7,000 transactions)** or **potentially churning (1,013 transactions)**, indicating a need for **retention strategies**.

#### 📌 Product Performance
| Category         | Total Sales ($) | Total Profit ($) | Profit Margin (%) |
|-----------------|---------------|----------------|----------------|
| **Office Supplies** | 2,193,404.65  | 932,905.26    | **42.53%**  |
| **Furniture**       | 2,997,633.10  | 202,448.16    | **6.75%**   |
| **Technology**      | 3,507,134.42  | 810,893.66    | **23.12%**  |

🛠 **Key Insight:** Furniture has the lowest profit margin, indicating a need for pricing or sourcing adjustments. Technology dominates in sales revenue.

#### 📌 Geographic Insights
| Region  | Total Sales ($) | Total Profit ($) | Profit Margin (%) |
|---------|---------------|----------------|----------------|
| **East**     | 2,342,683.39  | 361,822.32  | **15.44%** |
| **Central**  | 2,462,501.96  | 502,786.77  | **20.42%** |
| **West**     | 2,344,459.07  | 297,240.32  | **12.68%** |
| **South**    | 1,548,331.75  | 88,346.67   | **5.71%** |

📌 **Key Insight:** The **Central** region has the highest profit margin (**20.42%**), while the **South** region performs the weakest (**5.71%**), indicating a need for **improved sales strategies in the South**.

#### 📌 Marketing Recommendations
📢 **Personalized Strategies:**  
✔️ **Targeted promotions** for frequent buyers.  
✔️ **Discounts & retention programs** for at-risk customers.  
✔️ **Upselling strategies** for high-value customers.  

## 📸 Insights Visualization
![Superstore Sales Insights](picture/insights.png)

## 🔗 Connect With Me
If you have any questions or suggestions, feel free to reach out! 🚀  
📧 **Email:** gotoshizan@gmail.com  
🔗 **LinkedIn:** [MD NAZMUS SHAKIB SHIZAN](https://www.linkedin.com/in/yourprofile/)  

---
_If you find this project helpful, don't forget to 🌟 star the repository!_ ⭐
