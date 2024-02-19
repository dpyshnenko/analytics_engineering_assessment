WITH stg_staking_rewards AS (
    SELECT
        *
    FROM
        {{ ref('stg_staking_rewards') }}
)
SELECT
    rewardDate,
    rewardType,
    rewardPrimaryKey,
    rewardRateForeignKey,
    rewardAmount
FROM stg_staking_rewards
WHERE
    isDeleted = FALSE # filter out deleted listings
    AND rewardType = 'expected' # per assignment definition, only expected rewards are needed
