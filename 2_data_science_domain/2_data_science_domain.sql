/*

Q: What are the most in-demand skills in the Data Science domain?

Use the CTE of the previous example for the Data Science Domain and adapt it to exclude all the skills they will have already learned.

*/
--2nd CTE - Data Science Domain

WITH data_science AS (
    SELECT
        skills_science.skills AS skill_name,
        COUNT(jpf_science.job_id) AS data_science_skill_count
    FROM
        job_postings_fact AS jpf_science
    INNER JOIN skills_job_dim AS middle_science
        ON jpf_science.job_id = middle_science.job_id
    INNER JOIN skills_dim AS skills_science
        ON middle_science.skill_id = skills_science.skill_id
    WHERE
        jpf_science.job_title_short IN ('Data Scientist','Senior Data Scientist')
    GROUP BY
        skills_science.skills
    ORDER BY
        data_science_skill_count DESC
)

SELECT *
FROM data_science
WHERE
    skill_name NOT IN ('sql','python')
LIMIT 10;