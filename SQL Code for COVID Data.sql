/*Number of continents*/
/*Use the IS NOT NULL constraint to not select null values; return only values where continent has values*/
SELECT *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;
/*To remove duplicates from query results, use the DISTINCT constraint:*/
SELECT DISTINCT continent
FROM CovidDeaths
WHERE continent IS NOT NULL;





/*Possibility of dying if contracting covid in USA:*/
/*Note that (total_deaths/total_cases)*100 is giving an error [Not possible to divide 0 by 0 or by a number]*/
/*Use instead (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100*/
SELECT location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 AS Death_Percentage
FROM CovidDeaths
WHERE location LIKE '%United States%' AND continent IS NOT NULL
ORDER BY 1, 2





/*Percentage of population infected with COVID in USA*/
/*Divide the total cases reported by the population, and then multiply by 100 */
SELECT location, date, population, total_cases, (total_cases/population)*100 AS Percentage_of_Population_Infected
FROM CovidDeaths
WHERE location LIKE '%UNITED STATES%'
ORDER BY 1, 2





/*Countries with highest COVID infection per population:*/
/*Notice that GROUP BY and ORDER BY are being used together. ORDER BY always comes after GROUP BY*/
/*Remember: Use in following order: WHERE, GROUP BY, HAVING, ORDER BY*/
SELECT location, 
       population, 
	   MAX(total_cases) AS HighestInfectionCount, 
	   MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY location, population
order by location, PercentPopulationInfected DESC





/*Countries with Highest Death per Population from COVID:*/
/*The MAX function returns the largest value of the selected column*/
/*Remember: The CAST() function converts a value (of any type) into a specified datatype*/
/*We will be using the CAST() function to identify more values as total deaths to identify the total death count*/
/*Rather than using MAX(total_deaths), use MAX(cast(total_deaths as int)): */
select location, MAX(cast(total_deaths as int)) as Total_Death_Count
from CovidDeaths
GROUP BY location
ORDER BY Total_Death_Count DESC
/*Can also type EXEC sp_help CovidDeaths to identify data type in each column name, or to count #fields in table */
EXEC sp_help CovidDeaths





/*Continents that have the highest death per population from COVID:*/
SELECT continent, MAX(cast(Total_deaths as int)) as Total_Death_Count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
order by Total_Death_Count DESC





/*Finding the total covid cases, total covid death, and total death percentages from covid in the world (by date and continent):*/
/*Used the CONVERT and NULLIF functions (to convert the datatype in float and to return 0 if a value was null) and finally to ignore the division in Null values */
SELECT date,
	   continent,
	   SUM(CAST(new_cases AS int)) AS total_new_cases, 
	   SUM(CAST(new_deaths AS int)) AS total_new_deaths,
	   SUM(CONVERT(float, new_deaths)/NULLIF(CONVERT(float,new_cases),0))*100 AS total_new_death_percentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date, continent
ORDER BY 1, 2





/*Number of people in the world that has received at least one Covid Vaccine*/
/*Window functions perform calculations on a set of rows that are related together, but unlike the aggregate functions, they do not collapse the result of the rows into a single value*/
/*Window function OVER clause: Defines a window or user-specified set of rows within a query result set. A window function then computes a value for each row in the window.*/
/*Window function PARTITION BY: Divides the query result set into partitions. The window function is applied to each partition separately and computation restarts for each partition.
  If PARTITION BY is not specified, the function treats all rows of the query result as a single partition*/
SELECT cd.continent,
	   cd.location,
	   cd.date,
	   cd.Population, 
	   cv.new_vaccinations,
	   SUM(CONVERT(BIGINT, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingPeopleVaccinated
FROM CovidDeaths AS cd

JOIN CovidVaccinations AS cv
	 ON cd.location = cv.location
	 AND cd.date = cv.date

WHERE cd.continent IS NOT NULL AND cv.new_vaccinations IS NOT NULL
ORDER BY 2, 3





/*Summarizing data for usage in MS Excel and Tableau:*/
SELECT SUM(new_cases) AS total_cases,
SUM(CAST(new_deaths AS INT)) AS total_deaths,
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS death_percentage
FROM CovidDeaths


SELECT location, SUM(CAST(new_deaths AS INT)) AS total_deaths
FROM CovidDeaths
WHERE continent IS NULL AND location NOT IN ('World', 'European Union')
GROUP BY location
ORDER BY total_deaths DESC


SELECT location,
	   Population,
	   MAX(total_cases) AS highest_infection_count,
	   MAX(total_cases/population)*100 AS Percentage_of_Population_Infected
FROM CovidDeaths
GROUP BY location, Population
ORDER BY Percentage_of_Population_Infected DESC


SELECT location,
	   Population,
	   MAX(total_cases) AS highest_infection_count,
	   MAX(total_cases/population)*100 AS Percentage_of_Population_Infected
FROM CovidDeaths
GROUP BY location, Population, date
ORDER BY Percentage_of_Population_Infected DESC