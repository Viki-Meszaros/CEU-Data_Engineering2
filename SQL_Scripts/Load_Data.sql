create schema DE2_Eurostat;
use DE2_Eurostat;

drop table if exists Employment_Rate;
CREATE TABLE Employment_Rate
(Countries varchar(100) NOT NULL,
Employment_Rate FLOAT,
Child_Age varchar(24),
Education_Level varchar(24),
ID varchar(100) Not Null,
PRIMARY KEY(ID));

SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/EmpRate_by_EduLevel_w_Childrenunder6yrs.txt' 
INTO TABLE Employment_Rate
FIELDS TERMINATED BY '	' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
	(Countries ,@Employment_Rate, Child_Age ,Education_Level ,ID)
set 	
Employment_Rate = nullif(@Employment_Rate, ':');



drop table if exists GreenHouse_Emissions;
CREATE TABLE GreenHouse_Emissions
(Countries varchar(100) NOT NULL,
GH_Emission_PerCap FLOAT,
PRIMARY KEY(Countries));

SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/GreenHouse_Emissions_Tonnes_per_Capita.txt' 
INTO TABLE GreenHouse_Emissions
FIELDS TERMINATED BY '	' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
	(Countries, @GH_Emission_PerCap)
set 	
GH_Emission_PerCap = nullif(@GH_Emission_PerCap, ':');

drop table if exists WeeklyWorkHours;
CREATE TABLE WeeklyWorkHours
(Countries varchar(100) NOT NULL,
Weekly_Hours FLOAT,
Sex Varchar(20),
ID Varchar(100),
PRIMARY KEY(ID));

SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/WeeklyHoursWorked_by_Sex.txt' 
INTO TABLE WeeklyWorkHours
FIELDS TERMINATED BY '	' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
	(Countries, @Weekly_Hours ,Sex, ID)
set 	
Weekly_Hours = nullif(@Weekly_Hours, ':');



drop table if exists LifeExpectancy;
CREATE TABLE LifeExpectancy
(Countries varchar(100) NOT NULL,
LifeExpectancy FLOAT,
PRIMARY KEY(Countries));

SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/LifeExp.txt' 
INTO TABLE LifeExpectancy
FIELDS TERMINATED BY '	' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
	(Countries, @LifeExpectancy)
set 	
LifeExpectancy= nullif(@LifeExpectancy, ':');

drop table if exists CountryCodes;
CREATE TABLE CountryCodes
(CountryCodes varchar(10) not null,
Countries varchar(100) NOT NULL,
PRIMARY KEY(CountryCodes));

SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/countrycodes.txt' 
INTO TABLE CountryCodes
FIELDS TERMINATED BY '	' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
	(Countrycodes, Countries);





-- select * from Countrycodes;

drop view if exists Denormalized_Dataset;
create view Denormalized_Dataset as
with AvgWorkHours as (
select CountryCodes, w.Countries, Weekly_Hours, Sex 
from weeklyworkhours w
left join CountryCodes c on w.Countries = c.Countries) 
Select w.CountryCodes, Weekly_Hours, Sex, LifeExpectancy, GH_Emission_percap, Employment_Rate, Child_Age, Education_level  
from AvgWorkHours w
left join Lifeexpectancy l on w.Countries = l.Countries
left join greenhouse_emissions g on w.Countries = g.Countries
left join employment_rate e on w.Countries = e.Countries;


drop view if exists Education;
Create view Education as
select distinct(Education_level) from Denormalized_Dataset; 

drop view if exists Gender;
Create view Gender as
select distinct(sex) from Denormalized_Dataset;
 
drop view if exists Countries;
Create view Countries as
select * from Countrycodes; 
 

