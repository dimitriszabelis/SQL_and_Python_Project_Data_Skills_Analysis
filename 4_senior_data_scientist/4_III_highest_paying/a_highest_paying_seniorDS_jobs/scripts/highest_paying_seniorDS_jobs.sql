/*

Q: III.a. What are the highest-paying Senior Data Scientist jobs?

Create a CTE:
i. Inner join company_dim on job_postings_fact to get the names of the companies
that offer at least one Senior Data Scientist job.
ii. Criteria: a. Senior Data Scientist role & b. salary_year_avg IS NOT NULL
iii. Order By salary_year_avg DESC

*/
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
        jpf.salary_year_avg
    FROM
        job_postings_fact AS jpf
    INNER JOIN company_dim AS cmp
        ON jpf.company_id = cmp.company_id
    WHERE
        jpf.job_title_short = 'Senior Data Scientist' AND
        jpf.salary_year_avg IS NOT NULL
    ORDER BY
       jpf.salary_year_avg DESC
)

SELECT
    job_title,
    job_location,
    job_schedule_type,
    job_work_from_home,
    company_name,
    salary_year_avg
FROM
    highest_paying_jobs

/*Calculates the total number of Senior Data Scientist job postings that mention a salary
that is above the average salary of all those postings.
Why? To determine the criterion for the HAVING clause in 4.III.b.
868 job postings remain after the application of all criteria and thus, the count of job_id for each skill 
must be at least greater than 1% or 5% of the total of 868 job postings so that the skill can be considered in-demand
(a value of 3% is chosen in 4.III.b, which equates to COUNT(hpj.job_id) > 25).
*/
/*SELECT
    COUNT(job_id)
FROM
    highest_paying_jobs
WHERE salary_year_avg >
    (SELECT AVG(salary_year_avg)
    FROM highest_paying_jobs
    )
*/

/*Calculates
i. The total number of Senior Data Scientist job postings that mention salary,
ii. The average salary,
iii. The maximum salary,
iv. The 75th percentile &
v. The 90th percentile of the salary distribution.
*/
/*SELECT
    COUNT(job_id),
    ROUND(AVG(salary_year_avg),-3) AS avg_salary,
    ROUND(MAX(salary_year_avg),-3) AS max_salary,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salary_year_avg)::NUMERIC,-3) AS median,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary_year_avg)::NUMERIC,-3) AS percentile_75th,
    ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY salary_year_avg)::NUMERIC,-3) AS percentile_90th
FROM
    highest_paying_jobs;
*/