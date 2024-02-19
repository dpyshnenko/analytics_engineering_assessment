WITH stg_staking_rates AS (
    SELECT
        *
    FROM
        {{ ref('stg_staking_rates') }}
),

-- Assuming your table is called 'staking_events'
RankedEvents AS (
    SELECT
        DATE(startDateStaking) AS startDateStaking,
        DATE(endDateStaking) AS endDateStaking,
        DATE(stakingEventCreationTimeStamp) AS stakingEventCreationDate,
        stakingPrimaryKey,
        assetReward,
        assetHold,
        stakedAmount,
        dailyRewardPerUnit,
        ROW_NUMBER() OVER (
            PARTITION BY assetHold, stakingPrimaryKey, DATE(stakingEventCreationTimeStamp)
            ORDER BY stakingEventCreationTimeStamp DESC
        ) AS ranking_number
    FROM stg_staking_rates
    WHERE isDeleted = FALSE # filter out deleted listings
)

SELECT
    *
FROM RankedEvents
WHERE ranking_number = 1 # Keeps only latest staking record during the day. To show latest value of the asset on each day.
