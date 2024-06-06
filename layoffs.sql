SELECT *
FROM HAMAN..layoffs$

SELECT *
FROM HAMAN..layoffs$

--STEPS 
--1. REMOVE ALL DUBLICATES
--2. STANDADIZE THE DATA
--3. NULL VALUES OR BLANK VALUES
--4. REMOVE ANY COLUMNS THAT ARE NOT NECESSARY

--CREATE TABLE layoffs_stagging
--FROM HAMAN..layoffs$
--LIKE layoffs$

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



--2. STANDARDIZING DATA

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

SELECT *
FROM HAMAN..layoffs$
WHERE percentage_laid_off = 1

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM HAMAN..layoffs$

SELECT *
FROM HAMAN..layoffs$
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC

SELECT *
FROM HAMAN..layoffs$
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC

SELECT company, SUM(total_laid_off)
FROM HAMAN..layoffs$
GROUP BY company
ORDER BY 2 DESC

SELECT MIN([date]), MAX([date])
FROM HAMAN..layoffs$

SELECT industry, SUM(total_laid_off)
FROM HAMAN..layoffs$
GROUP BY industry
ORDER BY 2 DESC

SELECT country, SUM(total_laid_off)
FROM HAMAN..layoffs$
GROUP BY country
ORDER BY 2 DESC

SELECT YEAR([date]), SUM(total_laid_off)
FROM HAMAN..layoffs$
GROUP BY YEAR([date])
ORDER BY 2 DESC

SELECT stage, SUM(total_laid_off)
FROM HAMAN..layoffs$
GROUP BY stage
ORDER BY 2 DESC


ALTER TABLE HAMAN..[layoffs$]
ALTER COLUMN [date] date
GO

SELECT MONTH([date]) AS [MONTH], SUM(total_laid_off)
FROM HAMAN..layoffs$
WHERE MONTH([date]) IS NOT NULL
GROUP BY MONTH([date])
ORDER BY 1 DESC

--SELECT DATEPART (YEAR, [date]), DATEPART (MONTH, [date]), SUM(total_laid_off)
--FROM HAMAN..layoffs$
--WHERE DATEPART (YEAR, [date]) IS NOT NULL
--GROUP BY DATEPART (MONTH, [date])
--ORDER BY 2 DESC


SELECT company,YEAR([date]), SUM(total_laid_off)
FROM HAMAN..layoffs$
GROUP BY company, YEAR([date])
ORDER BY 3 DESC





WITH Company_Year  (Company, years, total_laid_off) as -- This CTE will be used to rank which company laid off the most per year
(
SELECT company,YEAR([date]), SUM(total_laid_off)
FROM HAMAN..layoffs$
GROUP BY  YEAR([date]), company
)
SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC 





WITH Company_Year  (Company, years, total_laid_off) as 
(
SELECT company,YEAR([date]), SUM(total_laid_off)
FROM HAMAN..layoffs$
GROUP BY  YEAR([date]), company
), Company_Year_Rank AS
(
SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
--ORDER BY Ranking ASC 
)
SELECT*
FROM Company_Year_Rank
--WHERE Ranking <= 5 -- This here will show top 5 companies lay off per year