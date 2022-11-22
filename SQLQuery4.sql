select continent,max(cast(total_deaths as int)) as total
from portofol..CovidDeaths
where continent is not  null
group by continent
order by 2 desc

select *
from portofol..CovidDeaths
select *
from portofol..CovidVaccinations



select  sum(cast(new_deaths as int)) as death_per_country, sum(new_cases) as cases_per_country,
sum(cast(new_deaths as int))/sum(new_cases )*100 as percentage_of_deaths
from portofol..CovidDeaths
where continent is not null
group by date
order by 1,2

--GLOBAL NUMBERS
select *
from portofol..CovidDeaths dea
join portofol..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
order by 1,2

--looking at total population vs vaccinations
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(cast(vac.new_vaccinations as int))
over(partition by dea.location order by dea.date) as total_vaccinations
from portofol..CovidDeaths dea
join portofol..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null and vac.new_vaccinations is not null
order by 2,3
--USE CTE

with total_vac(continent, location,population,total_vaccinations)
as(
select dea.continent ,dea.location,dea.population,sum(cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location) as total_vaccinations
from portofol..CovidDeaths dea 
join portofol..CovidVaccinations vac 
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null and new_vaccinations is not null
)
select*, (total_vaccinations/population)*100 as percentage_pop
from total_vac
order by 2


--looking at total population vs vacconation

with total_vac(continent,location,population,new_vaccinations,total_vaccinations)
as(
select vac.continent, vac.location,population,vac.new_vaccinations,sum(cast(new_vaccinations as int))
over (partition by dea.location order by dea.location,dea.date) as total_vacctinations
--(total_vaccinations/population)*100 --as percentage_vaccinated
from portofol..CovidDeaths dea
join portofol..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where vac.continent is not null and vac.new_vaccinations is not null

)
select *,(new_vaccinations/population)*100 as percentage_vaccinated
from total_vac
group by continent,location,population,new_vaccinations,total_vaccinations
order by 2


with people_vac(continent,location,date,population,new_vaccinations,rolling_people_vac)
as(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location ,dea.date) as rolling_people_vac
--(rolling_people_vac/population)*100
from portofol..CovidDeaths dea
join portofol..CovidVaccinations vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null
--order by 2,3
)
select *,(rolling_people_vac/population)*100 as percentage
from people_vac




--temp table
drop table if exists #percentage_pop_vac
create table #percentage_pop_vac
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
rolling_pop_vac numeric
)
insert into #percentage_pop_vac
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location ,dea.date) as rolling_people_vac
--(rolling_people_vac/population)*100
from portofol..CovidDeaths dea
join portofol..CovidVaccinations vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null
order by 2,3
select *,(rolling_pop_vac/population)*100 as centage
from #percentage_pop_vac

select continent,max(cast(total_deaths as int)) as total
from portofol..CovidDeaths
where continent is not null
group by continent
order by total desc

--create view to store data for later visuaisations
d
drop table if exists #percentage_pop_vac
create view percentage_pop_vac as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location ,dea.date) as rolling_people_vac
--(rolling_people_vac/population)*100
from portofol..CovidDeaths dea
join portofol..CovidVaccinations vac
on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null
--order by 2,3








