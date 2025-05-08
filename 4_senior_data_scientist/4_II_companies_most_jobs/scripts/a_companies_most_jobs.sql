/*

Q: 4_II.a. What companies offer the most Senior Data Scientist jobs?

1. Inner join company_dim on job_postings_fact to get the names of the companies.
2. Group by the name of each company.
3. Exclude companies that offer less than 25 Senior Data Scientist jobs.
4. Order by the count of job openings that each company has posted (descending order).

*/

SELECT
    cmp.name AS company_name,
    COUNT(jpf.job_id) AS senior_DS_companies
FROM
    job_postings_fact AS jpf
INNER JOIN company_dim AS cmp
    ON jpf.company_id = cmp.company_id
WHERE
    jpf.job_title_short = 'Senior Data Scientist'
GROUP BY
    cmp.name
HAVING
    COUNT(jpf.job_id) >= 25 --More than 25 jobs postings
ORDER BY
    senior_DS_companies DESC;