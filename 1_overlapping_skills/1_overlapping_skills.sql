/*

Q: What are the most in-demand overlapping skills from all three data-related domains?

1. Create one CTE for each one of the three data-related domains (Analytics, Science & Engineering - WHERE Clause)
    a. Each CTE includes 2 Inner Joins so that the job_postings_fact table can be linked to the skills_dim table, 
    which holds the names of the skills.
    b. Group by the skill_id
    c. SELECT skill_id, skill_name and COUNT(job_id)
    d. Order by the count DESC
2. Then inner join all three CTEs to find the most in demand overlapping skills
    a. key = skill_id
    b. Retrieve the skill name, the count of each skill at each domain and the total count.
    c. Order by the total count of each skill in descending order.

*/
-------------------------------------------------
--1. Create the CTEs

--1st CTE - Data Analytics Domain
WITH data_analytics AS (
    SELECT
        skills_analytics.skill_id,
        skills_analytics.skills AS skill_name,
        COUNT(jpf_analytics.job_id) AS analytics_skill_count
    FROM
        job_postings_fact AS jpf_analytics
    INNER JOIN skills_job_dim AS middle_analytics
        ON jpf_analytics.job_id = middle_analytics.job_id
    INNER JOIN skills_dim AS skills_analytics
        ON middle_analytics.skill_id = skills_analytics.skill_id
    WHERE
        jpf_analytics.job_title_short IN ('Business Analyst','Data Analyst','Senior Data Analyst')
    GROUP BY
        skills_analytics.skill_id,
        skills_analytics.skills
    ORDER BY
        analytics_skill_count DESC
),
--2nd CTE - Data Science Domain
--Change "_analytics" to "_science" and update the WHERE Clause

    data_science AS (
    SELECT
        skills_science.skill_id,
        skills_science.skills,
        COUNT(jpf_science.job_id) AS science_skill_count
    FROM
        job_postings_fact AS jpf_science
    INNER JOIN skills_job_dim AS middle_science
        ON jpf_science.job_id = middle_science.job_id
    INNER JOIN skills_dim AS skills_science
        ON middle_science.skill_id = skills_science.skill_id
    WHERE
        jpf_science.job_title_short IN ('Data Scientist','Senior Data Scientist')
    GROUP BY
        skills_science.skill_id,
        skills_science.skills
    ORDER BY
        science_skill_count DESC
),
--3rd CTE - Data Engineering
--Change "_analytics" to "_engineering" and update the WHERE Clause
    data_engineering AS (
    SELECT
        skills_engineering.skill_id,
        skills_engineering.skills,
        COUNT(jpf_engineering.job_id) AS engineering_skill_count
    FROM
        job_postings_fact AS jpf_engineering
    INNER JOIN skills_job_dim AS middle_engineering
        ON jpf_engineering.job_id = middle_engineering.job_id
    INNER JOIN skills_dim AS skills_engineering
        ON middle_engineering.skill_id = skills_engineering.skill_id
    WHERE
        jpf_engineering.job_title_short IN ('Data Engineer','Senior Data Engineer')
    GROUP BY
        skills_engineering.skill_id,
        skills_engineering.skills
    ORDER BY
        engineering_skill_count DESC
)
-------------------------------------------------
--2. Find the Common Elements of all CTEs
/*
Note: The order in which you perform the joins does not affect the final result, 
because INNER JOIN is both commutative (A JOIN B = B JOIN A) and associative ((A JOIN B) JOIN C = A JOIN (B JOIN C).
*/
SELECT
    analytics.skill_name,
    analytics.analytics_skill_count,
    science.science_skill_count,
    engineering.engineering_skill_count,
    (analytics.analytics_skill_count + science.science_skill_count + 
    engineering.engineering_skill_count) AS total_count
FROM
    data_analytics AS analytics
INNER JOIN data_science AS science
    ON analytics.skill_id = science.skill_id
INNER JOIN data_engineering AS engineering
    ON science.skill_id = engineering.skill_id
ORDER BY
    total_count DESC
LIMIT 7;