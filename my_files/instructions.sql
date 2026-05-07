-- CREATE DATABASE
CREATE DATABASE IF NOT EXISTS PL_ANALYTICS;

-- CREATE SCHEMA
CREATE SCHEMA IF NOT EXISTS PL_ANALYTICS.RAW;  -- THIS WILL BE FOR RAW UNTOUCHED DATA
CREATE SCHEMA IF NOT EXISTS PL_ANALYTICS.DEV;  -- THIS WILL BE DBT PURPOSES
CREATE SCHEMA IF NOT EXISTS PL_ANALYTICS.PROD; -- THIS WILL BE FOR POWER BI PURPOSES

-- CREATE A WAREHOUSE
CREATE WAREHOUSE IF NOT EXISTS PL_WH
    WAREHOUSE_SIZE = 'X-SMALL'      -- SIZE OF WAREHOUSE
    AUTO_SUSPEND = 60               --TURNS OFF IN 60 SECONDS AUTOMATICALLY
    AUTO_RESUME = TRUE;             -- RESUMES ON ANY QUERY


-- ESTABHLISING CONNECTION OF SNOWFLAKE TO S3
USE DATABASE PL_ANALYTICS;
USE SCHEMA RAW;

CREATE STAGE IF NOT EXISTS pl_stage
    URL = 's3://pl-analytics7/raw/'
    CREDENTIALS = (
        AWS_KEY_ID     = 'your_aws_key_id'
        AWS_SECRET_KEY = 'your_aws_secret_key'
    )
    FILE_FORMAT = (
        TYPE = 'CSV'
        FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        SKIP_HEADER = 1
        NULL_IF = ('', 'NULL')
    );

-- CHECK
LIST @pl_stage;

-- LOADING THE DATA FROM S3 -> SNOWFLAKE
USE DATABASE PL_ANALYTICS;
USE SCHEMA RAW;

-- TEAMS TABLE 
CREATE OR REPLACE TABLE raw_teams (
    team_id             INT,
    team_name           VARCHAR,
    city                VARCHAR,
    stadium             VARCHAR,
    founded_year        INT,
    manager             VARCHAR
);

-- PLAYERS TABLE
CREATE OR REPLACE TABLE raw_players (
    player_id           INT,
    team_id             INT,
    name                VARCHAR,
    position            VARCHAR,
    age                 INT,
    nationality         VARCHAR
);

-- MATCHES TABLE
CREATE OR REPLACE TABLE raw_matches (
    match_id      INT,
    matchweek     INT,
    match_date    VARCHAR,
    home_team_id  INT,
    away_team_id  INT,
    home_goals    INT,
    away_goals    INT,
    stadium       VARCHAR,
    referee       VARCHAR
);

-- MATCH STATS TABLE
CREATE OR REPLACE TABLE raw_match_stats (
    match_id         INT,
    home_xg          FLOAT,
    away_xg          FLOAT,
    home_shots       INT,
    away_shots       INT,
    home_possession  FLOAT,
    away_possession  FLOAT,
    home_fouls       INT,
    away_fouls       INT,
    home_yellows     INT,
    away_yellows     INT
);

-- INSTERTING DATA
COPY INTO raw_teams FROM @pl_stage/raw_teams.csv;
COPY INTO raw_players FROM @pl_stage/raw_players.csv;
COPY INTO raw_matches FROM @pl_stage/raw_matches.csv;
COPY INTO raw_match_stats FROM @pl_stage/raw_match_stats.csv;

-- MANDATORY CHECK
SELECT COUNT(*) FROM PL_ANALYTICS.RAW.raw_teams;
SELECT COUNT(*) FROM PL_ANALYTICS.RAW.raw_players;
SELECT COUNT(*) FROM PL_ANALYTICS.RAW.raw_matches;
SELECT COUNT(*) FROM PL_ANALYTICS.RAW.raw_match_stats;

--After creating intermediate model checks
SELECT COUNT(*) FROM PL_ANALYTICS.DEV.int_team_match_results;
SELECT * FROM PL_ANALYTICS.DEV.int_match_stats_enriched;

-- After creating marts
SELECT * FROM PL_ANALYTICS.DEV.DIM_TEAMS;
SELECT * FROM PL_ANALYTICS.DEV.fct_season_standings;
SELECT * FROM PL_ANALYTICS.DEV.fct_team_performance;

