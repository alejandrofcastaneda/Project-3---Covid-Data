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