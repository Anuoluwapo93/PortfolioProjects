select *
from  [portfolio project].[dbo].[CovidDeaths$]
where continent is not null
order by 3,4

--select *
--from [portfolio project].[dbo].[CovidVaccinations$]
--order by 3,4

--select data i am goind to be using

select location, date, total_cases, new_cases, total_deaths, population 
from [portfolio project].[dbo].[CovidDeaths$]
order by 1,2

--looking at total cases  vs total deaths
--showing the likelyhood of dying fron covid


select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [portfolio project].[dbo].[CovidDeaths$]
where location like '%Nigeria%'
order by 1,2

--looking at total cases vs population 
-- shows what percentage of population got covid

select location, date, population, total_cases, (total_cases/population)*100 as DeathPercentage
from[portfolio project].[dbo].[CovidDeaths$]
--where location like '%Nigeria%'
order by 1,2


-- looking at countries with highest infection rate compared to population

select location, population, max (total_cases)as HighestInfectionCount, max (total_cases/population)*100 as 
PercentagePopulationInfected
from [portfolio project].[dbo].[CovidDeaths$]
--where location like'%Nigeria%'
group by location, population
order by PercentagePopulationInfected desc

-- highest death count to population per countries

select location, max(cast (total_cases as int))as TotalDeathCount
from [portfolio project].[dbo].[CovidDeaths$]
--where location like'%Nigeria%'
group by location 
order by  TotalDeathCount desc

--by continents

select continent, max(cast (total_cases as int))as TotalDeathCount
from [portfolio project].[dbo].[CovidDeaths$]
--where location like'%Nigeria%'
where continent is not null
group by continent
order by  TotalDeathCount desc

--continent with the highest death count

select continent, max(cast (total_cases as int))as TotalDeathCount
from [portfolio project].[dbo].[CovidDeaths$]
--where location like'%Nigeria%'
where continent is not null
group by continent
order by  TotalDeathCount desc


--world numbers

select  sum(new_cases) as total_cases, sum (cast(new_deaths as int)) as total_deaths, sum(cast
(new_deaths as int))/sum (new_cases)*100 as DeathPercentage
from [portfolio project].[dbo].[CovidDeaths$]
--where location like '%Nigeria%'
where continent is not null
--group by date 
order by 1,2


--total population vs total vaccinations

select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
sum (cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as
PeopleVaccinated
from[portfolio project].[dbo].[CovidDeaths$] dea
join 
[portfolio project].[dbo].[CovidVaccinations$] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2,3


  --temp table
  drop table if exists  #PercentagePopulationVaccinated
  create table #PercentagePopulationVaccinated
  (
  continent nvarchar(255),
  location nvarchar(255),
  date datetime,
  population numeric,
  new_vaccinations numeric,
  PeopleVaccinated numeric
  )

  insert into #PercentagePopulationVaccinated
  
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
sum (cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as
PeopleVaccinated
from[portfolio project].[dbo].[CovidDeaths$] dea
join 
[portfolio project].[dbo].[CovidVaccinations$] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3

 select *, (PeopleVaccinated/population)*100
 from  #PercentagePopulationVaccinated





--creating view to store data visulisation 

create view PercentagePopulationVaccinated as
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
sum (cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as
PeopleVaccinated
from[portfolio project].[dbo].[CovidDeaths$] dea
join 
[portfolio project].[dbo].[CovidVaccinations$] vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 --order by 2,3

 select *
 from  PercentagePopulationVaccinated