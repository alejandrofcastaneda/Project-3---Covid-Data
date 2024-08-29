/*Continents that have the highest death per population from COVID:*/
SELECT continent, MAX(cast(Total_deaths as int)) as Total_Death_Count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
order by Total_Death_Count DESC

EXEC sp_help CovidDeaths