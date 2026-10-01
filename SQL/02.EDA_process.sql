-- Explore Data Anlytics
-- BUSINESS QUESTION
-- 1. Which country has the highest record of total lay off
-- 2. Within that county which year recorded the highest number of layoffs
-- 3. Which industries contribute the largest share of layoffs during that peak year?
-- 4. Among companies in the identified country, peak year, and highest-layoff industry, 
-- which funding stages were associated the most with the reported layoffs?
-- 5. Which company actualy drove the layoffs
-- 6. Is there a relationship or correlation between the amount of funding raised and the scale of layoffs across dataset?
DELETE FROM layoffs_copy2
WHERE (total_laid_off is NULL OR total_laid_off = '')
AND (percentage_laid_off is NULL OR percentage_laid_off = '');

ALTER TABLE layoffs_copy2
DROP column row_num;

SELECT country,
SUM(total_laid_off) AS total_layoffs,
COUNT(total_laid_off) AS layoffevent_recorded_with_data,
COUNT(*) as total_layoffevent_recorded
FROM layoffs_copy2
GROUP BY country
ORDER BY total_layoffs DESC; 
-- United State has 1,026 recorded layoffs event with avalivale layoff count data
-- involving a total of 256,059 people. 
-- There are 266 additional recorded where the number of employee laid off is unvailable 

-- 2. Within that county which year recorded the highest number of people layoffs
SELECT YEAR(date) as peak_year,
	SUM(total_laid_off) as total_layoffs
FROM layoffs_copy2
WHERE country = 'United States'
GROUP BY YEAR (date) 
ORDER BY total_layoffs DESC;

-- In 2022 a total 106,520 people were laid off, making it the year  of the highest number
-- for layoffs during the 2020-2023 period based on reported layoffs data

-- 3. Which industries contribute the largest share of layoffs during that peak year?
SELECT industry,
SUM(total_laid_off) as total_layoffs
FROM layoffs_copy2
WHERE YEAR(date) = 2022 AND country = 'United States'
GROUP BY industry
ORDER BY  total_layoffs DESC;

-- Consumer recorded the highest reported layoffs, with 17,775 employees, 
-- followed by Retail with 13,522 employees, among 28 industries with available industry data

-- 4. Among companies in the identified country, peak year, and highest-layoff industry, 
-- which funding stages were associated with the reported layoffs?
SELECT *
FROM layoffs_copy2;

SELECT stage, 
SUM(total_laid_off) as total_layoffs,
COUNT(total_laid_off) as record
FROM layoffs_copy2
WHERE country = 'United States' AND YEAR(date) = 2022
AND industry = 'Consumer'
GROUP BY stage
ORDER BY total_layoffs DESC;

-- In 2022, among customer industry companies in Unites States, POST-IPO companies 
-- recorded the highest reported layoffs, totalling 16,113 employees across 5 records
-- with available total laid off data

-- 5. Which company actualy drove the layoffs?
SELECT company,
SUM(total_laid_off) as total_layoffs,
COUNT(total_laid_off) as recorded
FROM layoffs_copy2
WHERE country = 'United States' 
	AND stage = 'Post-IPO'
    AND YEAR(date) = 2022
    AND industry = 'Consumer'
GROUP BY company
ORDER BY total_layoffs DESC;

-- Meta presented for approximately 61.9% of the reported layoffs in the Consumer
-- industry in 2022, with 11,000 layoffs out of total 17,775

-- 6. Is there a relationship or correlation between the amount of funding raised and the scale of layoffs across dataset?
SELECT total_laid_off, funds_raised_millions
FROM layoffs_copy2
WHERE funds_raised_millions IS NOT NULL
AND total_laid_off IS NOT NULL;

-- Further analysis will be presented trough scateer plot and correlation analysis
-- in the dashboard

