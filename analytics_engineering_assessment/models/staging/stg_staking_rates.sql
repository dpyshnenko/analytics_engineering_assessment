WITH raw_staking_rates AS (
    SELECT * FROM  {{ source('bitvavo_assessment', 'staking_rates') }}
)

SELECT
    `start` AS startDateStaking,
    `end` AS endDateStaking,
    xx AS stakingPrimaryKey,
    assetReward,
    assetHold,
    __source_ts_ms AS stakingEventCreationEpoch,
    {{ dbt_date.from_unixtimestamp("__source_ts_ms", format="milliseconds") }} AS stakingEventCreationTimeStamp,
    stakedAmount,
    dailyRewardPerUnit,
    __deleted AS isDeleted
FROM raw_staking_rates
