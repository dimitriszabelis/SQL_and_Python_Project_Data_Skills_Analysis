/*

Q: 4_II.b. Which industry sectors offer the most Senior Data Scientist jobs?

1. Use the SQL query of the previous script as a CTE (companies) to get the names of the companies
that offer 25 or more Senior Data Scientist jobs.
2. Write another CTE based on the 'companies' CTE to find the total number of job openings and to
create the column that will hold the names of the sectors.
3. In the main query use the 2nd CTE (sectors), group by the particular sector, 
and retrieve the sectors and their market share for the senior Data Scientist jobs.

*/
WITH companies AS (
    SELECT
        cmp.name AS company_name,
        COUNT(jpf.job_id) AS senior_DS_companies
    FROM
        job_postings_fact AS jpf
    INNER JOIN company_dim AS cmp
        ON jpf.company_id = cmp.company_id
    WHERE
        jpf.job_title_short = 'Senior Data Scientist' AND
        cmp.name NOT IN ('Confidenziale', 'Confidential','Confidencial') --Exclude openings that do not mention company name
    GROUP BY
        cmp.name
    HAVING
        COUNT(jpf.job_id) >= 25 --More than 25 jobs postings
    ORDER BY
        senior_DS_companies DESC
), sectors AS (
    SELECT
        company_name,
        senior_DS_companies,
        SUM(senior_DS_companies) OVER () AS total_count_having25,
--      This list is not exhaustive because there is a huge number of companies to add (even when using chatbots). Also, there are several companies that operate in multiple sectors, complicating the categorization process.
--      Finally, some companies often post the job offerings with slightly different names (e.g. 'Jobleads-UK','Jobleads','JobLeads GmbH'). This should be addressed as well because it may lead to duplicate rows, thus skewing the results.
        CASE
            WHEN company_name IN ('Walmart', 'Target', 'Amazon', 'Walgreens','Sam''s Club','Etsy', 'WALGREENS', 
                                 'Shopify', 'The Home Depot','Vinted','84.51°') THEN 'Retail'
            WHEN company_name IN ('Wells Fargo', 'Visa', 'Citi', 'Fidelity Investments', 'Capital One', 'JPMorgan Chase & Co.', 'American Express',
                                 'Danske Bank', 'DBS Bank Limited','Rabobank','Deutsche Bank', 'Nordea Bank','Bank of Ireland','Nubank', 'U.S. Bank',
                                 'Lloyds Banking Group','Experian','Equifax','Intuit','Citizens Bank','Square','Airwallex','SoFi', 'PayPal', 'TIAA', 
                                 'Vanguard', 'TransUnion', 'Block', 'Klarna','S&P Global','Monzo','ADP','Coinbase','FIS','GEICO', 'State Farm','MetLife','Citizens') THEN 'Banking & Financial Services' -- (Banking, investment management, insurance, payment processing, and financial advisory services)
            WHEN company_name IN ('UnitedHealth Group', 'CVS Health', 'CVS Pharmacy','Humana', 'Elevance Health', 'AstraZeneca', 'Pfizer', 'Johnson & Johnson',
                                 'Genentech','AbbVie', 'GSK','Amgen','Elevance Health','IQVIA','Syneos Health','J&J Family of Companies', 'Novo Nordisk',
                                 'Bristol Myers Squibb', 'Thermo Fisher Scientific', 'Veeva Systems', 'Merck', 'Syneos Health - USA', 'Boehringer Ingelheim') THEN 'Healthcare & Biotechnology'
            WHEN company_name IN ('Microsoft', 'Oracle', 'Apple', 'Google', 'IBM', 'Salesforce', 'SAP','Dice', 'EPAM Systems','EPAM Anywhere','BairesDev','Tiger Analytics',
                                 'RELX','Globant','Bairesdev','BairesDev SA','Snowflake', 'HP', 'Dell Technologies', 'Atlassian', 'Grammarly','AgileEngine','Turing','STR','AUTO1 Group') THEN 'Technology'
            WHEN company_name IN ('Booz Allen Hamilton', 'Deloitte', 'EY', 'PwC','McKinsey & Company','Accenture','Boston Consulting Group','Capgemini',
                                 'Sia Partners','Guidehouse','CGI', 'BearingPoint','X4 Technology','AkaPeople','akapeople','Wolters Kluwer') THEN 'Consulting'
            WHEN company_name IN ('Harnham', 'Emprego', 'Michael Page', 'Robert Walters', 'Motion Recruitment', 'Jobs for Humanity', 'CyberCoders',
                                 'Jobot','Vesterling AG','Hays', 'Robert Half','ClickJobs.io', 'Xcede', 'Crossover','VirtualVocations','Barrington James',
                                 'Randstad','Insight Global','CLevelCrossing','Jobleads-UK','Jobleads','JobLeads GmbH','myGwork','ClearanceJobs','Archer - The IT Recruitment Consultancy','Resume Library') THEN 'Recruitment'
            WHEN company_name IN ('Publicis Groupe', 'NielsenIQ', 'dunnhumby', 'Acxiom','Chartboost') THEN 'Marketing'
            WHEN company_name IN ('Verizon', 'AT&T','Cox Enterprises','DISH', 'Dish Network','Cox Communications', 'Vodafone') THEN 'Telecommunications'
            WHEN company_name IN ('Netflix', 'Disney','TikTok','Roku','Spotify','Tripadvisor','Airbnb','2K','Activision Blizzard','King', 'Roblox') THEN 'Entertainment' --- (Films, music, television, gaming, etc.)
            WHEN company_name IN ('PepsiCo', 'Procter & Gamble','Unilever','Mars', 'Nestlé') THEN 'Consumer Goods'
            WHEN company_name IN ('FedEx', 'UPS','Wolt','Wolt Oy','Uber','Grab','Careem') THEN 'Transportation Services'
            WHEN company_name IN ('Caterpillar', 'General Motors','Honeywell','SAIC','Tesla','Continental') THEN 'Manufacturing'
            WHEN company_name IN ('ExxonMobil', 'Chevron','Shell','BP Energy','Society of Exploration Geophysicists') THEN 'Oil & Gas'
            WHEN company_name IN ('Coursera', 'Udemy') THEN 'Education'
            WHEN company_name IN ('Cargill','Logistics Management Institute') THEN  'Logistics & Supply Chain'
            WHEN company_name IN ('Lockheed Martin','Northrop Grumman','Leidos','BAE Systems','Peraton') THEN  'Aerospace & Defense'
            WHEN company_name IN ('CBRE Group','Zillow') THEN  'Real Estate'
            WHEN company_name IN ('U.S. Government Accountability Office (GAO)','New Zealand Government') THEN  'Government & Public Sector'
            ELSE 'Other'
            END AS sector_name
    FROM
        companies
    ORDER BY
        senior_DS_companies DESC
)

--SELECT * FROM sectors WHERE sector_name='Other' 
--> Only 'GITR' appears on 'Other' (No information about a company named GITR offering 28 Senior Data Scientist jobs in 2023)

--Find the market share of each sector for the senior Data Scientist jobs, that is,
--the proportion of total senior Data Scientist job openings available within a specific sector
--compared to the overall number of senior Data Scientist jobs across all sectors (>=25 openings per company).
SELECT
    sector_name,
--  Total number of jobs offered by companies of the same sector over the total number of jobs offered
--  by companies that offer 25 or more Senior Data Scientist jobs.
    ROUND( (( SUM(senior_DS_companies) / total_count_having25 ) * 100.0) ,1 ) AS market_share
FROM
    sectors
GROUP BY
    sector_name, total_count_having25
ORDER BY
    market_share DESC;