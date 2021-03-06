drop schema if exists DE2_Eurostat;
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
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
	(Countries ,@Employment_Rate, Child_Age ,Education_Level ,ID)
set 	
Employment_Rate = nullif(@Employment_Rate, ':');

select * from Employment_Rate ;

drop table if exists GreenHouse_Emissions;
CREATE TABLE GreenHouse_Emissions
(Countries varchar(100) NOT NULL,
GH_Emission_PerCap FLOAT,
PRIMARY KEY(Countries));

SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/GreenHouse_Emissions_Tonnes_per_Capita.txt' 
INTO TABLE GreenHouse_Emissions
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
	(Countries, @GH_Emission_PerCap)
set 	
GH_Emission_PerCap = nullif(@GH_Emission_PerCap, ':');

select * from GreenHouse_Emissions;

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
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
	(Countries, @Weekly_Hours ,Sex, ID)
set 	
Weekly_Hours = nullif(@Weekly_Hours, ':');

select * from WeeklyWorkHours;

drop table if exists WorkHours;
CREATE TABLE WorkHours
(Countries varchar(100) NOT NULL,
Weekly_Hours FLOAT,
PRIMARY KEY(Countries));

SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/WorkHours.txt' 
INTO TABLE WorkHours
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
	(Countries, @Weekly_Hours )
set 	
Weekly_Hours = nullif(@Weekly_Hours, ':');

select * from Workhours;

drop table if exists Satisfaction_Scores;
CREATE TABLE Satisfaction_Scores
(Countries varchar(200) NOT NULL,
Satisfaction_Scores FLOAT,
PRIMARY KEY(Countries));

SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Satisfaction_Scores.txt' 
INTO TABLE Satisfaction_Scores
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
	(Countries, @Satisfaction_Scores)
set 	
Satisfaction_Scores = nullif(@Satisfaction_Scores, ':');

select * from Satisfaction_Scores ;

drop table if exists LifeExpectancy;
CREATE TABLE LifeExpectancy
(Countries varchar(100) NOT NULL,
LifeExpectancy FLOAT,
PRIMARY KEY(Countries));

SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/LifeExp.txt' 
INTO TABLE LifeExpectancy
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
	(Countries, @LifeExpectancy)
set 	
LifeExpectancy= nullif(@LifeExpectancy, '');

select * from LifeExpectancy;

drop table if exists CountryCodes;
CREATE TABLE CountryCodes
(CountryCodes varchar(100) not null,
Countries varchar(100) NOT NULL,
PRIMARY KEY(CountryCodes));

SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/countrycodes.txt' 
INTO TABLE CountryCodes
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
	(Countrycodes, Countries);
    
select * from countrycodes;
    
-- Formalize Datatable -> 1 row / Country
drop view if exists Denormalized_Dataset;
create view Denormalized_Dataset as
select Countrycodes, w1.Countries, Gh_Emission_PerCap, satisfaction_scores
		, LifeExpectancy as Nation_LifeExp
        , w.Weekly_Hours as WkHrs_All
		, w1.Weekly_hours as Female_WkHrs
		, Male_WorkHours as	Male_WkHrs
		, Emp_Rate_All
		, Emp_Rate_PrimarySchool 	as Emp_Rate_PSch
        , Emp_rate_Highschool 		as Emp_Rate_HSch
        , Emp_rate_University		as Emp_Rate_Uni
    from weeklyworkhours w1	
left join (select Countries, Weekly_hours as Male_WorkHours from weeklyworkhours w1 where sex = 'Male') 
								f on f.Countries = w1.Countries
left join 		Countrycodes 	c on c.Countries = w1.Countries 
left join 		Lifeexpectancy 	l on l.Countries = w1.Countries 
left join (Select f.Countries
,f.employment_rate as Emp_Rate_PrimarySchool
,  Emp_Rate_HighSchool,  Emp_Rate_University, Emp_Rate_All
	from employment_rate f
left join (
	Select countries, employment_rate as Emp_Rate_HighSchool
    from employment_rate
	where education_level = '3-4'
) f1 on f1.Countries = f.Countries
left join (
	Select countries, employment_rate as Emp_Rate_University
    from employment_rate
	where education_level = '5-8'
) f2 on f2.Countries = f.Countries
left join (
	Select countries, employment_rate as Emp_Rate_All
    from employment_rate
	where education_level = 'All'
) f3 on f3.Countries = f.Countries
	where education_level = '0-2') 
								e on e.countries = w1.countries
left join greenhouse_emissions 	g on g.Countries = w1.Countries
left join 			workhours 	w on w.Countries = w1.Countries
left join satisfaction_scores 	s on s.countries = w1.countries
	where sex = 'Female' ;
        
select * from Denormalized_Dataset ;        

-- 1) Main Table -> 2 Load in KNIME
drop view if exists Main_Table;
create view Main_Table as 
select substring(Countrycodes, 2,(length(Countrycodes)-2)) as Countrycodes, substring(countries, 2,(length(countries)-2)) as Countries
 	, Gh_Emission_percap 	as GreenHouse_Em_percap
    , satisfaction_scores	as Avg_Satisfaction
    , Nation_lifeExp 		as LifeExpectancy
    , WkHrs_all				as Weekly_AvgWkHrs
    , Emp_Rate_All			as Employment_Rate
from Denormalized_Dataset;
 
select * from Main_Table ;

-- 2) Workhours by Gender
drop view if exists Avg_WkHrs_by_Gender;
create view Avg_WkHrs_by_Gender as 
select Countries, WkHrs_all, Female_WkHrs, Male_WkHrs
from Denormalized_Dataset;

select * from Avg_WkHrs_by_Gender ;

-- 3) Employment rate by Education Level
drop view if exists EmploymentRate_by_Education;
create view EmploymentRate_by_Education as
select Countries
	, Emp_Rate_All
	, Emp_Rate_PSch
    , Emp_Rate_HSch
    , Emp_Rate_Uni
from Denormalized_Dataset;

select * from EmploymentRate_by_Education;
