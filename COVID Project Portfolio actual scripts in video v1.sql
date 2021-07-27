-- First I am bringing CovidDeaths and CovidVaccinations tables into my ProjectPortfolio database by Covid 19 Data Exploration 
-- Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
select *
 From ProjectPortfolioCovid19..CovidDeaths
 where continent is not null
  order by 3,4
  
select *
 From ProjectPortfolioCovid19..CovidVaccinations
 where continent is not null
 order by 3, 4 

 -- Now I am looking for location, date, total_cases, new_cases, total_deaths, and population from CovidDeaths table
 Select Location, date, total_cases, new_cases, total_deaths, population 
	From ProjectPortfolioCovid19..CovidDeaths
	where continent is not null
	order by 1,2 

 -- Now again I am looking for location, date, people_fully vaccinated, total_vaccinations from CovidVaccinations table
 Select Location, date, people_fully_vaccinated, total_vaccinations
	From ProjectPortfolioCovid19..CovidVaccinations
	where continent is not null
	order by 1,2

-- Now I am looking for Total cases versus Total Deaths by countries 
--This shows the likelihood of dying if get infected with COVID-19
Select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
	From ProjectPortfolioCovid19..CovidDeaths
	where location like '%'
	order by 1,2 

--- for example lets see using 'state' gives of the US 
Select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
	From ProjectPortfolioCovid19..CovidDeaths
	where location like '%state%'
	order by 1,2

-- Now I am interested in looking for New Zealand 
Select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
	From ProjectPortfolioCovid19..CovidDeaths
	where location like '%New Zealand%'
	order by 1,2
-- Now I look for Nepal 
Select Location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
	From ProjectPortfolioCovid19..CovidDeaths
	where location like '%Nepal%'
	order by 1,2

	-- Now looking Total Cases over Population
	--This shows what portion or percentage of people got Infected by COVID
Select Location, date, population, total_cases, (total_cases/population)* 100 as InfectedPopulation
	From ProjectPortfolioCovid19..CovidDeaths
	---where location like '%state%'
	order by 1,2

 -- Now I am interested in looking for New Zealand
 Select Location, date, population, total_cases, (total_cases/population)* 100 as InfectedPopulation
	From ProjectPortfolioCovid19..CovidDeaths
	where location like '%New Zealand%'
	order by 1,2

-- Now I look for Nepal 
Select Location, date, population, total_cases, (total_cases/population)* 100 as InfectedPopulation
	From ProjectPortfolioCovid19..CovidDeaths
	where location like '%Nepal%'
	order by 1,2

-- I am looking at Countries with the Highest Infection Rate compared to population

Select Location, Population, Max(total_cases) as HighestInfectionRate, Max((total_cases/population))*100 as PercentPopulationInfected
	From ProjectPortfolioCovid19..CovidDeaths
-- where location like '%states%'
where continent is not null
Group by Location, population
order by PercentPopulationInfected desc 

-- I am looking for highsest death count per population
-- I have to cast total_deaths into integer becasue it is in varchar
Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From ProjectPortfolioCovid19..CovidDeaths
-- where location like '%states%'
where continent is not null
Group by Location
order by TotalDeathCount desc 

-- Now I am breaking by Continent 
Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From ProjectPortfolioCovid19..CovidDeaths
-- where location like '%states%'
where continent is null
Group by Location
order by TotalDeathCount desc 


-- Now showing continents with the highest continent with highest death count per population
Select continent, Max(cast(total_deaths as int)) as TotalDeathCount
	From ProjectPortfolioCovid19..CovidDeaths
	--where location like '%states%'
	where continent is not null
	Group by continent
	order by TotalDeathCount desc

-- Lest look for Global Numbers
-- Here SUM (new_cases) calculates total cases and SUM(new_deaths) calculates total deaths in the selected date

Select date, SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
	From ProjectPortfolioCovid19..CovidDeaths
	--where location like '%states%'
	where continent is not null
	Group by date
	order by 1,2 

-- if we remove date it gives total death percentage 
Select SUM(new_cases)as total_cases,SUM(cast(new_deaths as int))as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)* 100 as DeathPercentage
	From ProjectPortfolioCovid19..CovidDeaths
	--where location like '%states%'
	where continent is not null
--Group by date
	order by 1,2 
-- this above schema will shows death percentage across the world i.e, 2.15% 

-- Now I am looking table of CovidVaccinations and CovidDeaths and Joining them together
-- and looking at total population vs vaccinations per day 
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
	From ProjectPortfolioCovid19..CovidDeaths dea
	Join ProjectPortfolioCovid19..CovidVaccinations vac
		on dea.location = vac.location
		and dea.date = vac.date
	where dea.continent is not null
	order by 2,3 
-- now I can partition vac.new_vaccinations (RollingPeopeVaccinated by location  and order by location and date -- 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
-- here we can use Cast or (Convert(int, vac.new_vaccinations)) both does same thing-- 
	From ProjectPortfolioCovid19..CovidDeaths dea
	Join ProjectPortfolioCovid19..CovidVaccinations vac
		on dea.location = vac.location
		and dea.date = vac.date
	where dea.continent is not null
	order by 2,3 

-- Now we can also calculate how many portion of population got vaccinated 
-- Using CTE
-- number of columns in CTE and after Select should be same and equal
with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
-- here we can use Cast or (Convert(int, vac.new_vaccinations)) both does same thing-- 
 -- RollingPeopleVaccinated/population)*100
 --we cannot use colums just created so have to create new temp table thats why I use CTE above  
From ProjectPortfolioCovid19..CovidDeaths dea
Join ProjectPortfolioCovid19..CovidVaccinations vac
		on dea.location = vac.location
		and dea.date = vac.date
	where dea.continent is not null
	-- order by 2,3 we cannot order by 
)
Select*,(RollingPeopleVaccinated/Population)*100 as PopvsVac
	From PopvsVac

-- We can use Temp table 
-- We can do same as above Creating A temp Table
-- I created new table named as PercentPopulationVaccinated-- 
-- and if we do not need the temp table we can drop using (DROP Table if exists) schema--

Drop Table if exists #PercentPopulationVaccinated
--I dropped Table #PercentPopulationVaccinated-- 

Create Table #PercentPopulationVaccinated
-- I created Temp table using above schema-- 
(
Continent nvarchar(255),
Location  nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)

INSERT INTO #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
-- here we can use Cast or (Convert(int, vac.new_vaccinations)) both does same thing-- 
 -- RollingPeopleVaccinated/population)*100
 --we cannot use colums just created so have to create new temp table thats why I use CTE above  
From ProjectPortfolioCovid19..CovidDeaths dea
Join ProjectPortfolioCovid19..CovidVaccinations vac
		on dea.location = vac.location
		and dea.date = vac.date
	where dea.continent is not null
	-- order by 2,3
Select*,(RollingPeopleVaccinated/Population)*100 as PopvsVac
	From #PercentPopulationVaccinated

-- Now Creating a view to store data for future visualzations--

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
-- here we can use Cast or (Convert(int, vac.new_vaccinations)) both does same thing-- 
 -- RollingPeopleVaccinated/population)*100
 --we cannot use colums just created so have to create new temp table thats why I use CTE above  
From ProjectPortfolioCovid19..CovidDeaths dea
Join ProjectPortfolioCovid19..CovidVaccinations vac
		on dea.location = vac.location
		and dea.date = vac.date
	where dea.continent is not null
	-- order by 2,3

Select *
From PercentPopulationVaccinated
