WITH dim_assets_merged AS (
    SELECT * FROM  {{ ref('dim_assets_merged') }}
)

SELECT
    dateDay,
    dayOfWeekIso,
    weekOfYear,
    isoWeekStartDate,
    assetReward,
    SUM(rewardAmount) AS rewardAmountSum
FROM
    dim_assets_merged
GROUP BY 1, 2, 3, 4, 5
