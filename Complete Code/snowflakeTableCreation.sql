Use bikes;

-- Time Dimension
CREATE TABLE Time_Dim (
    time_id INT AUTO_INCREMENT PRIMARY KEY,
    date datetime, 
    day INT,
    month INT,
    year INT,
    hour INT
);

-- Weather Dimension
CREATE TABLE Weather_Dim (
    weather_id INT AUTO_INCREMENT PRIMARY KEY,
    weather_condition VARCHAR(255), 
    lighting_condition VARCHAR(255),
    roadway_surface_cond VARCHAR(255)
);

CREATE TABLE Demographics_Dim (
    blk_grp_id INT AUTO_INCREMENT PRIMARY KEY, 
    total_population INT,   
    total_housing_units INT, 
    total_households INT,  
    percent_working_age DECIMAL(5,2),   
    households_no_car INT,  
    percent_households_no_car DECIMAL(5,2),  
    households_one_car INT,   
    percent_households_one_car DECIMAL(5,2),   
    households_more_than_one_car INT,   
    percent_households_more_than_one_car DECIMAL(5,2),   
    resident_low_wage_workers INT,  
    resident_medium_wage_workers INT,   
    resident_high_wage_workers INT,   
    percent_resident_low_wage DECIMAL(5,2),  
    total_employment INT,   
    employment_low_wage INT,   
    employment_medium_wage INT,   
    employment_high_wage INT,  
    percent_employment_low_wage DECIMAL(5,2),   
    road_network_density DECIMAL(10,5),  
    distance_to_nearest_transit DECIMAL(10,5),  
    jobs_accessible_by_transit INT,   
    working_age_pop_accessible_by_transit INT,  
    regional_destinations_accessibility_ratio DECIMAL(10,5),   
    walkability_index DECIMAL(10,5) 
);

CREATE TABLE Location_Dim (
    loc_id INT  PRIMARY KEY,
    blk_grp_key INT,
    state INT,
    county INT,
    tract INT,
    blockgrp INT,
    lat FLOAT,
    lng FLOAT, 
	FOREIGN KEY (blk_grp_key) REFERENCES Demographics_Dim (blk_grp_id)
);

-- Road Dimension
CREATE TABLE RoadType_Dim (
    roadtype_id INT AUTO_INCREMENT PRIMARY KEY,
    traffic_control_device VARCHAR(255),
    trafficway_type VARCHAR(255)
);

-- Crash Details Dimension
CREATE TABLE CrashDetails_Dim (
    crashcause_id INT AUTO_INCREMENT PRIMARY KEY,
    crash_type VARCHAR(255),
    hit_and_run_i CHAR(1),
    prim_contributory_cause VARCHAR(255),
    dooring_i CHAR(1), 
    most_severe_injury VARCHAR(255)
);


-- Crash Fact Table
CREATE TABLE Crash_Fact (
    crash_record_id INT  PRIMARY KEY,
    loc_id INT,
    time_id INT,
    weather_id INT,
    roadtype_id INT,
    crashcause_id INT,
	injuries_fatal INT,
    injuries_incapacitating INT,
    injuries_non_incapacitating INT,
    crash_count INT,
    FOREIGN KEY (loc_id) REFERENCES Location_Dim (loc_id),
    FOREIGN KEY (time_id) REFERENCES Time_Dim (time_id),
    FOREIGN KEY (weather_id) REFERENCES Weather_Dim (weather_id),
    FOREIGN KEY (roadtype_id) REFERENCES RoadType_Dim (roadtype_id),
	FOREIGN KEY (crashcause_id) REFERENCES CrashDetails_Dim (crashcause_id)
);

-- Rack Fact Table
CREATE TABLE Rack_Fact (
    rack_id INT AUTO_INCREMENT PRIMARY KEY,
    loc_id INT,
    name VARCHAR(255),
    type VARCHAR(50),
    quantity INT, 
    total_docks INT, 
    divvy_i CHAR(1),
    FOREIGN KEY (loc_id) REFERENCES Location_Dim (loc_id)
);

-- DivvyTrip Fact Table
CREATE TABLE DivvyTrip_Fact (
    ride_id INT AUTO_INCREMENT PRIMARY KEY,
    start_loc_id INT,
    end_loc_id INT,
    start_time_id INT,
    end_time_id INT, 
    ride_count INT,
    FOREIGN KEY (start_loc_id) REFERENCES Location_Dim (loc_id),
    FOREIGN KEY (end_loc_id) REFERENCES Location_Dim (loc_id),
    FOREIGN KEY (start_time_id) REFERENCES Time_Dim (time_id),
    FOREIGN KEY (end_time_id) REFERENCES Time_Dim (time_id)
);



# ------------- INSERT ----------------


-- Time Dim 
INSERT INTO Time_Dim (date, day, month, year, hour)
SELECT DISTINCT 
    date,
    DAY(date) AS day,
    MONTH(date) AS month,
    YEAR(date) AS year,
    HOUR(date) AS hour
FROM 
(
SELECT crash_date as date
FROM crash_staging
UNION
SELECT started_at as date
FROM divvytrip_staging
UNION 
SELECT ended_at as date 
FROM divvytrip_staging
 ) a
;


-- Weather Dim 
INSERT INTO Weather_Dim (weather_condition, lighting_condition,roadway_surface_cond)
SELECT DISTINCT
    weather_condition,
    lighting_condition, 
    roadway_surface_cond
FROM crash_staging;



-- Demographics Dim 
INSERT INTO Demographics_Dim (blk_grp_id, total_population, total_housing_units, total_households, percent_working_age, households_no_car, 
percent_households_no_car, households_one_car, percent_households_one_car, households_more_than_one_car, percent_households_more_than_one_car, 
resident_low_wage_workers, resident_medium_wage_workers, resident_high_wage_workers, percent_resident_low_wage, total_employment, employment_low_wage, 
employment_medium_wage, employment_high_wage, percent_employment_low_wage, road_network_density, distance_to_nearest_transit, jobs_accessible_by_transit, 
working_age_pop_accessible_by_transit, regional_destinations_accessibility_ratio, walkability_index)
SELECT DISTINCT
blk_grp_id, total_population, total_housing_units, total_households, percent_working_age, households_no_car, 
percent_households_no_car, households_one_car, percent_households_one_car, households_more_than_one_car, percent_households_more_than_one_car, 
resident_low_wage_workers, resident_medium_wage_workers, resident_high_wage_workers, percent_resident_low_wage, total_employment, employment_low_wage, 
employment_medium_wage, employment_high_wage, percent_employment_low_wage, road_network_density, distance_to_nearest_transit, jobs_accessible_by_transit, 
working_age_pop_accessible_by_transit, regional_destinations_accessibility_ratio, walkability_index
FROM smartlocation;

-- Location Dim 
INSERT INTO Location_Dim (loc_id, blk_grp_key, state, county, tract, blockgrp, lat, lng)
SELECT DISTINCT
    loc_id, 
    blk_grp_id,
    state,
    county,
    tract,
    blockgrp,
    lat,
    lng
FROM location;


-- RoadType Dim 
INSERT INTO RoadType_Dim (trafficway_type,traffic_control_device)
SELECT DISTINCT
    trafficway_type,
    traffic_control_device
FROM crash_staging;

-- Crash Details Dim
INSERT INTO CrashDetails_Dim (  crash_type ,hit_and_run_i ,prim_contributory_cause ,dooring_i ,most_severe_injury )
SELECT DISTINCT 
    crash_type ,
    hit_and_run_i ,
    prim_contributory_cause ,
    dooring_i ,
    most_severe_injury 
FROM crash_staging;

-- Crash Fact
INSERT INTO Crash_Fact (crash_record_id,loc_id, time_id, weather_id, roadtype_id, crashcause_id, crash_count, injuries_fatal, injuries_incapacitating , injuries_non_incapacitating)
SELECT
    crash.crash_record_id,
    crash.loc_id,
    time.time_id,
    weather.weather_id,
    road.roadtype_id,
    crashdetails.crashcause_id,
    1,
    injuries_fatal, 
    injuries_incapacitating , 
	injuries_non_incapacitating 
FROM crash  
LEFT JOIN Time_Dim time ON crash.crash_date = time.date
LEFT JOIN Weather_Dim weather ON crash.weather_condition = weather.weather_condition AND crash.lighting_condition = weather.lighting_condition AND crash.roadway_surface_cond = weather.roadway_surface_cond
LEFT JOIN RoadType_Dim road ON crash.traffic_control_device = road.traffic_control_device AND  crash.trafficway_type = road.trafficway_type
LEFT JOIN CrashDetails_Dim crashdetails ON crash.crash_type = crashdetails.crash_type AND crash.hit_and_run_i = crashdetails.hit_and_run_i AND 
										crash.prim_contributory_cause = crashdetails.prim_contributory_cause AND crash.dooring_i = crashdetails.dooring_i AND 
                                        crash.most_severe_injury = crashdetails.most_severe_injury  
;

-- Rack Fact 

INSERT INTO Rack_Fact (loc_id, name, type, quantity, total_docks, divvy_i)
SELECT
    loc_id,
    name,
    type,
    quantity, 
    total_docks, 
    divvy_i
FROM 
(SELECT 
latitude as lat, longitude as lng, name, quantity, type, NULL as total_docks ,0 as divvy_i,  loc_id
from rack 
UNION 
SELECT 
latitude as lat, longitude as lng, station_name as name , NULL as quantity, NULL as type,total_docks, 1 as divvy_i, loc_id
from divvystation) combined
;
 
-- Divvy Trip Fact
INSERT INTO DivvyTrip_Fact (start_loc_id, end_loc_id, start_time_id, end_time_id, ride_count)
SELECT
    trip.start_loc_id,
    trip.end_loc_id,  
	start_time.time_id as start_time_id,
    end_time.time_id as end_time_id,  
    1 AS ride_count
FROM divvytrip trip
LEFT JOIN Time_Dim start_time ON trip.started_at = start_time.date
LEFT JOIN Time_Dim end_time ON trip.ended_at = end_time.date
;

