# DATA CLEANING WITH SQL

# Layoff Project

## Introduction
Data cleaning is the process of identifying and correcting errors, inconsistencies, and inaccuracies within a dataset to improve its quality, accuracy, and reliability for analysis or other applications. It's often the most crucial step in the data analysis pipeline.

## Overview
The dataset includes global layoff data from 2021 to 2023. It details companies that implemented layoffs, their locations, specific layoff dates, industry sectors, number of employees affected, specific dates, stage of the company  and the countries where the companies operate.

## SQL Code Explanation

* ## Removing Dublicates
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
