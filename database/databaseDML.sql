USE bikes;
# File paths removed

# Order of data upload is based on foreign keys

--- Uploading Data from csv file ---
# Smart Location Data
LOAD DATA LOCAL INFILE "C:/Users/..."
INTO TABLE smartlocation_original
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

# Location Lookup 
LOAD DATA LOCAL INFILE "C:/Users/..."
INTO TABLE locations_original
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS  ;
ALTER TABLE locations
DROP COLUMN geoid;

# Bike Racks
LOAD DATA LOCAL INFILE "C:/Users/..."
INTO TABLE bikeracks_original
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

# Crash Data
LOAD DATA LOCAL INFILE "C:/Users/..."
INTO TABLE crashdata_original
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

# Divvy Stations
LOAD DATA LOCAL INFILE "C:/Users/..."
INTO TABLE divvystations_original
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

# Divvy Trips
LOAD DATA LOCAL INFILE "C:/Users/..."
INTO TABLE divvytrips_original
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\n"
IGNORE 1 ROWS;

--- Coordinate Rounding ---
SET sql_safe_updates = 0;

UPDATE crashdata_original
SET latitude = ROUND(latitude, 4),
    longitude = ROUND(longitude, 4)
WHERE crash_record_id IS NOT NULL;

UPDATE bikeracks_original
SET latitude = ROUND(latitude, 4),
    longitude = ROUND(longitude, 4)
WHERE rack_id IS NOT NULL;

UPDATE divvystations_original
SET latitude = ROUND(latitude, 4),
    longitude = ROUND(longitude, 4)
WHERE station_id IS NOT NULL;

UPDATE divvytrips_original
SET start_lat = ROUND(start_lat, 4),
    start_lng = ROUND(start_lng, 4),
    end_lat = ROUND(end_lat, 4),
    end_lng = ROUND(end_lng, 4),
WHERE ride_id IS NOT NULL;

--- Inserting foreign key data ---
UPDATE locations_original l
JOIN smartlocation_original sl ON 
  l.state = sl.statefp
  AND l.county = sl.countyfp
  AND l.tract = sl.tractce
  AND l.blockgrp = sl.blkgrpce
SET l.blk_grp_id = sl.blk_grp_id;

UPDATE crashdata_original c
JOIN locations_original l ON 
  c.longitude = l.lng
  AND c.latitude = l.lat
SET c.loc_id = l.loc_id;

UPDATE bikerack_original b
JOIN locations_original l ON 
  b.longitude = l.lng
  AND b.latitude = l.lat
SET b.loc_id = l.loc_id;

UPDATE divvystation_original ds
JOIN locations_original l ON 
  ds.longitude = l.lng
  AND ds.latitude = l.lat
SET ds.loc_id = l.loc_id;

UPDATE divvytrips_original dt
JOIN locations_original l ON 
  dt.start_lng = l.lng
  AND dt.start_lat = l.lat
SET ds.start_loc_id = l.loc_id;

UPDATE divvytrips_original dt
JOIN locations_original l ON 
  dt.end_lng = l.lng
  AND dt.end_lat = l.lat
SET ds.end_loc_id = l.loc_id;

SHOW TABLES;
