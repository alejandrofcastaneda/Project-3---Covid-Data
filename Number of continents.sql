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