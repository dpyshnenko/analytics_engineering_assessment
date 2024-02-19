WITH
int_staking_rates_day AS (
    SELECT * FROM {{ ref('int_staking_rates_day') }}
),

int_dates AS (
    SELECT * FROM {{ ref('int_dates') }}
),

unique_assets_users AS (
    SELECT DISTINCT
        assetHold,
        assetReward,
        stakingPrimaryKey
    FROM
        int_staking_rates_day
),

cross_join_dates_assets_users AS (
    SELECT
        int_dates.dateDay,
        int_dates.dayOfWeekIso,
        int_dates.weekOfYear,
        int_dates.isoWeekStartDate,
        int_dates.monthOfYear,
        int_dates.yearNumber,
        unique_assets_users.assetHold,
        unique_assets_users.assetReward,
        unique_assets_users.stakingPrimaryKey
    FROM
        int_dates
    CROSS JOIN unique_assets_users
)

SELECT
    *
FROM
    cross_join_dates_assets_users
