
Select* 
From PortfolioProject..CovidDeaths$
where continent is not null	
order by 3,4
select Location,date, total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths$
order by 1,2

-- Looking at Total Cases vs Total Deaths -- 
--Show chances of dying from Coivd in Your Country-- 

select Location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeaths$
Where location like '%states%'
order by 1,2


--Total cases Vs Population 
--Show population got Covid-- 

select Location,date,population, total_cases, (total_cases/population)*100 As PercentPopulation
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
order by 1,2

-- Looking at countires with Higest Infection rate vs population 

Select Location, Population, Max(total_cases) AS HighestInfectionCount, MAX((total_cases/Population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Group by location,population
order by PercentPopulationInfected desc

-- Showing countries Highest Death count per population-- 
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
where continent is not null
Group by location
order by TotalDeathCount desc

--  -- 

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc


-- Showing Contientes with highest death count vs Population-- 
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global Nubmers 


select date, SUM(new_cases)AS total_cases ,SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
where continent is not null
Group by date
order by 1,2


select  SUM(new_cases)AS total_cases ,SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
where continent is not null
--Group by date
order by 1,2


-- Total population vs vaccination 


Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated--, (Rollingpeoplevaccinated/dea.population)*100
From PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVacination vac
on dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not null
order by 2,3


-- Use CTE

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated) 
as 
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated--, (Rollingpeoplevaccinated/dea.population)*100
From PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVacination vac
on dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/Population)*100
From PopvsVac




 --Temp Table
 Drop Table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric 
)
 Insert into #PercentPopulationVaccinated
 Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated--, (Rollingpeoplevaccinated/dea.population)*100
From PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVacination vac
on dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not null
--order by 2,3

Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--For Visuals-- 
Create View PercentPopulationVaccinated as 
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,dea.date) as Rollingpeoplevaccinated--, (Rollingpeoplevaccinated/dea.population)*100
From PortfolioProject..CovidDeaths$ dea
join PortfolioProject..CovidVacination vac
on dea.location = vac.location 
and dea.date = vac.date 
where dea.continent is not null
--order by 2,3

Select*
From PercentPopulationVaccinated