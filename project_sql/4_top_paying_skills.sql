/*
Question: What are the top paying skills for data analysts?
*/


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
LIMIT 25


/*
-Big-data pipelines and enterprise platforms lead the pack.
-Core analytics languages and libraries remain highly prized.
-Cloud/DevOps and specialized BI tools pay strong mid-range six figures.

*/