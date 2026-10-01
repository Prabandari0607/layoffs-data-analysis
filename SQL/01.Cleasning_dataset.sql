-- Cleaning Data
-- 1. Cek Duplicate
-- 2. Standarization
-- 3. Cek Null or blank value
-- 4. Cek outlier

SELECT *
FROM layoffs;

CREATE TABLE layoffs_copy
LIKE layoffs;

INSERT INTO layoffs_copy
SELECT *
FROM layoffs;

WITH duplicate_cte as 
(
	SELECT*,
	ROW_NUMBER() OVER(
    PARTITION BY company, location, 
	industry, total_laid_off, 
	percentage_laid_off,`date`, 
	stage, country, funds_raised_millions) AS row_num
    FROM layoffs_copy
)
SELECT COUNT(*)
FROM duplicate_cte
WHERE row_num >1;

-- DELETE DUPLICATE
-- Buat copy kedua dari layoffs 
SELECT*
FROM layoffs_copy2;

SELECT*
FROM layoffs_copy2
WHERE row_num > 1;

DELETE 
FROM layoffs_copy2
WHERE row_num > 1;


-- STANDARIZATION
SELECT DISTINCT company
FROM layoffs_copy2;

SELECT company, TRIM(company)
FROM layoffs_copy2;

UPDATE layoffs_copy2
SET company = TRIM(company);

SELECT distinct location
FROM layoffs_copy2
ORDER BY 1;

SELECT distinct industry
FROM layoffs_copy2
order by 1;

SELECT *
FROM layoffs_copy2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_copy2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT distinct country
FROM layoffs_copy2
ORDER BY 1;

SELECT *
FROM layoffs_copy2
WHERE country = 'United States.';

UPDATE layoffs_copy2
SET country = TRIM(TRAILING '.' FROM country);

SELECT `date`
FROM layoffs_copy2;

UPDATE layoffs_copy2
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y');

ALTER TABLE layoffs_copy2
MODIFY COLUMN `date` DATE;

-- HANDLING NULL VALUES AND CHECK BLANK SPACE
SELECT COUNT(*)
FROM layoffs_copy2
WHERE total_laid_off is null AND
percentage_laid_off is NULL;

SELECT*
FROM layoffs_copy2
WHERE industry is NULL 
OR industry= '';

SELECT*
FROM layoffs_copy2
WHERE company = 'Airbnb';

UPDATE layoffs_copy2
SET industry = NULL
WHERE industry = '';

SELECT*
FROM layoffs_copy2 t1
JOIN layoffs_copy2 t2
    ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry is NULL
AND t2.industry IS NOT NULL;

UPDATE layoffs_copy2 t1
JOIN layoffs_copy2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_copy2
WHERE `date` IS NULL;

SELECT stage,
COUNT(*) as Total
FROM layoffs_copy2
GROUP BY stage
ORDER BY Total;

SELECT distinct *
FROM layoffs_copy2
;

SELECT COUNT(*)
FROM layoffs_copy2
WHERE funds_raised_millions IS NULL OR 
funds_raised_millions = '';

DELETE
FROM layoffs_copy2
WHERE `date` is NULL;

DELETE
FROM layoffs_copy2
WHERE industry is NULL;



