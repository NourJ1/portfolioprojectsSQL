
select *
from CovidDeaths


--select * 
--from CovidVaccinations
--order by 3,4 

select location, date , total_cases , new_cases , total_deaths , population 
from CovidDeaths 
order by 1,2 

--Total cases Vs Total deaths

select location, date , total_cases, total_deaths ,  (total_deaths/total_cases)*100 deathpercentage
from CovidDeaths 
where location like '%Jordan%' 
where continent is not null
order by 1,2 

-- Total case Vs Population

select location, date , total_cases,  population ,  (total_cases/population)*100 PercentOfPopInfected
from CovidDeaths 
where location like '%Jordan%' 
order by 1,2 

-- Countires with highet infection rate 

Select location , Max( total_cases ) as MaxInfected , Max((total_cases/population))*100 as MaxPerOfInfect
from CovidDeaths
Group by  location
order by MaxInfected desc 

-- Countries with the highest death count per population 
Select location , Max(cast(total_deaths as int )) as MaxDeathsCount , Max((total_deaths/population))*100 as MaxPerOfdeaths
from CovidDeaths
where continent is not null 
Group by  location 
order by MaxDeathsCount desc 

--Deaths By Continent 
Select continent , Max(cast(total_deaths as int )) as MaxDeathsCount , Max((total_deaths/population))*100 as MaxPerOfdeaths
from CovidDeaths
where continent is not null 
Group by   continent
order by MaxDeathsCount desc 

-- Global numbers 
select  date , sum(new_cases) as total_cases , sum(cast(total_deaths as int )) as total_deaths   ,  (sum(cast(total_deaths as int ))/sum(new_cases))*100 deathpercentage
from CovidDeaths 
where continent is not null

group by date
order by 1,2 

select   sum(new_cases) as total_cases , sum(cast(total_deaths as int )) as total_deaths   ,  (sum(cast(total_deaths as int ))/sum(new_cases))*100 deathpercentage
from CovidDeaths 
where continent is not null

--group by date
order by 1,2 

--Total population Vs Vaccination  
select dea.continent, dea.location , dea.date, dea.population , vac.new_vaccinations,  
sum(cast(vac.new_vaccinations as int)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVac ,
--(RollingPeopleVac/dea.population)*100
from CovidDeaths dea
Join CovidVaccinations vac on dea.location = vac.location 
and dea.date=vac.date
where dea.continent is not null 
order by 2,3 


--USE CTE 
with PopOfVac (continent, location,date,population, new_vaccinations,RollingPeopleVac)
as (
select dea.continent, dea.location , dea.date, dea.population , vac.new_vaccinations,  
sum(cast(vac.new_vaccinations as int)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVac 
from CovidDeaths dea
Join CovidVaccinations vac on dea.location = vac.location 
and dea.date=vac.date
where dea.continent is not null 
) 

select * , (RollingPeopleVac/population)*100 
from PopOfVac
 
 -- TEMP TABLE 
 DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated (continent nvarchar(255) ,
location nvarchar(255) , 
date datetime ,
population numeric, 
new_vaccionations numeric ,
RollingPeopleVac numeric ) 
INSERT INTO #PercentPopulationVaccinated 

select dea.continent, dea.location , dea.date, dea.population , vac.new_vaccinations,  
sum(cast(vac.new_vaccinations as int)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVac 
from CovidDeaths dea
Join CovidVaccinations vac on dea.location = vac.location 
and dea.date=vac.date
--where dea.continent is not null 


select * , (RollingPeopleVac/population)*100 
from #PercentPopulationVaccinated

-- creating views to use them in visulaization 

create view PercentPopulationVaccinated as 
select dea.continent, dea.location , dea.date, dea.population , vac.new_vaccinations,  
sum(cast(vac.new_vaccinations as int)) over ( partition by dea.location order by dea.location, dea.date) as RollingPeopleVac 
from CovidDeaths dea
Join CovidVaccinations vac on dea.location = vac.location 
and dea.date=vac.date
where dea.continent is not null 

select * from 
 PercentPopulationVaccinated 





