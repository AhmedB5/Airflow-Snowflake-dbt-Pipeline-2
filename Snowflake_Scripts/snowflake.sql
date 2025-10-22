-- ======================================
--  Create Warehouse, Database, and Schema
-- ======================================
CREATE OR REPLACE WAREHOUSE DBTDW
  WAREHOUSE_SIZE = 'XSMALL'
  WAREHOUSE_TYPE = 'STANDARD'
  AUTO_SUSPEND = 60
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = FALSE;

USE WAREHOUSE DBTDW;

CREATE OR REPLACE DATABASE AIRBNB_DB
  DATA_RETENTION_TIME_IN_DAYS = 2;

USE DATABASE AIRBNB_DB;
CREATE OR REPLACE SCHEMA MAIN;
CREATE OR REPLACE STAGE GET_DATA;

-- ======================================
--  Create User and Assign Privileges
-- ======================================
USE ROLE ACCOUNTADMIN;

CREATE OR REPLACE USER *****
  PASSWORD = '*******';

CREATE OR REPLACE ROLE ROLE_PRO;

GRANT ROLE ROLE_PRO TO USER USER_PRO;

-- Grant database and schema privileges
GRANT USAGE ON DATABASE AIRBNB_DB TO ROLE ROLE_PRO;
GRANT CREATE SCHEMA ON DATABASE AIRBNB_DB TO ROLE ROLE_PRO;

GRANT USAGE ON ALL SCHEMAS IN DATABASE AIRBNB_DB TO ROLE ROLE_PRO;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE AIRBNB_DB TO ROLE ROLE_PRO;

-- Grant privileges on tables and views
GRANT ALL PRIVILEGES ON ALL TABLES IN DATABASE AIRBNB_DB TO ROLE ROLE_PRO;
GRANT ALL PRIVILEGES ON ALL VIEWS IN DATABASE AIRBNB_DB TO ROLE ROLE_PRO;

GRANT ALL PRIVILEGES ON FUTURE TABLES IN DATABASE AIRBNB_DB TO ROLE ROLE_PRO;
GRANT ALL PRIVILEGES ON FUTURE VIEWS IN DATABASE AIRBNB_DB TO ROLE ROLE_PRO;

-- Grant create privileges on schemas
GRANT CREATE TABLE, CREATE VIEW ON ALL SCHEMAS IN DATABASE AIRBNB_DB TO ROLE ROLE_PRO;
GRANT CREATE TABLE, CREATE VIEW ON FUTURE SCHEMAS IN DATABASE AIRBNB_DB TO ROLE ROLE_PRO;

-- Grant warehouse usage
GRANT USAGE ON WAREHOUSE DBTDW TO ROLE ROLE_PRO;

-- ======================================
--  Create Table and Load Data
-- ======================================
USE ROLE ACCOUNTADMIN;
USE DATABASE AIRBNB_DB;
USE SCHEMA MAIN;

CREATE OR REPLACE TRANSIENT TABLE AIRBNB_LISTINGS_DIRTY (
    id NUMBER(8) PRIMARY KEY,
    host_id NUMBER(15),
    host_identity_verified STRING,
    host_name STRING,
    neighbourhood_group STRING,
    instant_bookable BOOLEAN,
    cancellation_policy STRING,
    room_type STRING,
    construction_year NUMBER,
    price STRING,
    service_fee STRING,
    minimum_nights NUMBER,
    number_of_reviews NUMBER,
    last_review DATE,
    review_rate_number NUMBER,
    calculated_host_listings_count NUMBER,
    availability_365 NUMBER
);

COPY INTO AIRBNB_LISTINGS_DIRTY
FROM @GET_DATA
FILE_FORMAT = (
    TYPE = 'CSV',
    FIELD_OPTIONALLY_ENCLOSED_BY = '"',
    SKIP_HEADER = 1
);

-- ======================================
--  Check Privileges
-- ======================================
SHOW GRANTS OF ROLE ROLE_PRO;
SHOW GRANTS TO USER USER_PRO;
SHOW GRANTS TO ROLE ROLE_PRO;

-- ======================================
--  Verify Data
-- ======================================
SELECT * FROM MAIN.AIRBNB_LISTINGS_DIRTY;
-- SELECT * FROM MAIN.AIRBNB_LISTINGS_CLEAN;

