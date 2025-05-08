/*

Q: What are the most in-demand skills in the Data Engineering domain?

Use the CTE of the previous example for the Data Engineering Domain and adapt it to exclude all the skills they will have already learned.

*/
--3rd CTE - Data Engineering
WITH data_engineering AS (
    SELECT
        skills_engineering.skills AS skill_name,
        COUNT(jpf_engineering.job_id) AS data_engineering_skill_count
    FROM
        job_postings_fact AS jpf_engineering
    INNER JOIN skills_job_dim AS middle_engineering
        ON jpf_engineering.job_id = middle_engineering.job_id
    INNER JOIN skills_dim AS skills_engineering
        ON middle_engineering.skill_id = skills_engineering.skill_id
    WHERE
        jpf_engineering.job_title_short IN ('Data Engineer','Senior Data Engineer')
    GROUP BY
        skills_engineering.skills
    ORDER BY
        data_engineering_skill_count DESC
)

SELECT *
FROM data_engineering
WHERE
    skill_name NOT IN ('sql','python','r', 'tableau', 'aws', 'spark', 'azure', 'tensorflow','pytorch')
LIMIT 10;