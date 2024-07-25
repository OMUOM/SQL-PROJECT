# DATA CLEANING WITH SQL

# Layoff Project

## Introduction
Data cleaning is the process of identifying and correcting errors, inconsistencies and inaccuracies within a dataset to improve its quality, accuracy, and reliability for analysis or other applications. It's often the most crucial step in the data analysis pipeline.

## Overview
The dataset includes global layoff data from 2021 to 2023. It details companies that implemented layoffs, their locations, specific layoff dates, industry sectors, number of employees affected, stage of the company  and the countries where the companies operate.

## SQL Code Explanation

* ## Removing Duplicates
Involves identifying and eliminating identical records from a dataset. This step is crucial for maintaining data accuracy, integrity and efficiency in analysis.
  
```SQL
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,[location], industry, total_laid_off, percentage_laid_off, [date],
stage,country,funds_raised_millions ORDER BY company ) AS Raw_Number
FROM HAMAN..layoffs$
--ORDER BY 1

WITH duplicate_cte as
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,[location], industry, total_laid_off, percentage_laid_off, [date],
stage,country,funds_raised_millions ORDER BY company ) AS Raw_Number
FROM HAMAN..layoffs$
)
SELECT *
FROM duplicate_cte
WHERE Raw_Number >1


SELECT * -- this is for helping me assertain that Casper has indeed been repeated.
FROM HAMAN..layoffs$
WHERE company like '%Casper%'


WITH duplicate_cte as
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company,[location], industry, total_laid_off, percentage_laid_off, [date],
stage,country,funds_raised_millions ORDER BY company ) AS Raw_Number
FROM HAMAN..layoffs$
)
DELETE  -- This has helped me delete rows with more than 1 entries.
FROM duplicate_cte
WHERE Raw_Number >1
```

* ## Standardizing The Data
This is the process of transforming data into a consistent format to improve its quality and reliability.

```SQL
SELECT Company, (TRIM(Company))
FROM HAMAN..layoffs$

UPDATE HAMAN..layoffs$   -- the trim function has been updated appropriately
SET company = (TRIM(Company))

SELECT DISTINCT industry -- this helps with the cleaning of the industry column
FROM HAMAN..layoffs$			---AS we can see the crypo industry is keyed in in different names but it all mean the same thing
ORDER BY 1

SELECT *
FROM HAMAN..layoffs$
WHERE industry like '%crypto%'

UPDATE HAMAN..layoffs$
SET industry = 'Crypto'
WHERE industry like 'crypto%'

SELECT DISTINCT [location]
FROM HAMAN..layoffs$			
ORDER BY 1

SELECT DISTINCT country --I have realised that the US has some spelling error hence two entries.
FROM HAMAN..layoffs$			
ORDER BY 1

SELECT *
FROM HAMAN..layoffs$	
WHERE country LIKE 'United States%'
ORDER BY 1

SELECT DISTINCT country, TRIM(TRAILING '.' FROM Country)
FROM HAMAN..layoffs$			
ORDER BY 1

UPDATE HAMAN..layoffs$
SET country = TRIM(TRAILING '.' FROM Country)
WHERE country like 'United States%'

--SELECT "date"
----STR_TO_DATE ("date", '%m/%d/%Y')
--FROM layoffs$
```
  
* ## Null Values or Blank
 It involves identifying and eliminating missing or empty data points to improve data quality and accuracy for analysis.

```SQL
SELECT *
FROM HAMAN..layoffs$
WHERE total_laid_off IS NULL
--AND percentage_laid_off IS NULL

SELECT *
FROM Haman..layoffs$
WHERE industry IS NULL
OR industry = ''
ORDER BY 1

SELECT *
FROM HAMAN..layoffs$
WHERE company like 'airbnb%'

UPDATE HAMAN..layoffs$
SET industry = null
WHERE industry = ' '

SELECT t1.industry, t2.industry
FROM HAMAN..layoffs$ t1
JOIN HAMAN..layoffs$ t2
	ON t1.company = t2.company
	AND t1.[location] = t2.[location]
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL


--UPDATE HAMAN..layoffs$ t1
--JOIN HAMAN..layoffs$ t2
--	ON t1.company = t2.company
--SET t1.industry = t2.industry
--WHERE t1.industry IS NULL
--AND t2.industry IS NOT NULL

UPDATE HAMAN..layoffs$
SET percentage_laid_off = null
WHERE percentage_laid_off = 'NULL'

SELECT *--total_laid_off, percentage_laid_off
FROM HAMAN..layoffs$
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL

DELETE
FROM HAMAN..layoffs$
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL

ALTER TABLE HAMAN..[layoffs$]
ALTER COLUMN percentage_laid_off float NULL
GO
```
 
  
