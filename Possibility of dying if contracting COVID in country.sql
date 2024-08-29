/*Possibility of dying if contracting covid in country:*/
/*Note that (total_deaths/total_cases)*100 is giving an error [Not possible to divide 0 by 0 or by a number]*/
/*Use instead (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100*/
SELECT location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 AS Death_Percentage
FROM CovidDeaths
WHERE location LIKE '%Kingdom%' AND continent IS NOT NULL
ORDER BY 1, 2