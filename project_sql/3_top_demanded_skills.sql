/*
Question: What are the most in demand skills for data analysts?
*/


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
LIMIT 5

/*
-Here's the breakdown of the most demanded skills for data analysts in 2023,
SQL and Excel remain fundamental, emphasizing the the need for strong foundation.
Programming languages like Python and visualization tools like Tableau and Power BI are also important.

[
  {
    "skills": "sql",
    "demand_count": "7291"
  },
  {
    "skills": "excel",
    "demand_count": "4611"
  },
  {
    "skills": "python",
    "demand_count": "4330"
  },
  {
    "skills": "tableau",
    "demand_count": "3745"
  },
  {
    "skills": "power bi",
    "demand_count": "2609"
  }
]

*/