Select *
From PortfolioProject..CovidDeaths
order by 3,4

SELECT *
From PortfolioProject..CovidVaccinations
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2
--Looking at total cases VS Deaths
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location = "United States"
order by 1,2

--Looking at total cases  VS population
-- Shows what oercentage of population got covid
Select Location, date, total_cases, Population, (total_cases/population)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%States%'
order by 1,2

--Countries with the highest infection rate compare to population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like'%States%'
Group by Location, Population
Order by PercentPopulationInfected desc

--Countries with the highest death count per Population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathcount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location
Order by TotalDeathcount desc

--let's break it down to continent
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathcount
From PortfolioProject..CovidDeaths
Where continent is null
Group by Location
Order by TotalDeathcount desc

--showing the continent with the highest death count
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathcount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathcount desc

--GLOBAL NUMBERS
--use for Viz
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Looking at total Population VS Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date)
as RollingPeopleVaccinated
,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null 
Order by 2,3

-- Use CTE

with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
Where dea.continent is not null 
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac




--Queries used for vizualization

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

