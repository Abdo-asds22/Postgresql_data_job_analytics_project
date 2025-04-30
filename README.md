 # Introduction
 Dive into the data job market! Focusing on data analyst roles,
 looking for the top-paying jobs, in-demand skills and where
 high demand meets high salary in data analytis.
 
 Check out the SQL queries here : [project_sql_folder](/project_sql/)

 # Background
### The questions I wanted to answer through my SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?
 # Tools used
 For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.
- **Git & GitHub**: Essential for version control and sharing my SQL scripts and analysis, ensuring collaboration and project tracking.
 
 # The Analysis
 Here is how I approached each question:
 ### 1. What are the  Top-paying Data Analyst Jobs ?
 ```
 SELECT 
    job_id,
    job_title,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM 
    job_postings_fact
LEFT JOIN 
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE job_title_short = 'Data Analyst'
    AND job_location = 'Anywhere'
    AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```
 Here is the breakdown of the top data analysts job in 2023:

 -**Wide Salary Range:** Salaries for “Data Analyst” roles in this sample range from $184 000 to $650 000, showing a huge pay spread. Indicating salary potential in the field.

 -**Higher experience means higher pay:** Half of the top‐paid postings are senior‐level titles (Director, Principal), all earning above $189 000.
 Leadership and senior experience command a significant salary premium.
 -**Diverse Employers:** Companies like SmartAsset, Meta and AT&T are among those offering high salaries, showing different domains of data roles.

 ![Top-paying roles](1_top_paying_analysts_roles.png)
 *This is a ChatGPT generated bar graph for the top 10 data analyst roles*

 ### 2. What are the skills for top-paying jobs?
 Here is the sql query:
 ```sql
 WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        job_title_short,
        salary_year_avg,
        name AS company_name
    FROM 
        job_postings_fact
    LEFT JOIN 
        company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE job_title_short = 'Data Analyst'
        AND job_location = 'Anywhere'
        AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills.skills
FROM 
    top_paying_jobs 
JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
JOIN skills_dim AS skills ON skills_job_dim.skill_id = skills.skill_id
ORDER BY salary_year_avg DESC;
```
 Here is the breakdown:
 - **SQL** appeared in 8 roles.
 - **Python** appeared in 7 roles.
 - **Tableau** appeared in 6 roles, **R** in 4 roles, then **Excel**, **Snowflake** and **Pandas** in three roles. 

 ![skill count for top paying roles](2_top_paying_roles_skills.png)
 *ChatGPT generated Bar Graph for the count of skills for top 10  salaries of data analyst roles.*

 ### 3. What are the most in-demand skills for Data Analysts?
 Here is the SQL query:
 ```sql
 SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact 
JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim AS skills ON skills_job_dim.skill_id = skills.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
 ```
Here is the breakdown:
- **SQL** and **Excel** remain fundamental, emphasizing the the need for strong foundation.

- Programming languages like **Python** and visualization tools like **Tableau** and **Power BI** are also high in-demand.
  
 | Skill   | Demand Count |
|---------|--------------|
| sql     | 7,291        |
| excel   | 4,611        |
| python  | 4,330        |
| tableau | 3,745        |
| power bi| 2,609        |

*Table of skills for top 5 data analyst job postings*

### 4. What are the top-paying skills?
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT 
    skills,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact 
JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim AS skills ON skills_job_dim.skill_id = skills.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = True AND
    job_postings_fact.salary_year_avg IS NOT NULL

GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
Here's a breakdown of the results for top paying skills for Data Analysts:

- **High Demand for Big Data & ML Skills:** Top salaries are commanded by analysts skilled in big data technologies (PySpark, Couchbase), machine learning tools (DataRobot, Jupyter), and Python libraries (Pandas, NumPy), reflecting the industry's high valuation of data processing and predictive modeling capabilities.
- **Software Development & Deployment Proficiency:** Knowledge in development and deployment tools (GitLab, Kubernetes, Airflow) indicates a lucrative crossover between data analysis and engineering, with a premium on skills that facilitate automation and efficient data pipeline management.
- **Cloud Computing Expertise:** Familiarity with cloud and data engineering tools (Elasticsearch, Databricks, GCP) underscores the growing importance of cloud-based analytics environments, suggesting that cloud proficiency significantly boosts earning potential in data analytics.

| Skill       | Average Salary $ |
|-------------|------------------|
| pyspark     | 208,172         |
| bitbucket   | 189,155         |
| couchbase   | 160,515         |
| watson      | 160,515         |
| datarobot   | 155,486         |
| gitlab      | 154,500         |
| swift       | 153,750         |
| jupyter     | 152,777         |
| pandas      | 151,821         |
| elasticsearch | 145,000       |

 *Table of top 10 highest paying skills for data analysts*

### 5.What are the most optimal skills to learn?
This query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.
```sql
SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM  
    job_postings_fact
JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
JOIN skills_dim  ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_work_from_home = True AND
    job_postings_fact.salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
| Skill       | Demand Count | Avg Salary $ |
|-------------|--------------|--------------|
| go          | 27           | 115,320      |
| confluence  | 11           | 114,210      |
| hadoop      | 22           | 113,193      |
| snowflake   | 37           | 112,948      |
| azure       | 34           | 111,225      |
| bigquery    | 13           | 109,654      |
| aws         | 32           | 108,317      |
| java        | 17           | 106,906      |
| ssis        | 12           | 106,683      |
| jira        | 20           | 104,918      |
| oracle      | 37           | 104,534      |
| looker      | 49           | 103,795      |
| nosql       | 13           | 101,414      |
| python      | 236          | 101,397      |
| r           | 148          | 100,499      |

*Table of the most optimal skills to learn sorted by salary*
Here's a breakdown of the most optimal skills for Data Analysts in 2023:

- **High-Demand Programming Languages:** Python and R stand out for their high demand, with demand counts of 236 and 148 respectively. Despite their high demand, their average salaries are around $101,397 for Python and $100,499 for R, indicating that proficiency in these languages is highly valued but also widely available.
- **Cloud Tools and Technologies:** Skills in specialized technologies such as Snowflake, Azure, AWS, and BigQuery show significant demand with relatively high average salaries, pointing towards the growing importance of cloud platforms and big data technologies in data analysis.
- **Business Intelligence and Visualization Tools:** Tableau and Looker, with demand counts of 230 and 49 respectively, and average salaries around $99,288 and $103,795, highlight the critical role of data visualization and business intelligence in deriving actionable insights from data.
Database Technologies: The demand for skills in traditional and NoSQL databases (Oracle, SQL Server, NoSQL) with average salaries ranging from $97,786 to $104,534, reflects the enduring need for data storage, retrieval, and management expertise.
 
 # Conclusion
 From the analysis, several general insights emerged:

1. **Top-Paying Data Analyst Jobs:** The highest-paying jobs for data analysts that allow remote work offer a wide range of salaries, the highest at $650,000!
2. **Skills for Top-Paying Jobs:** High-paying data analyst jobs require advanced proficiency in SQL, suggesting it’s a critical skill for earning a top salary.
3. **Most In-Demand Skills:** SQL is also the most demanded skill in the data analyst job market, thus making it essential for job seekers.
4. **Skills with Higher Salaries:** Specialized skills, such as SVN and Solidity, are associated with the highest average salaries, indicating a premium on niche expertise.
5. **Optimal Skills for Job Market Value:** SQL leads in demand and offers for a high average salary, positioning it as one of the most optimal skills for data analysts to learn to maximize their market value.
 
