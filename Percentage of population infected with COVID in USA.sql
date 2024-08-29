/*Percentage of population infected with COVID in USA*/
/*Divide the total cases reported by the population, and then multiply by 100 */
SELECT location, date, population, total_cases, (total_cases/population)*100 AS Percentage_of_Population_Infected
FROM CovidDeaths
WHERE location LIKE '%UNITED STATES%'
ORDER BY 1, 2