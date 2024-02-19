WITH int_assets_empty_array AS (
    SELECT * FROM  {{ ref('int_assets_empty_array') }}
),

int_staking_rates_day AS (
    SELECT * FROM  {{ ref('int_staking_rates_day') }}
),

staking_rates_array AS (
    SELECT
        int_assets_empty_array.dateDay,
        int_assets_empty_array.dayOfWeekIso,
        int_assets_empty_array.weekOfYear,
        int_assets_empty_array.isoWeekStartDate,
        int_assets_empty_array.monthOfYear,
        int_assets_empty_array.yearNumber,
        int_assets_empty_array.stakingPrimaryKey,
        int_assets_empty_array.assetHold,
        int_assets_empty_array.assetReward,
        int_staking_rates_day.startDateStaking,
        int_staking_rates_day.endDateStaking,
        int_staking_rates_day.stakedAmount,
        int_staking_rates_day.dailyRewardPerUnit
    FROM int_assets_empty_array
    LEFT JOIN int_staking_rates_day ON
        int_assets_empty_array.dateDay = int_staking_rates_day.stakingEventCreationDate
        AND int_assets_empty_array.assetHold = int_staking_rates_day.assetHold
        AND int_assets_empty_array.stakingPrimaryKey = int_staking_rates_day.stakingPrimaryKey
),


ranked_events AS (
    SELECT
        *,
        LAST_VALUE(dateDay IGNORE NULLS) OVER (PARTITION BY assetHold, stakingPrimaryKey ORDER BY dateDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS nearestStakingDate,
        LAST_VALUE(stakedAmount IGNORE NULLS) OVER (PARTITION BY assetHold, stakingPrimaryKey ORDER BY dateDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS nearestStakedAmount,
        LAST_VALUE(dailyRewardPerUnit IGNORE NULLS) OVER (PARTITION BY assetHold, stakingPrimaryKey ORDER BY dateDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS nearestDailyRewardPerUnit,
        LAST_VALUE(startDateStaking IGNORE NULLS) OVER (PARTITION BY assetHold, stakingPrimaryKey ORDER BY dateDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS nearestStartDateStaking,
        LAST_VALUE(endDateStaking IGNORE NULLS) OVER (PARTITION BY assetHold, stakingPrimaryKey ORDER BY dateDay ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS nearestEndDateStaking
    FROM
        staking_rates_array
)

SELECT
    dateDay,
    dayOfWeekIso,
    weekOfYear,
    isoWeekStartDate,
    monthOfYear,
    yearNumber,
    stakingPrimaryKey,
    assetHold,
    assetReward,
    nearestStartDateStaking AS startDateStaking,
    nearestEndDateStaking AS endDateStaking,
    CASE
        WHEN nearestStakingDate IS NULL THEN 0
        ELSE nearestStakedAmount
    END AS stakedAmount,
    CASE
        WHEN nearestStakingDate IS NULL THEN 0
        ELSE nearestDailyRewardPerUnit
    END AS dailyRewardPerUnit
FROM
    ranked_events
