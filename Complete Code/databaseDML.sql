USE bikes;
# File paths removed
# Order of data upload is based on foreign keys

--- Uploading Data from csv file into staging tables ---
# Smart Location Data
LOAD DATA LOCAL INFILE " "
INTO TABLE smartlocation 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

# Locations
LOAD DATA LOCAL INFILE ' ' 
INTO TABLE location_staging
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS  ;
ALTER TABLE locations_original
DROP COLUMN geoid;

# Bike Racks
LOAD DATA LOCAL INFILE " "
INTO TABLE rack_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

# Crash Data
LOAD DATA LOCAL INFILE " "
INTO TABLE crash_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;
UPDATE crash_staging
SET crash_date = 
    CASE
        WHEN crash_date REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4} [0-9]{1,2}:[0-9]{2}$' THEN STR_TO_DATE(crash_date, '%m/%d/%Y %H:%i')
        WHEN crash_date REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4} [0-9]{1,2}:[0-9]{2}:[0-9]{2} [AP]M$' THEN STR_TO_DATE(crash_date, '%m/%d/%Y %h:%i:%s %p')
        ELSE NULL
    END;
ALTER TABLE crash_staging
MODIFY COLUMN crash_date DATETIME;

# Divvy Stations
LOAD DATA LOCAL INFILE " "
INTO TABLE divvystation_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

# Divvy Trips
LOAD DATA LOCAL INFILE " "
INTO TABLE divvytrip_staging
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;
UPDATE divvytrip_staging
SET started_at = 
    CASE
        WHEN started_at REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4} [0-9]{1,2}:[0-9]{2}$' THEN STR_TO_DATE(started_at, '%d/%m/%Y %H:%i')
        ELSE NULL
    END;
UPDATE divvytrip_staging
SET ended_at = 
    CASE
        WHEN ended_at REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4} [0-9]{1,2}:[0-9]{2}$' THEN STR_TO_DATE(ended_at, '%d/%m/%Y %H:%i')
        ELSE NULL
    END;  
ALTER TABLE divvytrip_staging
MODIFY COLUMN ended_at DATETIME,
MODIFY COLUMN started_at DATETIME;
 
--- Coordinate Rounding ---
SET sql_safe_updates = 0;

UPDATE crash_staging
SET latitude = ROUND(latitude, 4),
    longitude = ROUND(longitude, 4)
WHERE crash_record_id IS NOT NULL;

UPDATE rack_staging
SET latitude = ROUND(latitude, 4),
    longitude = ROUND(longitude, 4)
WHERE rack_id IS NOT NULL;

UPDATE divvystation_staging
SET latitude = ROUND(latitude, 4),
    longitude = ROUND(longitude, 4)
WHERE station_id IS NOT NULL;

UPDATE divvytrip_staging
SET start_lat = ROUND(start_lat, 4),
    start_lng = ROUND(start_lng, 4),
    end_lat = ROUND(end_lat, 4),
    end_lng = ROUND(end_lng, 4)
WHERE ride_id IS NOT NULL;

--- Inserting foreign key data into final tables ---

# Location
INSERT INTO bikes.location
(state , 
county,  
tract ,
blockgrp,
lat,
lng,  
loc_id  ,
blk_grp_id)
SELECT 
l.state , 
l.county,  
l.tract ,
l.blockgrp,
l.lat,
l.lng,  
l.loc_id  ,
sl.blk_grp_id
FROM
location_staging l
LEFT JOIN smartlocation sl ON 
  l.state = sl.statefp
  AND l.county = sl.countyfp
  AND l.tract = sl.tractce
  AND l.blockgrp = sl.blkgrpce;

# Crash
INSERT INTO bikes.crash
(crash_date ,
 posted_speed_limit ,
 traffic_control_device ,
 weather_condition ,
 lighting_condition,
 trafficway_type ,
 roadway_surface_cond ,
 crash_type ,
 hit_and_run_i ,
 prim_contributory_cause ,
 street_no ,
 street_direction ,
 street_name ,
 dooring_i ,
 most_severe_injury ,
 injuries_fatal ,
 injuries_incapacitating ,
 injuries_non_incapacitating,
 crash_hour ,
 crash_day ,
 crash_month ,
 latitude ,
 longitude ,
 crash_record_id ,
 loc_id)
 SELECT 
 c.crash_date ,
 c.posted_speed_limit ,
 c.traffic_control_device ,
 c.weather_condition ,
 c.lighting_condition,
 c.trafficway_type ,
 c.roadway_surface_cond ,
 c.crash_type ,
 c.hit_and_run_i ,
 c.prim_contributory_cause ,
 c.street_no ,
 c.street_direction ,
 c.street_name ,
 c.dooring_i ,
 c.most_severe_injury ,
 c.injuries_fatal ,
 c.injuries_incapacitating ,
 c.injuries_non_incapacitating,
 c.crash_hour ,
 c.crash_day ,
 c.crash_month ,
 c.latitude ,
 c.longitude ,
 c.crash_record_id ,
 l.loc_id
FROM
crash_staging c
LEFT JOIN location l ON 
  c.longitude = l.lng
  AND c.latitude = l.lat ;

# Rack
INSERT INTO bikes.rack
(latitude ,
 longitude ,
 location ,
 name,
 quantity,
 type,
 rack_id ,
 loc_id)
 SELECT 
 r.latitude ,
 r.longitude ,
 r.location ,
 r.name,
 r.quantity,
 r.type,
 r.rack_id ,
 l.loc_id
FROM
rack_staging r
LEFT JOIN location l ON 
  r.longitude = l.lng
  AND r.latitude = l.lat ;

# Divvy Station
INSERT INTO bikes.divvystation
(station_id ,
 station_name ,
 total_docks ,
 latitude ,
 longitude ,
 loc_id )
 SELECT 
 ds.station_id ,
 ds.station_name ,
 ds.total_docks ,
 ds.latitude ,
 ds.longitude ,
 l.loc_id 
FROM
divvystation_staging ds
LEFT JOIN location l ON 
  ds.longitude = l.lng
  AND ds.latitude = l.lat ;

# Divvy Trip
INSERT INTO bikes.divvytrip
(ride_id ,
 rideable_type ,
 started_at ,
 ended_at ,
 start_station_name ,
 start_station_id ,
 end_station_name ,
 end_station_id ,
 start_lat ,
 start_lng ,
 end_lat ,
 end_lng ,
 member_casual ,
 start_loc_id ,
 end_loc_id)
SELECT
dt.ride_id ,
dt.rideable_type ,
dt.started_at ,
dt.ended_at ,
dt.start_station_name ,
dt.start_station_id ,
dt.end_station_name ,
dt.end_station_id ,
dt.start_lat ,
dt.start_lng ,
dt.end_lat ,
dt.end_lng ,
dt.member_casual ,
lstart.loc_id ,
lend.loc_id

FROM
divvytrip_staging dt
LEFT JOIN location lstart ON 
  dt.start_lng = lstart.lng
  AND dt.start_lat = lstart.lat
LEFT JOIN location lend ON 
  dt.end_lng = lend.lng
  AND dt.end_lat = lend.lat;
