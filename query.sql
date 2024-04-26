CREATE TABLE CONTINENT (
	ID serial Primary key,
	Name varchar(20)	
);

CREATE TABLE COUNTRY (
	ID serial Primary key,
	Name varchar(20),
	Population int,
	Area bigint,
	continent_id int,
	FOREIGN KEY (continent_id) REFERENCES CONTINENT(ID)
);


CREATE TABLE PEOPLE (
	ID serial Primary key,
	Name varchar(20)
);

CREATE TABLE Country_People (
	id serial,
    country_id INT,
    person_id INT,
    FOREIGN KEY (country_id) REFERENCES COUNTRY(ID),
    FOREIGN KEY (person_id) REFERENCES PEOPLE(ID)
);

INSERT INTO CONTINENT (ID, Name) VALUES
		(1, 'Asia'),
		(2, 'Europe'),
		(3, 'North America'),
		(4, 'Africa'),
		(5, 'South America');
		

INSERT INTO COUNTRY (ID, Name, Population, Area, continent_id) VALUES
		(1, 'CHINA', 1439323776, 9706961, 1),
		(2, 'INDIA', 1380004385, 3287263, 1),
		(3, 'UNITED STATES', 331002651, 9833517, 3),
		(4, 'CANADA', 37742154, 9984670, 3),
		(5, 'BRAZIL', 212559417, 8515767, 5),
		(6, 'NIGERIA', 206139589, 923768, 4),
		(7, 'RUSSIA', 145934462, 17098242, 2),
		(8, 'AUSTRALIA', 25499884, 7692024, 3),
		(9, 'FRANCE', 25409884, 7611024, 2),
		(10, 'SOUTH AFRICA', 25498784, 3690241, 4);
		
Drop Table COUNTRY,PEOPLE,CONTINENT,Country_People;

INSERT INTO PEOPLE (ID, Name) VALUES
		(1, 'John'),
		(2, 'Mary'),
		(3, 'David'),
		(4, 'Emma'),
		(5, 'Sophia'),
		(6, 'James'),
		(7, 'Olivia'),
		(8, 'William'),
		(9, 'Ansh'),
		(10,'Ansh');
		

INSERT INTO Country_People (id, country_id, person_id) VALUES
		(1, 5, 5),  
		(2, 6, 6),  
		(3, 5, 7), 
		(4, 7, 8),
		(5, 7, 5),  
		(6, 2, 5),
		(7, 2, 9),
		(8, 2, 10);  

 



--Country with the biggest population (id and name of the country)

SELECT ID,Name from COUNTRY WHERE Population = (SELECT max(Population) from COUNTRY);

--Top 5 countries with the lowest population density (names of the countries)

SELECT Name from COUNTRY Order by (Population/Area) asc limit(5);

--Countries with population density higher than average across all countries

SELECT Name from COUNTRY Where (Population/Area) > (Select avg(Population/Area) from COUNTRY);

--Country with the longest name (if several countries have name of the same length, show all of them)

SELECT ID,Name from COUNTRY Where LENGTH(Name) = (SELECT max(LENGTH(Name)) from Country);

--All countries with name containing letter “F”, sorted in alphabetical order

SELECT Name from COUNTRY WHere Name like '%F%' ORDER BY Name ASC;

--Country which has a population, closest to the average population of all countries

SELECT Name,Population from COUNTRY Order by ABS(Population - (Select Avg(Population) from country)) Asc limit 1;

--Count of countries for each continent

Select Continent.Name , Count(*) as Count from Continent inner join Country On Continent.ID = Country.continent_id Group by Continent.Name;

--Total area for each continent (print continent name and total area), sorted by area from biggest to smallest

SELECT Continent.Name, SUM(Country.Area) AS TotalArea
FROM Continent
INNER JOIN Country ON Continent.ID = Country.continent_id
GROUP BY Continent.Name
ORDER BY TotalArea DESC;

--Average population density per continent

SELECT Continent.Name, SUM(Country.Population)/SUM(Country.Area) AS PopulationDensity
FROM Continent
INNER JOIN Country ON Continent.ID = Country.continent_id
GROUP BY Continent.Name;

--For each continent, find a country with the smallest area (print continent name, country name and area)

Select continent.name as Continent,country.name as Country,country.area from continent inner join country on continent.id = country.continent_id where country.area = (Select MIN(Area)
        FROM 
            Country 
        WHERE 
            country.continent_id = continent.ID);

--Find all continents, which have average country population less than 20 million

SELECT Continent.Id as ContinentId,Avg(Country.Population) as AverageCountryPopulation
from Continent 
inner join Country On Continent.ID = Country.continent_id 
Group by Continent.Id
Having avg(Country.Population)<2000000000;

--Person with the biggest number of citizenships

Select person_id, People.Name, Count(*) as Count from Country_People inner join People on Country_People.person_id = People.ID Group by Country_People.person_id,People.Name Order by Count(*) desc limit 1;

--All people who have no citizenship

Select People.ID,People.name from people left join country_people on people.id = country_people.person_id where country_people.country_id is null;

--Country with the least people in People table

Select country_id, Country.Name, Count(*) as Count from Country_People inner join Country on Country_People.country_id = Country.ID Group by Country_People.country_id,Country.Name Order by Count(*) limit 1;

--Continent with the most people in People table

Select country_id, Country.Name, Count(*) as Count from Country_People inner join Country on Country_People.country_id = Country.ID Group by Country_People.country_id,Country.Name Order by Count(*) desc limit 1;


--Find pairs of people with the same name - print 2 ids and the name

Select * from People as p1 join People as p2 on p1.Name = p2.Name and p1.id != p2.id AND p1.id <= p2.id;
