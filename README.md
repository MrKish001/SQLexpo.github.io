# SQLexpo.github.io
Exploratory Project

What I will be doing in this project-
1. Looking for any possible trends.
2. EDA Process and more.


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
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
    


