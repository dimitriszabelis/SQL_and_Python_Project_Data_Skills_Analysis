/*

Q: I. What are the most in-demand skills for the Senior Data Scientist role?

Modify the CTE of the Data Science domain so that includes only the Senior Data Scientist Role.

*/
SELECT
    skills.skills AS skill_name,
    COUNT(jpf.job_id) AS senior_DS_skill_count
FROM
    job_postings_fact AS jpf
INNER JOIN skills_job_dim AS middle
    ON jpf.job_id = middle.job_id
INNER JOIN skills_dim AS skills
    ON middle.skill_id = skills.skill_id
WHERE
    jpf.job_title_short = 'Senior Data Scientist' AND
    skills.skills NOT IN ('sql','python',
    'r', 'tableau', 'aws', 'spark', 'azure', 'tensorflow','pytorch',
    'scala','databricks','airflow','nosql','mongodb','cassandra', 'gcp','redshift')
GROUP BY
    skills.skills
ORDER BY
    senior_DS_skill_count DESC
LIMIT 10;