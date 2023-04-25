select * 
from Portpholioproject..CovidDeaths
where continent is not null
order by 3,4

--select * 
--from Portpholioproject..CovidVaccinations
--order by 3,4

--select Data that we are goinging to be using
select location,date,total_cases,new_cases,total_deaths,population 
from Portpholioproject..CovidDeaths
where continent is not null
order by 1,2


-- looking at total cases vs total deaths
--shows likelihood of dying  if you contract covid in your country
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from Portpholioproject..CovidDeaths
where location like '%states%' and continent is not null
order by 1,2


--looking at total cases vs population
--shows wht percentage of people got covid
select location,date,total_cases,total_deaths,population,(total_cases/population)*100 as Percentage_afected
from Portpholioproject..CovidDeaths
where location like '%states%' and continent is not null
order by 1,2


--looking at countries with highest infection rate compared to population
select location,population,max(total_cases) as HighestInfectionCount,max(total_cases/population)*100 as Percentage_ofPopulation_afected
from Portpholioproject..CovidDeaths
where continent is not null
group by location, population

--where location like '%states%'
order by Percentage_ofPopulation_afected desc

--showing countries with highest death count per population
select location,max(cast(total_deaths as int)) as TotalDeathCount
from Portpholioproject..CovidDeaths
where continent is not null
group by location
--where location like '%states%'
order by TotalDeathCount desc

-- LET'S BREAK THINFS DOWN BY CONTINENT 
select location,max(cast(total_deaths as int)) as TotalDeathCount
from Portpholioproject..CovidDeaths
where continent is null
group by location
--where location like '%states%'
order by TotalDeathCount desc


select continent,max(cast(total_deaths as int)) as TotalDeathCount
from Portpholioproject..CovidDeaths
where continent is not null
group by continent
--where location like '%states%'
order by TotalDeathCount desc


--showing the continents with highest death count per population
select continent,max(cast(total_deaths as int)) as TotalDeathCount
from Portpholioproject..CovidDeaths
where continent is not null
group by continent
--where location like '%states%'
order by TotalDeathCount desc



-- GLOBAL NUMBERS
select date,sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from Portpholioproject..CovidDeaths
--where location like '%states%' 
WHERE continent is not null
group by date
order by 1,2

--total count 
select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/ sum(new_cases) *100 as DeathPercentage
from Portpholioproject..CovidDeaths
--where location like '%states%' 
WHERE continent is not null
--group by date
order by 1,2

--looking at total population verces vacination
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location 
,dea.date) as RollingPeopleVaccinated
--, (ollingPeopleVaccinated/population)*100 it will not work as we have createde alice only wht we can do is can create temp table or alice
from Portpholioproject..CovidDeaths dea
join  Portpholioproject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
	where dea.continent is not null
order by 1,2,3



--use cte 
with Popvsvac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location 
,dea.date) as RollingPeopleVaccinated
--ollingPeopleVaccinated/population*100
from Portpholioproject..CovidDeaths dea
join  Portpholioproject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100
from Popvsvac

--temp table
drop table if exists #percentPopulationvaccinate
Create table #percentPopulationvaccinate
(
continent nvarchar(255),
location  nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)
insert into #percentPopulationvaccinate
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location 
,dea.date) as RollingPeopleVaccinated
--ollingPeopleVaccinated/population*100
from Portpholioproject..CovidDeaths dea
join  Portpholioproject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null

select *, (RollingPeopleVaccinated/population)*100
from #percentPopulationvaccinate



--creating view to store data for later visualizations
create view percentPopulationvaccinate as
select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location 
,dea.date) as RollingPeopleVaccinated
--ollingPeopleVaccinated/population*100
from Portpholioproject..CovidDeaths dea
join  Portpholioproject..CovidVaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null

select * 
from percentPopulationvaccinate