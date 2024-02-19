WITH raw_staking_rewards AS (
    SELECT * FROM {{ source('bitvavo_assessment', 'staking_rewards') }}
)

SELECT
    date AS rewardDate,
    type AS rewardType,
    xx AS rewardPrimaryKey,
    rewardXx AS rewardRateForeignKey,
    __source_ts_ms AS rewardEventCreationEpoch,
    {{ dbt_date.from_unixtimestamp("__source_ts_ms", format="milliseconds") }} AS rewardEventCreationTimeStamp,
    amount AS rewardAmount,
    __deleted AS isDeleted
FROM raw_staking_rewards
