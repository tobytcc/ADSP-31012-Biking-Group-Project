USE bikes;

CREATE TABLE IF NOT EXISTS smartlocation (
    statefp INT,
    countyfp INT,
    tractce INT,
    blkgrpce INT,
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
    walkability_index DECIMAL(10,5),  
    shape_area DECIMAL(10,3),
    blk_grp_id INT(10) NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(blk_grp_id)
);

-- STAGING TABLES INSERT --

CREATE TABLE IF NOT EXISTS bikes.location_staging (
  geoid BIGINT NOT NULL ,
  state INT(10) NOT NULL ,
  county INT(10) NOT NULL ,
  tract INT(10) NOT NULL ,
  blockgrp INT(10) NOT NULL ,
  lat FLOAT NOT NULL ,
  lng FLOAT NOT NULL ,
  loc_id INT(10) NOT NULL , 
  PRIMARY KEY (loc_id)
);

CREATE TABLE IF NOT EXISTS crash_staging (
    crash_date VARCHAR(50),
    posted_speed_limit INT,
    traffic_control_device VARCHAR(255),
    weather_condition VARCHAR(255),
    lighting_condition VARCHAR(255),
    trafficway_type VARCHAR(255),
    roadway_surface_cond VARCHAR(255),
    crash_type VARCHAR(255),
    hit_and_run_i CHAR(1),
    prim_contributory_cause VARCHAR(255),
    street_no INT,
    street_direction CHAR(1),
    street_name VARCHAR(255),
    dooring_i CHAR(1),
    most_severe_injury VARCHAR(255),
    injuries_fatal INT,
    injuries_incapacitating INT,
    injuries_non_incapacitating INT,
    crash_hour INT,
    crash_day VARCHAR(255),
    crash_month INT,
    latitude FLOAT,
    longitude FLOAT, 
    crash_record_id INT AUTO_INCREMENT, 
    PRIMARY KEY(crash_record_id) 
);

CREATE TABLE IF NOT EXISTS rack_staging (	
    latitude FLOAT,
    longitude FLOAT,
    location VARCHAR(255),
    name VARCHAR(255),
    quantity INT,
    type VARCHAR(50),
    rack_id INT(10) NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(rack_id)
);

CREATE TABLE IF NOT EXISTS divvystation_staging (
    station_id VARCHAR(255),
    station_name VARCHAR(255),
    total_docks INT,
    latitude FLOAT,
    longitude FLOAT, 
    PRIMARY KEY(station_id)
);

CREATE TABLE IF NOT EXISTS divvytrip_staging (
    ride_id VARCHAR(255),
    rideable_type VARCHAR(255),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name VARCHAR(255),
    start_station_id INT,
    end_station_name VARCHAR(255),
    end_station_id INT,
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(6) ,
    PRIMARY KEY(ride_id) 
);


-- FINAL TABLES INSERT --


CREATE TABLE IF NOT EXISTS bikes.location ( 
  state INT(10) NOT NULL ,
  county INT(10) NOT NULL ,
  tract INT(10) NOT NULL ,
  blockgrp INT(10) NOT NULL ,
  lat FLOAT NOT NULL ,
  lng FLOAT NOT NULL ,
  loc_id INT(10) NOT NULL , 
  blk_grp_id INT,
  PRIMARY KEY (loc_id), 
  CONSTRAINT `fk_locations_original_smartlocation` FOREIGN KEY (`blk_grp_id`)
  REFERENCES `bikes`.`smartlocation` (`blk_grp_id`)
  ON DELETE NO ACTION ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS crash (
    crash_date DATETIME,
    posted_speed_limit INT,
    traffic_control_device VARCHAR(255),
    weather_condition VARCHAR(255),
    lighting_condition VARCHAR(255),
    trafficway_type VARCHAR(255),
    roadway_surface_cond VARCHAR(255),
    crash_type VARCHAR(255),
    hit_and_run_i CHAR(1),
    prim_contributory_cause VARCHAR(255),
    street_no INT,
    street_direction CHAR(1),
    street_name VARCHAR(255),
    dooring_i CHAR(1),
    most_severe_injury VARCHAR(255),
    injuries_fatal INT,
    injuries_incapacitating INT,
    injuries_non_incapacitating INT,
    crash_hour INT,
    crash_day VARCHAR(255),
    crash_month INT,
    latitude FLOAT,
    longitude FLOAT, 
    crash_record_id INT AUTO_INCREMENT,
    loc_id INT, 
    PRIMARY KEY(crash_record_id), 
    CONSTRAINT `fk_crash_location` FOREIGN KEY (`loc_id`)
        REFERENCES `bikes`.`location` (`loc_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS rack (	
    latitude FLOAT,
    longitude FLOAT,
    location VARCHAR(255),
    name VARCHAR(255),
    quantity INT,
    type VARCHAR(50),
    rack_id INT(10) NOT NULL AUTO_INCREMENT, 
    loc_id INT,
    PRIMARY KEY(rack_id), 
    CONSTRAINT `fk_rack_location` FOREIGN KEY (`loc_id`)
        REFERENCES `bikes`.`location` (`loc_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS divvystation  (
    station_id VARCHAR(255),
    station_name VARCHAR(255),
    total_docks INT,
    latitude FLOAT,
    longitude FLOAT, 
    loc_id INT,
    PRIMARY KEY(station_id),
    CONSTRAINT `fk_divvystation_location` FOREIGN KEY (`loc_id`)
        REFERENCES `bikes`.`location` (`loc_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS divvytrip (
    ride_id VARCHAR(255),
    rideable_type VARCHAR(255),
    started_at VARCHAR(255),
    ended_at VARCHAR(255),
    start_station_name VARCHAR(255),
    start_station_id INT,
    end_station_name VARCHAR(255),
    end_station_id INT,
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(6),
    start_loc_id INT,
    end_loc_id INT,
    PRIMARY KEY(ride_id),
    CONSTRAINT `fk_divvytrip_location_start` FOREIGN KEY (`start_loc_id`)
        REFERENCES `bikes`.`location` (`loc_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_divvytrip_location_end` FOREIGN KEY (`end_loc_id`)
        REFERENCES `bikes`.`location` (`loc_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);  
  
CREATE INDEX `smartlocation_location_fk` ON `bikes`.`location` (`blk_grp_id` ASC);
CREATE INDEX `location_crash_fk` ON `bikes`.`crash` (`loc_id` ASC);
CREATE INDEX `location_rack_fk` ON `bikes`.`rack` (`loc_id` ASC);
CREATE INDEX `location_divvytrip_fk1` ON `bikes`.`divvytrip` (`start_loc_id` ASC);
CREATE INDEX `location_divvytrip_fk2` ON `bikes`.`divvytrip` (`end_loc_id` ASC);
CREATE INDEX `location_divvystation_fk` ON `bikes`.`divvystation` (`loc_id` ASC);
