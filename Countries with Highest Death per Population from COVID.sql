/*Countries with Highest Death per Population from COVID:*/
/*The MAX function returns the largest value of the selected column*/
/*Remember: The CAST() function converts a value (of any type) into a specified datatype*/
/*We will be using the CAST() function to identify more values as total deaths to identify the total death count*/
/*Rather than using MAX(total_deaths), use MAX(cast(total_deaths as int)): */
/*Can also type EXEC sp_help CovidDeaths to identify data type in each column name, or to count #fields in table */
/*In the end you can see that the US has the highest death count (starting in column 10), followed by Brazil, and India*/
select location, MAX(cast(total_deaths as int)) as Total_Death_Count
from CovidDeaths
GROUP BY location
ORDER BY Total_Death_Count DESC

EXEC sp_help CovidDeaths