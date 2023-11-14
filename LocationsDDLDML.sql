use bikes;

#show tables;

CREATE TABLE IF NOT EXISTS bikes.Locations_original (
  `geoid` BIGINT NOT NULL ,
  `state` INT(10) NOT NULL ,
  `county` INT(10) NOT NULL ,
  `tract` INT(10) NOT NULL ,
  `blockgrp` INT(10) NOT NULL ,
  `lat` FLOAT NOT NULL ,
  `lng` FLOAT NOT NULL ,
  `loc_id` INT(10) NOT NULL , 
  PRIMARY KEY (`loc_id`));

LOAD DATA LOCAL INFILE '/Users/hank/Documents/UChicago/Data Engineering Platforms/Final Project/Location_Mapping.csv' 
INTO TABLE Locations_original
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS (`geoid`,`state`,`county`,`tract`,`blockgrp`,`lat`,`lng`, `loc_id`);

ALTER TABLE locations
DROP COLUMN geoid;

# select * from bikes.locations;
