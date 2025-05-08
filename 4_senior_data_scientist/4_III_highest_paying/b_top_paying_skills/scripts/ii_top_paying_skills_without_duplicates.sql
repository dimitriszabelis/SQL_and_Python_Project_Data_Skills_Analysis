/*

Q: III.b. What are the top-paying skills required for these top-paying jobs?
* Remove the small number of duplicates that exist in the dataset to determine if the error they cause is significant.

1. Use the CTE of the previous example, but 
i. Add a window function to calculate the AVG(salary_year_avg).This function will be used on the WHERE clause of
the main query to filter out the rows that have a salary that is lower than the average salary of the salary_year_avg column.
ii. Remove the maximum of the dataset (largest outlier = $890,000) so that it won't affect the AVG(jpf.salary_year_avg).

2. Create two more CTEs to remove the duplicate rows that exist in the result set of the first CTE (based on the analysis of the previous step, 4_III.a)
i. 'remove_duplicates' CTE (2nd CTE): Create a new column named 'row_num' containing the unique number the 
ROW_NUMBER() window function assigns to each row within a partition.
ii. 'without_duplicates' CTE (3rd CTE): Extract all columns from the 'remove_duplicates' CTE where row_num = 1.

3. Main Query:
i. Write 2 Inner Joins so that the 'without_duplicates' (!) table can be linked to the skills_dim table, which holds the names of the skills.
ii. WHERE clause: Include only the top-paying jobs and exclude the skills the person has already covered and those similar to them.
iii. Group by skill name.
iv. Having count(job_id) > 25 (Include only skills that are in-demand)
v. Order by AVG(salary_year_avg) DESC; to get the top-paying skills
vi. Retrieve the skill name, the count of each skill, and the average salary associated with each skill.

4. Notes:
i. AVG(jpf.salary_year_avg) = Average salary of the annual salary column, jpf.salary_year_avg, for the 'highest_paying_jobs' CTE.
ii. ROUND(AVG(hpj_wd.salary_year_avg),-3) AS avg_salary_per_skill = Average salary associated with each skill of the top-paying Senior Data Analyst jobs.
iii. The analysis of the salary distribution of the previous step (4_III.a.) showed that the mean is slightly smaller than the median:
salary_year_avg: mean = 153,653.4 < median = 155,000.0 < mode = 157,500.0 . Hence, the mean of the distribution will be used in
this script to extract only the job postings that are associated with the highest salaries.

*/
--------------------------------------------------------------------------------------------------------------------
-- 1st CTE - CTE of the previous step (4_III.a.)
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
),

/*
-- This will return a single value representing the count of all rows in the table
SELECT COUNT(*) AS total_number_of_rows
FROM highest_paying_jobs
-- Result = 1685 entries/data rows (Without the outlier)
-- (COUNT() does not include the header row in its count, but includes NULL values and duplicate rows.)
*/

-- 2nd & 3rd CTEs - Remove Duplicate Rows
remove_duplicates AS (
    SELECT
        *,
        ROW_NUMBER() OVER ( -- Assigns a unique number to each row within a partition of a result set (within a group of duplicates in this case)
            PARTITION BY job_title, job_location, company_name, salary_year_avg -- Divides the result set into partitions, i.e., rows with the same values for
                                                                                --`job_title`, 'job_location`, `company_name`, and `salary_year_avg` are grouped together.
            ORDER BY job_id -- Order by the primary key column in the dataset (= unique identifier for each row), which is 'job_id'.
                            -- Order By is responsible for the numbering of duplicate rows within each partition
                            -- Each group of duplicate rows will be numbered 1, 2, 3, etc., with 1 being assigned to the row with the lowest job_id in each group.
        ) AS row_num
    FROM highest_paying_jobs
),
without_duplicates AS (
    SELECT *
    FROM remove_duplicates
    WHERE row_num = 1 -- Retrieve all columns from the 'remove_duplicates' CTE where row_num = 1,
		              -- effectively keeping only the first occurrence of each group and removing duplicates (equivalent of keep ='first').
)

/*
SELECT COUNT(*) AS total_number_of_rows
FROM without_duplicates
-- Result = 1589 entries/data rows (Without the outlier)
*/
--------------------------------------------------------------------------------------------------------------------
-- Main Query
SELECT
    skills.skills AS skill_name,
    COUNT(hpj_wd.job_id) AS demand_count,--To not include skills that are not in-demand (having a low count)
    ROUND(AVG(hpj_wd.salary_year_avg),-3) AS avg_salary_per_skill --Average salary associated with each skill
--Extract only the job ids of the 3rd CTE ('without_duplicates'), that is, the job ids of 
--all Senior Data Scientist jobs that mention salary (in descending order of salary_year_avg), excluding the outlier and any duplicate rows.
FROM
    without_duplicates AS hpj_wd --highest_paying_jobs_without_duplicates
INNER JOIN skills_job_dim AS middle
    ON hpj_wd.job_id = middle.job_id
INNER JOIN skills_dim AS skills
    ON middle.skill_id = skills.skill_id
WHERE
--Retrieve only the postings that mention a salary that is higher than 
--the average salary of the 'without_duplicates.salary_year_avg' column (hpj_wd.overall_avg_salary).
    hpj_wd.salary_year_avg > hpj_wd.overall_avg_salary AND
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
    COUNT(hpj_wd.job_id) > 25 --exclude skills that appear in less than 25 job postings
ORDER BY
    avg_salary_per_skill DESC;