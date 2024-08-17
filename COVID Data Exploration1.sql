SELECT *
FROM dbo.CovidDeaths


SELECT *
FROM dbo.CovidVaccinations


/*Number of continents*/
/*Use the IS NOT NULL constraint to not select null values; return only values where continent has values*/
SELECT *
FROM dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;


/*Number of continents*/
/*To remove duplicates from query results, use the DISTINCT constraint:*/
SELECT DISTINCT continent
FROM CovidDeaths
WHERE continent IS NOT NULL;


/*-----------------------------Find the probability of dying if contracting COVID in the USA:*/
SELECT location,
	   date,
	   total_cases,
	   total_deaths,
	   (CONVERT(float, total_deaths)/NULLIF(CONVERT(float, total_cases), 0))*100 AS Death_Percentage
FROM CovidDeaths
WHERE location LIKE '%United States%' AND continent IS NOT NULL
ORDER BY 1, 2



/*Find the percentage of population infected with COVID in the US:*/
SELECT location, date, population, total_cases, (total_cases/population)*100 AS Percentage_of_Population_Infected
FROM CovidDeaths
WHERE location LIKE '%United States%'
ORDER BY 1, 2


/*Finding the countries with highest COVID infectopn per location and population:*/
SELECT location,
	   population,
	   MAX(total_cases) AS HighestInfectionCount,
	   MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY location, Population
ORDER BY location, HighestInfectionCount, PercentPopulationInfected DESC


/*Identifying the data type in each column:*/
EXEC sp_help CovidDeaths



/*To get better results when calculating the maximum value of total deaths:*/
SELECT location, MAX(cast(total_deaths as int)) as Total_Death_Count
FROM CovidDeaths
GROUP BY location
ORDER BY Total_Death_Count DESC

EXEC sp_help CovidDeaths


/*To find out the continents that have the highest death count with no null values:*/
SELECT continent, MAX(cast(total_deaths AS INT)) AS Total_Death_Count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY Total_Death_Count DESC



/*To find the total COVID cases, total deaths and total death percentage by date and continent:*/
 SELECT date,
	    continent,
		SUM(CAST(new_cases AS int)) AS total_new_cases,
		SUM(CAST(new_deaths AS int)) AS total_new_deaths,
		SUM(CONVERT(float, new_deaths)/NULLIF(CONVERT(float, new_cases), 0))*100 AS total_new_death_percentage
 FROM CovidDeaths
 WHERE continent IS NOT NULL
 GROUP BY date, continent
 ORDER BY 1, 2


 /*To find out the increasing number of people in the world that has received at least one Covid Vaccine:*/
SELECT cd.continent,
		cd.location,
		cd.date,
		cd.Population
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