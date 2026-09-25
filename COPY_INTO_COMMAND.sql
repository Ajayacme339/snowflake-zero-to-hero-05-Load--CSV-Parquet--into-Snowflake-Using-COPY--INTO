USE ROLE SYSADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE DATAENGINEERINGLEARNING;
USE SCHEMA RAW;

SHOW STAGES;

LIST @INTERNAL_STAGE_LEARNING;

SHOW FILE FORMATS;

-- FILE_FORMAT = FF_CSV_LEARNING
-- internal_stage_learning/Data/EmployeeTABLE.csv

CREATE OR REPLACE TABLE EMPLOYEE_TABLE (
    id        NUMBER(12, 2),
    gender    VARCHAR,
    bdate     VARCHAR,
    educ      NUMBER(12, 2),
    jobcat    VARCHAR,
    salary    NUMBER(12, 2),
    salbegin  NUMBER(12, 2),
    jobtime   NUMBER(12, 2),
    prevexp   VARCHAR,
    minority  VARCHAR
);

------ COPY INTO COMMAND ------

COPY INTO EMPLOYEE_TABLE
FROM (
    SELECT
        $1  AS id,
        $2  AS gender,
        $3  AS bdate,
        $4  AS educ,
        $5  AS jobcat,
        $6  AS salary,
        $7  AS salbegin,
        $8  AS jobtime,
        $9  AS prevexp,
        $10 AS minority
    FROM @internal_stage_learning/Data/EmployeeTABLE.csv
)
FILE_FORMAT = (FORMAT_NAME = 'FF_CSV_LEARNING')
FORCE = TRUE;

-- 474
SELECT COUNT(*) FROM EMPLOYEE_TABLE;

----------------------------------------------
-- PARQUET
----------------------------------------------

LIST @internal_stage_learning;

SELECT $1
FROM @internal_stage_learning/Parquet/titanic.parquet
(FILE_FORMAT => 'FF_PARQUET');

CREATE OR REPLACE TABLE TITANIC_PARQUET (
    passenger_id  INT,
    survived      INT,
    pclass        INT,
    Name          VARCHAR
);

COPY INTO TITANIC_PARQUET
FROM (
    SELECT
        $1:PassengerId::INT     AS passenger_id,
        $1:Survived::INT        AS survived,
        $1:Pclass::INT          AS pclass,
        $1:Name::VARCHAR        AS Name
        -- $1:Sex::CHAR AS Sex
    FROM @internal_stage_learning/Parquet/titanic.parquet
    (FILE_FORMAT => 'FF_PARQUET')
);

SELECT * FROM TITANIC_PARQUET;
