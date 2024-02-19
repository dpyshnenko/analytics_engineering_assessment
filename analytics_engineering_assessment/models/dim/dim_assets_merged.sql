WITH int_asset_user_day AS (
    SELECT * FROM  {{ ref('int_assets_staking_agg') }}
),

int_staking_rewards AS (
    SELECT * FROM  {{ ref('int_staking_rewards') }}
)

SELECT
    int_asset_user_day.dateDay,
    int_asset_user_day.dayOfWeekIso,
    int_asset_user_day.weekOfYear,
    int_asset_user_day.isoWeekStartDate,
    int_asset_user_day.monthOfYear,
    int_asset_user_day.yearNumber,
    int_asset_user_day.stakingPrimaryKey,
    int_asset_user_day.assetHold,
    int_asset_user_day.assetReward,
    int_asset_user_day.startDateStaking,
    int_asset_user_day.endDateStaking,
    int_asset_user_day.stakedAmount,
    int_asset_user_day.dailyRewardPerUnit,
    int_staking_rewards.rewardType,
    int_staking_rewards.rewardPrimaryKey,
    int_staking_rewards.rewardRateForeignKey,
    int_staking_rewards.rewardAmount
FROM
    int_asset_user_day
LEFT JOIN int_staking_rewards ON
    int_asset_user_day.dateDay = int_staking_rewards.rewardDate
    AND int_asset_user_day.stakingPrimaryKey = int_staking_rewards.rewardRateForeignKey
