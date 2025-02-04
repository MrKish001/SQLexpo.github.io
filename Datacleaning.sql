 Select *                    /* Checking all the raw data */
FROM layoffs;

Create Table layoff_staging
Like layoffs
;

Select *                                     /* Creating a duplicte table to work on, preventing the raw data loss */
From layoff_staging
;

Insert layoff_staging
Select *
From layoffs
;

                             /* Finding the Duplicates */         

Select *,
Row_number() Over(Partition By company, industry, total_laid_off, percentage_laid_off, `date` ) As row_num
From layoff_staging
;

With duplicate_cte As
(
Select *,
Row_number() Over(Partition By company, industry, total_laid_off, percentage_laid_off, `date` , stage , country , funds_raised_millions) As row_num
From layoff_staging
)
Select*
From duplicate_cte
Where row_num>1
;

Select*
From layoff_staging                      /* Checking duplicate values */   
Where company = 'Casper'
;



						                 /* Deleting the duplicte data */     
                                         
                                         
                                         
                                         
CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,                        /* Creating new table to delete the duplicate value having  row-num>2*/ 
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


Select * 
From layoff_staging2  
Where row_num > 1            
;

Insert INTO layoff_staging2
Select *,
Row_number() Over(Partition By company, industry, total_laid_off, percentage_laid_off, `date` , stage , country , funds_raised_millions) As row_num
From layoff_staging
;



delete 
From layoff_staging2                     
Where row_num > 1 
;
          
Select * 
From layoff_staging2    
;        

                                                            -- Standardiing data

Select company, trim(company)
From layoff_staging2
;

UPDATE layoff_staging2
SET company = TRIM(company)                      
;

                   
Select Distinct industry
From layoff_staging2
;

Select*
From layoff_staging2
Where industry LIKE "Crypto%"
;
                                                      /* Checking and Updating the column industry*/ 

Update layoff_staging2
SET industry = "Crypto"
Where industry LIKE "Crypto%"
;

                                                      /* Checking and Updating the column country*/ 
                                                      

Select distinct country
From layoff_staging2
;

Select distinct country
From layoff_staging2
Where country LIKE "United State%"
;

Select distinct country, TRIM(TRAILING '.' FROM Country)
From layoff_staging2
Where country LIKE "United State%"
;

Update layoff_staging2
SET country =  TRIM(TRAILING '.' FROM Country)
Where country LIKE "United State%"
;

							-- Changing date type from String to Date
                            
Select `date`,
str_to_date(`date`, '%m/%d/%Y')
From layoff_staging2
;

Update layoff_staging2
SET `date` =  str_to_date(`date`, '%m/%d/%Y')
;

							 -- Dealing with the null and black data
                             
Select *
From layoff_staging2
Where total_laid_off IS NULL
And percentage_laid_off IS NULL
;

Select *
From layoff_staging2
Where industry IS NULL
or industry = ""
;

							-- Deleting the useless data
                            


SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
;


SELECT *
FROM layoff_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


DELETE FROM layoff_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoff_staging2;

ALTER TABLE layoff_staging2
DROP COLUMN row_num;


SELECT * 
FROM layoff_staging2;

							
					                               --Project_2
                        
                            
                            
                            
SELECT * 
FROM layoff_staging2;


SELECT MAX(total_laid_off)
FROM layoff_staging2;

                                    -- Checking Percentage of the layoffs

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoff_staging2                              
WHERE  percentage_laid_off IS NOT NULL;



                                    -- Companies having 1 is 100 percent of they company laid off
                                    
SELECT *
FROM layoff_staging2
WHERE  percentage_laid_off = 1;


                                    --  Ordering by funcs_raised_millions
SELECT *
FROM layoff_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


                                    -- Companies with the biggest single Layoff in a single day


SELECT company, total_laid_off
FROM layoff_staging2
ORDER BY 2 DESC
LIMIT 7;

                                     -- Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off) AS Total_laid_Emp
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;



									-- By location
SELECT location, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;


SELECT country, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY country                                       /* Checking total laid off per country*/ 
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM layoff_staging2
Where Year(date) Is not Null                           /*  Yearly*/
GROUP BY YEAR(date)
ORDER BY 1 ASC;


SELECT industry, SUM(total_laid_off)                  
FROM layoff_staging2             
GROUP BY industry                                      /*Industry wise */
ORDER BY 2 DESC;


SELECT stage, SUM(total_laid_off)
FROM layoff_staging2                                    /* Stage wise */ 
GROUP BY stage
ORDER BY 2 DESC;



                                    /*  Checking he laid off per year & ranking the companies basis on ASC laid off*/
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoff_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;




									    /* Rolling Sum */
                                     
                                     
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoff_staging2
GROUP BY dates
ORDER BY dates ASC;


WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoff_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;  
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
			