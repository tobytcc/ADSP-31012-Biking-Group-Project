CREATE TABLE CrashData_original (
    CRASH_RECORD_ID INT AUTO_INCREMENT PRIMARY KEY,
    CRASH_DATE DATETIME,
    POSTED_SPEED_LIMIT INT,
    TRAFFIC_CONTROL_DEVICE VARCHAR(255),
    WEATHER_CONDITION VARCHAR(255),
    LIGHTING_CONDITION VARCHAR(255),
    TRAFFICWAY_TYPE VARCHAR(255),
    ROADWAY_SURFACE_COND VARCHAR(255),
    CRASH_TYPE VARCHAR(255),
    HIT_AND_RUN_I CHAR(1),
    PRIM_CONTRIBUTORY_CAUSE VARCHAR(255),
    STREET_NO INT,
    STREET_DIRECTION CHAR(1),
    STREET_NAME VARCHAR(255),
    DOORING_I CHAR(1),
    MOST_SEVERE_INJURY VARCHAR(255),
    INJURIES_FATAL INT,
    INJURIES_INCAPACITATING INT,
    INJURIES_NON_INCAPACITATING INT,
    CRASH_HOUR INT,
    CRASH_DAY VARCHAR(255),
    CRASH_MONTH INT,
    LATITUDE DECIMAL(9,6),
    LONGITUDE DECIMAL(9,6)
);


CREATE TABLE BikeRacks_original (
    Latitude DECIMAL(9,6),
    Longitude DECIMAL(9,6),
    Location VARCHAR(255),
    Name VARCHAR(255),
    Quantity INT,
    Type VARCHAR(50)
);

CREATE TABLE DivvyRacks_original (
	rack_id INT PRIMARY KEY,
    station_name VARCHAR(255),
    address VARCHAR(255),
    total_docks INT,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);

CREATE TABLE DivvyTrips_original (
    ride_id VARCHAR(255) PRIMARY KEY,
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
    member_casual VARCHAR(50)
);

CREATE TABLE SmartLocation_original (
    TRACTCE VARCHAR(255),
    BLKGRPCE VARCHAR(255),
    TotPop INT,
    CountHU INT,
    HH INT,
    P_WrkAge DECIMAL(5,2),
    AutoOwn0 INT,
    Pct_AO0 DECIMAL(5,2),
    AutoOwn1 INT,
    Pct_AO1 DECIMAL(5,2),
    AutoOwn2p INT,
    Pct_AO2p DECIMAL(5,2),
    R_LowWageWk INT,
    R_MedWageWk INT,
    R_HiWageWk INT,
    R_PctLowWage DECIMAL(5,2),
    TotEmp INT,
    E_LowWageWk INT,
    E_MedWageWk INT,
    E_HiWageWk INT,
    E_PctLowWage DECIMAL(5,2),
    D3a DECIMAL(10,5),
    D4a DECIMAL(10,5),
    D5br INT,
    D5be INT,
    D5dr DECIMAL(10,5),
    NatWalkInd DECIMAL(10,5)
);

