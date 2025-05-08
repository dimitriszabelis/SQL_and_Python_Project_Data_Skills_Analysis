/*

4_II.d. Use the previous SQL scripts in order to retrieve all the companies of the 'Healthcare & Biotechnology' sector.

Notes:
1. Keep everything in '2_sectors.sql' as it is, but remove the main query.
2. Integrate into this script the SELECT statement for the 'Healthcare & Biotechnology' sector from '3_largest_companies_largest_sectors.sql'.
i. Extracts only the companies of the 'Healthcare & Biotechnology' sector.
ii. Sorts the results in descending order by the total number of Senior Data Scientist job postings each company offers (senior_DS_companies).

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
                                 'Genentech','AbbVie', 'GSK','Amgen','IQVIA','Syneos Health','J&J Family of Companies', 'Novo Nordisk',
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
------------------------------------------------------------------------------
------------------------------------------------------------------------------
SELECT
    company_name,
    senior_DS_companies
FROM
    sectors
WHERE
    sector_name = 'Healthcare & Biotechnology'
ORDER BY
    senior_DS_companies DESC
------------------------------------------------------------------------------
------------------------------------------------------------------------------