Select *
From SimpleProject..CovidDeaths
Where continent is not null
order by 3,4

---Select *
---From SimpleProject..CovidVaccinations
---order by 3,4

Select Location, date, total_cases, new_cases, population
From SimpleProject..CovidDeaths
order by 1,2

---cases vs deaths
Select location, date, total_cases, new_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
From SimpleProject..CovidDeaths
Where location like '%States%'
Order by 1,2

--- percentage of people who got covi
Select location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected
From SimpleProject..CovidDeaths
Where location like '%states%'
order by 1,2

---countries with highest infection rate wrt population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From SimpleProject..CovidDeaths
Group by location, population
order by PercentagePopulationInfected desc

---countries with highest death count per population
Select location,  MAX(cast(Total_deaths as int)) as TotalDeathCount
From SimpleProject..CovidDeaths
Where continent is not null
Group by location
order by TotalDeathCount desc

---continent with highest death count
Select continent,  MAX(cast(Total_deaths as int)) as TotalDeathCount
From SimpleProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

---global numbers
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From SimpleProject..CovidDeaths
where continent is not null
Group by date
order by 1,2

---join tables
---total population vs vaccination

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From SimpleProject..CovidDeaths dea
Join SimpleProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
---order by 2,3
)
Select *
From PopvsVac


---Temp table
Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From SimpleProject..CovidDeaths dea
Join SimpleProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
---where dea.continent is not null
---order by 2,3
Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


---View, data storage for visualisation

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From SimpleProject..CovidDeaths dea
Join SimpleProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
