SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date :: DATE AS date
FROM job_postings_fact

