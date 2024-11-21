
Select *
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is not null
Order by 3,4

--Select *
--From [Portfolio Project ].dbo.[Covid-Vaccination]
--Order by 3,4

Select Location,Date,total_cases,new_cases,total_deaths,population
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is not null
Order by 1,2

--Looking at Total Cases Vs Population

Select Location,Date,total_cases,population, (total_cases/population)*100 As PercentageCases
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is not null
Order by 1,2

--This Shows the Percentage of the population that has Covid-19 in Nigeria

Select Location,Date,total_cases,population, (total_cases/population)*100 As PercentageCases
From [Portfolio Project ].dbo.[Covid-Deaths]
Where Location Like 'Nigeria'
Order by 1,2 DESC

--Looking at Total Cases Vs Total Death

Select Location,Date,total_cases,total_deaths,population, (total_deaths/total_cases)*100 As PercentageDeath
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is not null
order by 1,2

--This shows the likelihood of dying if you contract Covid in Nigeria 

Select Location,Date,total_cases,total_deaths,population, (total_deaths/total_cases)*100 As PercentageDeath
From [Portfolio Project ].dbo.[Covid-Deaths]
Where Location like 'Nigeria'
order by 1,2 DESC

--Showing at Countries with Highest Infection Rate compared to Population

Select Location,population,MAX(total_cases) As HighInfectionRate, MAX((total_cases/population))*100 As PercentPopulationInfected
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is not null
Group by Location, population
order by PercentPopulationInfected DESC

--Showing Countries with the Highest Death Count per Population

Select Location,population,MAX(total_deaths) As HighDeathCount, MAX((total_deaths/population))*100 As PercentDeathCount
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is not null
Group by Location, population
order by PercentDeathCount DESC


Select Location,population,MAX(cast(total_deaths as int)) As HighDeathCount, MAX((total_deaths/population))*100 As PercentDeathCount
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is not null
Group by Location, population
order by PercentDeathCount DESC

--Showing Result Based on Continent 
--Continent with the Highest Deathcount

Select continent,MAX(cast(total_deaths as int)) As HighDeathCount
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is not null
Group by continent
order by HighDeathCount DESC

Select Location,MAX(cast(total_deaths as int)) As HighDeathCount
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is null
Group by location
order by HighDeathCount DESC

--Showing Result Based on Global

Select Date, SUM(new_cases), SUM(cast(new_deaths as int))
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is not null
Group by Date
order by 1,2

--Showing Global Death Percentage

--BY DATE

Select Date, SUM(new_cases) As TOTALCASES, SUM(cast(new_deaths as int)) As TOTALDEATH, 
	SUM(cast(new_deaths as int))/SUM(new_cases) * 100 As PercentageDeath
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is not null
Group by Date
order by 1,2

Select Date, SUM(new_cases) As TOTALCASES, SUM(cast(new_deaths as int)) As TOTALDEATH, 
	SUM(cast(new_deaths as int))/SUM(new_cases) * 100 As PercentageDeath
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is not null
Group by Date
order by PercentageDeath DESC

--Total Across the world

Select SUM(new_cases) As TOTALCASES, SUM(cast(new_deaths as int)) As TOTALDEATH, 
	SUM(cast(new_deaths as int))/SUM(new_cases) * 100 As PercentageDeath
From [Portfolio Project ].dbo.[Covid-Deaths]
Where continent is not null
order by PercentageDeath DESC


Select *
From [Portfolio Project ]..[Covid-Vaccination]
Where continent is not null

Select *
From [Portfolio Project ]..[Covid-Deaths] Dea
Join [Portfolio Project ]..[Covid-Vaccination] Vac
	On Dea.Location= Vac.Location
	And Dea.date = Vac.date
	Where Dea.continent is not null

	
	--Showing Total Population by Location Vs Vaccination.

Select Dea.continent, Dea.Location,Dea.Date,Dea.Population, Vac.new_vaccinations
From [Portfolio Project ]..[Covid-Deaths] Dea
Join [Portfolio Project ]..[Covid-Vaccination] Vac
	On Dea.Location= Vac.Location
	And Dea.date = Vac.date
	Where Dea.continent is not null
	Order by 1,2,3

	--Showing Total Population by Location Vs Vaccination and Cumulative Vaccination

Select Dea.continent, Dea.Location,Dea.Date,Dea.Population, Vac.new_vaccinations,
SUM(Cast(Vac.new_vaccinations as float)) OVER (Partition by Dea.Location 
order by Dea.location, Dea.Date) As CumulativePOPVac
From [Portfolio Project ]..[Covid-Deaths] Dea
Join [Portfolio Project ]..[Covid-Vaccination] Vac
	On Dea.Location= Vac.Location
	And Dea.date = Vac.date
	Where Dea.continent is not null
	Order by 2,3

	--Showing Total Population by Specific Location Vs Vaccination and Cumulative Vaccination

Select Dea.continent, Dea.Location,Dea.Date,Dea.Population, Vac.new_vaccinations,
SUM(CONVERT(int, Vac.new_vaccinations)) OVER (Partition by Dea.Location 
order by Dea.location, Dea.Date) As CumulativePOPVac
From [Portfolio Project ]..[Covid-Deaths] Dea
Join [Portfolio Project ]..[Covid-Vaccination] Vac
	On Dea.Location= Vac.Location
	And Dea.date = Vac.date
	Where Dea.continent is not null
	And Dea.continent like 'Africa' 
	and Dea.location like 'Nigeria'
	Order by 2,3

--Showing Total Population by Vaccination.

With PopvsVac (continent,Location,Date,Population,new_vaccinations, CumulativePopVac)
as
(
Select Dea.continent, Dea.Location,Dea.Date,Dea.Population, Vac.new_vaccinations,
SUM(CONVERT(float, Vac.new_vaccinations)) OVER (Partition by Dea.Location 
order by Dea.location, Dea.Date) As CumulativePOPVac
From [Portfolio Project ]..[Covid-Deaths] Dea
Join [Portfolio Project ]..[Covid-Vaccination] Vac
	On Dea.Location= Vac.Location
	And Dea.date = Vac.date
	Where Dea.continent is not null

	)
Select *, (CumulativePOPVac/Population) * 100 As PercentagePopVac
From PopvsVac


--Showing Total %Population by Vaccination for Specific Location

With SpecPopvsVac (continent,Location,Date,Population,new_vaccinations, CumulativePopVac)
as
(
Select Dea.continent, Dea.Location,Dea.Date,Dea.Population, Vac.new_vaccinations,
SUM(CONVERT(float, Vac.new_vaccinations)) OVER (Partition by Dea.Location 
order by Dea.location, Dea.Date) As CumulativePOPVac
From [Portfolio Project ]..[Covid-Deaths] Dea
Join [Portfolio Project ]..[Covid-Vaccination] Vac
	On Dea.Location= Vac.Location
	And Dea.date = Vac.date
	Where Dea.continent is not null
	)
Select *, (CumulativePOPVac/Population) * 100 As PercentagePopVac
From SpecPopvsVac
Where Location like 'Nigeria'

--Creating Views

Create View PopulationVaccinated as
Select Dea.continent, Dea.Location,Dea.Date,Dea.Population, Vac.new_vaccinations,
SUM(Cast(Vac.new_vaccinations as float)) OVER (Partition by Dea.Location 
order by Dea.location, Dea.Date) As CumulativePOPVac
From [Portfolio Project ]..[Covid-Deaths] Dea
Join [Portfolio Project ]..[Covid-Vaccination] Vac
	On Dea.Location= Vac.Location
	And Dea.date = Vac.date
	Where Dea.continent is not null

Select *
From PopulationVaccinated

