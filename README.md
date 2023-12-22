# University of Chicago - Data Engineering Platforms for Analytics (ADSP 31012) Final Project

# Evaluation of key investment areas towards Chicago bike infrastructure to increase city bikeability and decrease road deaths

Team Members:
- [Hank Snowdon](https://github.com/hanksnowdon)
- [Christian Piantanida](https://github.com/cpiantanida12)
- [Daichi Ishikawa](https://github.com/daichi6)
- [Toby Chiu](https://github.com/tobytcc)

The README contains only a brief overview of our goals, investigation process, analysis, and recommendations.

For detailed documentation/analysis/findings, please refer to our final [presentation](/Final%20Presentation_Group7.pdf) and [report](/DEPA%20Group%207%20Final%20Project%20Document.pdf).

## Goal
We aim to investigate how Chicago could improve on traffic safety and accessibility by promoting biking, specifically through analyzing Chicago’s current bikeability, and identifying room for improvement towards promoting biking through infrastructure and accessibility.

## Data Sources
We utilized public data from the City of Chicago, namely traffic data, bike racks/trips, and demographic data to identify biking and safety trends across socioeconomic and geographic areas.

## EDA
After analysis of data distributions and univariate trends, we identified three findings that guided our final investigations:
1. Crashes are mainly caused by driver error, not by conditions or cyclist mistakes.
2. Physical infrastructure (protected bike lanes) is therefore the best way to physically separate bikes from dangerous cars.
3. Existing bike infrastructure varies across the city, and especially limited on the South and West Sides of Chicago.

## Data Modeling
We utilized Google Cloud Platform (GCP) to create a central accessible database for our team, and GitHub to share DML/DDL scripts throughout the modelling process. We used Excel and Jupyter Notebooks to wrangle the data from its base form, and MySQL workbench to change the database into our desired OLAP format. We then used Tableau to create visualizations and draw insights.

We transformed our initial OLTP model into a OLAP snowflake schema, to structure our data more effectively, making it easier for us to analyze our data in Tableau to create valuable insights. We created 3 fact tables for crashes, bike trips, and bike racks, and created dimensions to link different fact tables.

## Insights: We have identified 3 key problems and areas of improvements regarding biking in Chicago:
1. There are significant high-volume crash areas in Chicago, particularly downtown and key arterial roads in N Milwaukee Ave and N Clark St.
![Milwaukee/Clark](/img/Clark_Milwaukee.png)
2. The city has numerous low-traffic bike areas which critically need bike access, especially in poorer, low accessibility areas in south/west Chicago.
![Low Bike Access](/img/low%20bike%20accessibility.png)
3. Bike racks and Divvy stations are often few and far between
![Poor Bike Storage Infrastructure](/img/bike_divvy%20racks.png)

## Recommendations
Based on our insights, we have provided several recommendations to reach our intended goal in decreasing biking injuries and encourage further ridership:
1. Protected bike lanes and lower speed limits on Clark St and Milwaukee Ave
2. Protected bike routes west from Lakefront to increase safe access to transit
3. Create safe bike paths in specific dangerous crash areas
4. Protected bike lanes in South Chicago
5. Influx of Divvy stations/bike racks in South/West sides
