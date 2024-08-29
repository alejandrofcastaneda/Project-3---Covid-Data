/*Number of people in the world that has received at least one Covid Vaccine*/
/*Joining CovidDeaths and CovidVaccinations by location and date (since I want to see in my final result)*/
/*Sum set of new vaccination values (Null values are ignored)*/
/*BIGINT is SQL Server's largest integer data type*/

/*Window functions perform calculations on a set of rows that are related together, but unlike the aggregate functions, they do not collapse the result of the rows into a single value*/
/*Window function OVER clause: Defines a window or user-specified set of rows within a query result set. A window function then computes a value for each row in the window.*/
/*Window function PARTITION BY: Divides the query result set into partitions. The window function is applied to each partition separately and computation restarts for each partition.
  If PARTITION BY is not specified, the function treats all rows of the query result as a single partition*/

/*Summary: Observe that the Rolling People Vaccinated increases as the date goes by, if there are more new vaccinations in a specific country*/
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