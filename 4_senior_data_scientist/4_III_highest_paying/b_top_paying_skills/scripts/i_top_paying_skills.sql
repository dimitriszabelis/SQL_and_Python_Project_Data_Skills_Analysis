/*

Q: III.b. What are the top-paying skills required for these top-paying jobs?

A. CTE:
1. Use the CTE of the previous example, but 
i. Add a window function to calculate the AVG(salary_year_avg). This function will be used on the WHERE clause of 
the main query to filter out the rows that have a salary that is lower than the average salary of the salary_year_avg column.
ii. Remove the maximum of the dataset (largest outlier = $890,000) so that it won't affect the AVG(jpf.salary_year_avg).
B. Main Query:
2. Write 2 Inner Joins so that the highest_paying_jobs (!) table can be linked to the skills_dim table, 
which holds the names of the skills.
3. WHERE clause: 
i. Include only job postings that mention a salary that is higher than the average salary.
ii. Exclude the skills the person has already covered (and skills similar to those already covered).
4. Group by skill name.
5. Having count(job_id) > 25 (Include only skills that are in-demand)
6. Order by avg_salary_per_skill DESC;
7. Retrieve the skill name, the count of each skill, and the average salary associated with each skill.

Notes:
1. AVG(jpf.salary_year_avg) OVER () AS overall_avg_salary -- Average of the salary_year_avg column (column that holds the annual salaries for the offered jobs)
2. ROUND(AVG(salary_year_avg),-3) AS avg_salary_per_skill --Average salary associated with each top-paying skill (AVG(hpj.salary_year_avg) with Group By)
3. The analysis of the salary distribution of 4_III.a. showed that the mean is almost equal to the median (salary_year_avg: mean = 153653.4, median = 155000.0), thus
    using either average type is possible here. In this script, the mean of the distribution is used to extract only the job postings that are associated
    with the highest salaries.

*/
--------------------------------------------------------------------------------------------------------------------
WITH highest_paying_jobs AS (
    SELECT
        jpf.job_id,
        jpf.job_title,
        jpf.job_title_short,
        jpf.job_location,
        jpf.job_schedule_type,
        jpf.job_work_from_home, 
        jpf.job_no_degree_mention,
        cmp.name AS company_name,
        jpf.salary_year_avg,
/* This calculates the average salary over all rows in highest_paying_jobs without grouping.
Each row in highest_paying_jobs will have a new column, overall_avg_salary, containing the same average value.*/
        AVG(jpf.salary_year_avg) OVER () AS overall_avg_salary
    FROM
        job_postings_fact AS jpf
    INNER JOIN company_dim AS cmp
        ON jpf.company_id = cmp.company_id
    WHERE
        jpf.job_title_short = 'Senior Data Scientist' AND
        jpf.salary_year_avg IS NOT NULL AND
        jpf.job_id <> 1008448 --Remove the outlier to get the correct AVG(jpf.salary_year_avg)
    ORDER BY
       jpf.salary_year_avg DESC
)
--------------------------------------------------------------------------------------------------------------------
SELECT
    skills.skills AS skill_name,
    COUNT(hpj.job_id) AS demand_count,--To not include skills that are not in-demand (having a low count)
    ROUND(AVG(salary_year_avg),-3) AS avg_salary_per_skill --Average salary associated with each skill
--Extract only the job ids of the CTE (highest_paying_jobs), that is, the job ids of 
--all Senior Data Scientist jobs that mention salary (in descending order of salary_year_avg), excluding the outlier.
FROM
    highest_paying_jobs AS hpj
INNER JOIN skills_job_dim AS middle
    ON hpj.job_id = middle.job_id
INNER JOIN skills_dim AS skills
    ON middle.skill_id = skills.skill_id
WHERE
--Retrieve only the postings that mention a salary that is higher than 
--the average salary of the highest_paying_jobs.salary_year_avg column (hpj.overall_avg_salary).
    hpj.salary_year_avg > hpj.overall_avg_salary AND
--Exclude the skills that the person has already learned
    skills.skills NOT IN ('sql','python',
    'r', 'tableau', 'aws', 'spark', 'azure', 'tensorflow','pytorch',
    'scala','databricks','airflow','nosql','mongodb','cassandra', 'gcp','redshift',
    'hadoop','java','sas',
--Exclude skills that are similar to skills the person has already learned or
--skills that the person learned while learning other skills e.g. NumPy by learning Python.
    'matplotlib','numpy','pandas','jupyter',
    'excel','bigquery','scikit-learn','looker','snowflake','power bi','pyspark','git')
GROUP BY
    skills.skills
HAVING
    COUNT(hpj.job_id) > 25 --exclude skills that appear in less than 25 job postings
ORDER BY
    avg_salary_per_skill DESC;