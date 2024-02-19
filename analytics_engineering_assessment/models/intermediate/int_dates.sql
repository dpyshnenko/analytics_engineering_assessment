{{
    config(
        materialized = "table"
    )
}}

WITH stg_dates AS (
    SELECT * FROM {{ ref('stg_dates') }}
)

SELECT
    date_day AS dateDay,
    day_of_week_iso AS dayOfWeekIso,
    week_of_year AS weekOfYear,
    iso_week_start_date AS isoWeekStartDate,
    month_of_year AS monthOfYear,
    year_number AS yearNumber,
    quarter_of_year AS quarterOfYear

FROM
    stg_dates
