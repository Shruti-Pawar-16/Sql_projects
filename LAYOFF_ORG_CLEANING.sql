-- CLEANING layoff data
SELECT *
FROM layoffs_org;

--  Imported the CSV file and altering the column names
ALTER TABLE `layoff_db`.`layoffs_staging` 
CHANGE COLUMN `ï»¿Company` `Company` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Location HQ` `Location_HQ` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `# Laid Off` `Laid_Off` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `%` `Percentage_laid_off` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `$ Raised (mm)` `Fund_Raised_Millions` TEXT NULL DEFAULT NULL ,
CHANGE COLUMN `Date Added` `Date_Added` TEXT NULL DEFAULT NULL ;

SELECT *
FROM layoffs_org;

-- creating a staging table on which data manapulation will be done to keep original data untouch
CREATE TABLE layoffs_staging
SELECT *
FROM layoffs_org;

-- Inserting all the data from layoff_org into layoff_staging
INSERT INTO layoffs_staging
SELECT *
FROM layoffs_org;

SELECT *
FROM layoffs_staging;

-- REMOVING special character '%' from the column 'Percentage_laid_off' 
UPDATE layoffs_staging
SET Percentage_laid_off = REPLACE(Percentage_laid_off,'%','');

-- TRIMING the blank space from 'Percentage_laid_off' 
UPDATE layoffs_staging
SET Percentage_laid_off = TRIM(Percentage_laid_off);

-- Display 'Percentage_laid_off'  
SELECT Percentage_laid_off
FROM layoffs_staging;

SELECT *
FROM layoffs_staging
WHERE Percentage_laid_off = '';

-- REMOVING special character '$' from the column 'Fund_Raised_Millions' 
UPDATE layoffs_staging
SET Fund_Raised_Millions = REPLACE(Fund_Raised_Millions,'$','');
 
-- TRIMING the blank space from 'Fund_Raised_Millions'
UPDATE layoffs_staging
SET Fund_Raised_Millions = TRIM(Fund_Raised_Millions);

-- Display Fund_Raised_Millions
SELECT Fund_Raised_Millions
FROM layoffs_staging;

SELECT *
FROM layoffs_staging
WHERE Percentage_laid_off = '' 
AND Laid_Off = '';

-- UPDATING THE DATE FORMAT to standerd yyyy-mm--dd of column 'Date'
SELECT `Date`,
STR_TO_DATE(`Date`,'%d/%m/%Y')
FROM layoffs_staging;

-- perform update date function using 'STR_TO_DATE'
UPDATE layoffs_staging
SET `Date` = STR_TO_DATE(`Date`,'%d/%m/%Y');

-- UPDATING THE DATE FORMAT to standerd yyyy-mm--dd of column 'Date_Added'
SELECT Date_Added,
STR_TO_DATE(Date_Added,'%d/%m/%Y')
FROM layoffs_staging;

-- perform update date function using 'STR_TO_DATE'
UPDATE layoffs_staging
SET Date_Added = STR_TO_DATE(Date_Added,'%d/%m/%Y');

-- Replacing the empty space with NULL 
SELECT *
FROM layoffs_staging
WHERE Laid_Off = '';

-- Updating the empty space from column 'Laid_Off'
UPDATE layoffs_staging
SET Laid_Off = NULL
WHERE Laid_Off = '';

-- Updating the empty space from column 'Percentage_laid_off'
UPDATE layoffs_staging
SET Percentage_laid_off = NULL
WHERE Percentage_laid_off = '';

-- Updating the empty space from column 'Fund_Raised_Millions'
UPDATE layoffs_staging
SET Fund_Raised_Millions = NULL
WHERE Fund_Raised_Millions = '';

-- CREATE STAGING_2 TABLE WITH CORRECT DATATYPE
CREATE TABLE layoffs_staging2(
company varchar(250),
location varchar(250),
laid_off int,
layoff_date date,
percentage_laid_off decimal(10,2),
industry varchar(250),
website varchar(500),
stage varchar(100),
fund_raised_millions int,
country varchar(100),
date_added date
);

INSERT INTO layoffs_staging2
SELECT *
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;

-- Performing 'TRIM' function on 'company' column
SELECT *
FROM layoffs_staging2
ORDER BY company;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Creating a staging 3 table for handling duplicate values
CREATE TABLE layoffs_staging3
SELECT *
FROM layoffs_staging2;

-- Inserting all the data from layoffs_staging2 into layoff_staging3
INSERT INTO layoffs_staging3
SELECT *
FROM layoffs_staging2;

-- performing operation on 'location' column
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY location;

-- selecting similar location using wildcard  '%' for 'Gurugram%'
SELECT *
FROM layoffs_staging3
WHERE location LIKE 'Gurugram%';

-- Updating 'Gurugram' with 'Gurugram,Non-U.S.'
UPDATE layoffs_staging3
SET location = 'Gurugram,Non-U.S.'
WHERE company = 'UpScalio';

-- selecting similar location using wildcard  '%' for 'Bengaluru%'
SELECT *
FROM layoffs_staging3
WHERE location LIKE 'Bengaluru%'
ORDER BY location;

-- Updating 'Bengaluru' with 'Bengaluru,Non-U.S.'
UPDATE layoffs_staging3
SET location = 'Bengaluru,Non-U.S.'
WHERE location = 'Bengaluru';

-- selecting similar location using wildcard  '%' for 'Kuala Lumpur%'
SELECT *
FROM layoffs_staging3
WHERE location LIKE 'Kuala Lumpur%'
ORDER BY location;

-- Updating 'Kuala Lumpur' with 'Kuala Lumpur,Non-U.S.'
UPDATE layoffs_staging3
SET location = 'Kuala Lumpur,Non-U.S.'
WHERE location = 'Kuala Lumpur';

-- selecting similar location using wildcard  '%' for 'London%'
SELECT *
FROM layoffs_staging3
WHERE location LIKE 'London%'
ORDER BY location;

-- Updating 'London' with 'London,Non-U.S.'
UPDATE layoffs_staging3
SET location = 'London,Non-U.S.'
WHERE location = 'London';

SELECT *
FROM layoffs_staging3
WHERE location LIKE 'Luxembourg%'
ORDER BY location;

UPDATE layoffs_staging3
SET location = 'Luxembourg,Non-U.S.'
WHERE location = 'Luxembourg,Raleigh';

SELECT *
FROM layoffs_staging3
WHERE location LIKE 'Montreal%'
ORDER BY location;

UPDATE layoffs_staging3
SET location = 'Montreal,Non-U.S.'
WHERE location = 'Montreal';


SELECT *
FROM layoffs_staging3
WHERE location LIKE 'Mumbai%'
ORDER BY location;

UPDATE layoffs_staging3
SET location = 'Mumbai,Non-U.S.'
WHERE location = 'Mumbai';


SELECT *
FROM layoffs_staging3
WHERE location LIKE 'New Delhi%'
ORDER BY location;

SELECT *
FROM layoffs_staging3
WHERE location LIKE 'Singapore%'
ORDER BY location;

UPDATE layoffs_staging3
SET location = 'Singapore,Non-U.S.'
WHERE location = 'Singapore';

SELECT *
FROM layoffs_staging3
WHERE location LIKE 'Vancouver%'
ORDER BY location;

SELECT *
FROM layoffs_staging3
WHERE company = 'Dapper Labs';

UPDATE layoffs_staging3
SET location = 'Vancouver,Non-U.S.'
WHERE company = 'Dapper Labs';

SELECT *
FROM layoffs_staging3
WHERE location LIKE 'Tel Aviv%'
ORDER BY location;

UPDATE layoffs_staging3
SET location = 'Tel Aviv,Non-U.S.'
WHERE location = 'Tel Aviv';

-- Checking similar county name
SELECT DISTINCT country
FROM layoffs_staging3
ORDER BY country;

-- Here 'UAE' is abrivation of 'United Arab Emirates'
SELECT *
FROM layoffs_staging3
WHERE country LIKE 'UAE' OR country LIKE 'United Arab Emirates'; 

-- Updating 'UAE' with 'United Arab Emirates'
UPDATE layoffs_staging3
SET country = 'United Arab Emirates'
WHERE company = 'DoubleCloud';

-- CHECKING DUPLICATES IN INDUSTRY COLUMN
SELECT DISTINCT industry
FROM layoffs_staging3
ORDER BY industry;

-- CHECKING DUPLICATES IN COMPANY COLUMN
SELECT DISTINCT company
FROM layoffs_staging3
ORDER BY company;

-- 'Ada' having similar names
SELECT *
FROM layoffs_staging3
WHERE company LIKE 'Ada%';

-- Updating company name 'Ada Support' to 'Ada'
UPDATE layoffs_staging3
SET company = 'Ada'
WHERE company = 'Ada Support';
