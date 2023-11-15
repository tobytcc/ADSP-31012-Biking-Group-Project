CREATE TABLE IF NOT EXISTS crashdata_original (,
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
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6), 
    crash_record_id INT AUTO_INCREMENT,
    loc_id INT, 
    PRIMARY KEY(crash_record_id), 
    CONSTRAINT `fk_crashdata_original_locations_original` FOREIGN KEY (`loc_id`)
        REFERENCES `bikes`.`locations_original` (`loc_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS bikeracks_original (	
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    location VARCHAR(255),
    name VARCHAR(255),
    quantity INT,
    type VARCHAR(50),
    rack_id INT(10) NOT NULL AUTO_INCREMENT, 
    loc_id INT,
    PRIMARY KEY(rack_id), 
    CONSTRAINT `fk_bikeracks_original_locations_original` FOREIGN KEY (`loc_id`)
        REFERENCES `bikes`.`locations_original` (`loc_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS divvystations_original (
    station_id INT,
    station_name VARCHAR(255),
    address VARCHAR(255),
    total_docks INT,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6), 
    loc_id INT,
    PRIMARY KEY(station_id),
    CONSTRAINT `fk_divvystations_original_locations_original` FOREIGN KEY (`loc_id`)
        REFERENCES `bikes`.`locations_original` (`loc_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS divvytrips_original (
    ride_id VARCHAR(255),
    rideable_type VARCHAR(255),
    started_at DATETIME,
    ended_at DATETIME,
    start_station_name VARCHAR(255),
    start_station_id INT,
    end_station_name VARCHAR(255),
    end_station_id INT,
    start_lat DECIMAL(9,6),
    start_lng DECIMAL(9,6),
    end_lat DECIMAL(9,6),
    end_lng DECIMAL(9,6),
    member_casual VARCHAR(6),
    start_loc_id INT,
    end_loc_id INT,
    PRIMARY KEY(ride_id),
    CONSTRAINT `fk_divvytrips_original_locations_original_start` FOREIGN KEY (`start_loc_id`)
        REFERENCES `bikes`.`locations_original` (`loc_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_divvytrips_original_locations_original_end` FOREIGN KEY (`end_loc_id`)
        REFERENCES `bikes`.`locations_original` (`loc_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS smartlocation_original (
    statefp INT,
    countyfp INT,
    tractce INT,
    blkgrpce INT,
    totpop INT,
    counthu INT,
    hh INT,
    p_wrkage DECIMAL(5,2),
    autoown0 INT,
    pct_ao0 DECIMAL(5,2),
    autoown1 INT,
    pct_ao1 DECIMAL(5,2),
    autoown2p INT,
    pct_ao2p DECIMAL(5,2),
    r_lowwagewk INT,
    r_medwagewk INT,
    r_hiwagewk INT,
    r_pctlowwage DECIMAL(5,2),
    totemp INT,
    e_lowwagewk INT,
    e_medwagewk INT,
    e_hiwagewk INT,
    e_pctlowwage DECIMAL(5,2),
    d3a DECIMAL(10,5),
    d4a DECIMAL(10,5),
    d5br INT,
    d5be INT,
    d5dr DECIMAL(10,5),
    natwalkind DECIMAL(10,5),
    blk_grp_id INT(10) NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(blk_grp_id)
);

CREATE TABLE IF NOT EXISTS bikes.locations_original (
  geoid BIGINT NOT NULL ,
  state INT(10) NOT NULL ,
  county INT(10) NOT NULL ,
  tract INT(10) NOT NULL ,
  blockgrp INT(10) NOT NULL ,
  lat FLOAT NOT NULL ,
  lng FLOAT NOT NULL ,
  loc_id INT(10) NOT NULL , 
  blk_grp_id INT NOT NULL ,
  PRIMARY KEY (loc_id), 
  CONSTRAINT `fk_locations_original_smartlocations_original` FOREIGN KEY (`blk_grp_id`)
        REFERENCES `bikes`.`smartlocations_original` (`blk_grp_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
);
