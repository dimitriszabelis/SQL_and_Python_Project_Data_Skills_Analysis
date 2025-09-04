<h1 style="text-align:center;">SQL & Python Project: Exploring In-Demand Skills for Data Professionals</h1>

## About this Project

I am an aspiring data professional seeking to carve my own path in the dynamic domain of Data Science. To navigate this sector, I would like to investigate what the most important data-related skills are, so that I can determine what skills I should target as I gain more experience in this field.

This project will serve as a guide to aspiring data professionals that would like to be equipped with a diverse range of skills so that they can not only learn the most relevant skills, but also increase their market value.

## Dataset

To accomplish that, this project will utilize Luke Barousse's [dataset](https://www.lukebarousse.com/sql) (under 2. Advanced Chapter - Files > Advanced & Project Dataset Files), which is a dataset of real-world data science job postings that appeared on Google's search results starting **from December 2022 up to and including December 2023**.

It should be noted that the extended and up-to-date version of this dataset is the dataset that powers up Luke Barousse's app [datanerd.tech](https://datanerd.tech/). This app collects data daily from job openings from all around the world and aims to unravel what the most in-demand skills and top paying jobs actually are in the data science industry, so that data professionals can make informed decisions while learning skills and negotiating their salaries.

As mentioned before, the dataset comprises job openings that come from all around the globe. Besides that, the total pool of job postings features jobs that can be either remote or on-site. Moreover, the dataset includes all contract types (mainly full-time, part-time, freelance, and internship contracts), even though most of the job postings refer to full-time schedules. Finally, the dataset holds information on whether a degree is mentioned in each one of the job openings.

The main table of the database, job_postings_fact, consists of approximately 800,000 records (787,686 to be exact). The most important columns of this table are the following:
- job_id
    - Column that holds the **unique id** of each **job opening**.
- company_id
    - Column that holds the **unique id** of each **company** that offers at least one job.
- job_title_short
    - Column that holds the job title of each job opening.
    - Filtering by this column occurs when the records of each one of the three main data-related disciplines need to be extracted from the job_postings_fact table ([see 'Domains & Associated Roles' below](#domains--associated-roles)).
- salary_year_avg
    - Column that holds the **annual salaries** for the offered jobs.
        - Note that each value in each row of this column represents the average (mean) of the salary range listed in each job posting, since most companies do not advertise a single salary value, but rather a salary range. 
    - Filtering by this column occurs in queries that retrieve the top-paying jobs and their skills (`salary_year_avg IS NOT NULL –so that only the job postings that include compensation are taken into account`).

The database also contains three complementary tables that will be utilized throughout this project. The first one is the skills_job_dim table that only features two columns, one for each key that connects it to either the main table or the second supplementary table, which is called skills_dim. The latter includes both the skill_id key and the actual data-related skills that are connected to the job postings of the main table through the job_id & skill_id keys. Finally, the third complementary table is called company_dim and it contains all the details of companies that offer at least one job. The most important columns of all three supplementary tables are the following:
- skills_job_dim
    - job_id
    - skill_id
- skills_dim
    - skill_id
    - skills
        - Column that holds the names of the skills that are included in different job postings.
- company_dim
    - company_id
    - name
        - Column that holds the **names** of the companies that offer at least one job.

## Handling Degree Requirements

This project will be viewed from the perspective of someone who has just completed their studies and is looking to transition into the data science industry. Hence, they can apply to both the job openings that mention a degree and those which do not. Also, in that case, someone who not only has a degree but also the appropriate skills for the role, could apply for entry-level positions in all three disciplines of the industry, namely the Data Analytics, Data Science, and Data Engineering domains.

The people who do not hold a degree shouldn't be discouraged, since many job openings in that sector do not mention a degree. However, they should know that they will experience a harder time, because the pool of job openings they will be able to apply for will be substantially smaller (30% of the total number of job postings) and even harder time if they want to become data scientists, because, in that case, the pool shrinks even more (6.2% of the total number of postings in the discipline of Data Science mention no degree).

For those people, this project should only be considered as a preliminary report that will give them a general overview of the job market for this industry. Then, what they should do is modify this project so that it includes the following condition:
- `WHERE job_no_degree_mention = TRUE`,

in order to investigate what the most important skills are for the actual portion of the pool of job openings they can access.

Moreover, the career path should also change, so that it takes into account the fact that the only way someone can become a data scientist without a degree, is by proving their hands-on experience in the field by conducting their own projects and/or by transitioning into the field from Data Analyst or Data Engineer positions.

## Domains & Associated Roles

**Data Analytics Domain** (275,042 job openings)
- Business Analyst
- Data Analyst
- Senior Data Analyst

**Data Science Domain** (209,802 job openings)
- Data Scientist
- Senior Data Scientist

**Data Engineering Domain** (231,371 job openings)
- Data Engineer
- Senior Data Engineer

Please note that the remaining 71,471 job openings, which would complete the total records that comprise the dataset, will be excluded from the queries of the project, because they feature job titles (Cloud Engineer, Software Engineer, and Machine Learning Engineer) whose core responsibilities differ from the roles in the aforementioned domains, even though they feature overlapping skills and tools. Hence, the total number of relevant job openings for this project will be 716,215.

## Career Paths

<u>First Step</u>:
- If you are unsure which data-related discipline you want to pursue and prefer to decide later after gaining some experience, the first step is to focus on learning all the **most in-demand overlapping skills** from all three data-related domains. That way, you will avoid wasting time pursuing skills that won't be relevant to the jobs you will be applying for or carrying out in the future.

<u>Second Step</u>:
- Once you have learned the skills of the first step and have decided on the domain you want to delve into, you should then learn the most in-demand skills of that **specific domain** (Data Analytics, Science, or Engineering) that you **haven't already covered**. These will be the foundational skills you will need to possess to operate in this domain and simultaneously the skills you will most likely deepen your expertise in as your career progresses.
- During your journey, if you discover that the domain you chose does not align with your interests and personality, or if you wish to explore the other two domains to get a border perspective, you can always repeat the same step until you reach your goal.

<u>Third Step</u>:
- After that, you should learn both the most in-demand skills and the top skills required for the highest-paying jobs, but only for the **senior position** in your domain.

<u>Fourth Step</u>:
- Finally, you should proceed by focusing on the skills that are the most relevant to your career growth and/or those you would like to explore further.

## Project Scenario 

- This project will follow someone who is unsure of the specific domain they would like to delve into and thus, they will first focus on learning all the most in-demand **overlapping skills** from all three data-related domains.

- Then, they will proceed by learning the most in-demand skills in the **Data Science** domain.

- After that, they will also choose to learn some of the most in-demand skills in the **Data Engineering** domain, because they will recognize their desire to gain a foundational understanding of the entire data lifecycle.

- Finally, they will decide to **specialize** in the Data Science domain and hence, they will choose to learn the most in-demand skills and the top skills required for the highest-paying jobs, specifically for the senior position in their domain.

## Key Questions

This project will help that person carve their own career path by providing all the necessary information they need throughout their learning journey.

<u>Key Questions to Address</u>:
- What are the most in-demand **overlapping** skills from all three data-related domains?
- What are the most in-demand skills in the Data **Science** domain?
- What are the most in-demand skills in the Data **Engineering** domain?
- Questions for the **Senior Data Scientist Position**
    - I. What are the most in-demand **skills** for the Senior Data Scientist role?
    - II. Which industry **sectors** offer the **most** Senior Data Scientist **jobs** and what are some examples of companies in these sectors?
    - III. Skills of the **Highest-Paying Jobs**
        - a. What are the highest-paying Senior Data Scientist **jobs**?
        - b. What are the **top-paying skills** required for these top-paying jobs?