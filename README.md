# Analytics Engineering Assessment

## Project description:
One of the ways Bitvavo earns passive income is by staking cryptocurrencies. Think of staking as depositing 
cryptocurrencies in a "high-yield savings account". Assets are locked up for a certain term. In exchange 
for locking up these assets, Bitvavo receives rewards in either the same asset or others as staking rewards.

The data is based on [dbt project folder](https://github.com/bitvavo/data-analytics-engineering-assessment)
containing data related to cryptocurrency staking. The dataset includes information about the 
amount of assets staked and the expected rewards for various cryptocurrencies. 

## Project Goal: 
To build a small dbt project to answer the following question:
- How much asset is staked every consecutive day since the 1st of July 2023 until the current date, 
and how much reward is expected for each of those consecutive days?

## Deliverables
- Dimentional models that contain information regarding the key project questions: 
    - The amount of assets staked for each consecutive day  within the specified date range (`dim_staking_agg_day`).
    - Expected rewards for each of those consecutive days (`dim_rewards_agg_day`).
- All models are documented in `schema.yml` files, and in-depth explanations are provided within inline comments.
- A README file containing a brief summary of my approach, assumptions made, and additional considerations
for performance and maintainability.
- [A dashboard](https://lookerstudio.google.com/reporting/b167c2c9-4f5e-4551-bbfe-84d8874e3c20) which provides visualizations of key metrics derived from our dbt models.

## Assumptions & Observations:
- The dataset originates from CSV files. The transactional nature of data is not suitable for seed files, so staging models are the first step in the data transformation process, which have been loaded from the BigQuery raw data tables.
- The project covers the period starting from July 1, 2023, until the current date. However, actual data is available from `2023-07-01` to `2023-11-08`.
- Only `type: expected` rewards have been used to calculate the total rewards, as `corrected` and `realised` require full calendar month. 
- Lines with `__deleted = true` have been removed from the data, assuming it provides erroneous data not applicable for the analysis.
- `stalking_rates` dataset contains duplicate rows that have been excluded from the model. However, it was not possible to determine the reason for the duplicates. 
- Only assets that are present in `stalking_rates` table have been used to calculate staking rate and total rewards. In the table `stalking_rewards`, there are some cases where assets that are not present: `rewardXx` does not exist in `stalking_rates`. 
Such cases have been skipped, as it is not possible to determine the asset name for such rewards observations.
- For some assets, there was information about the expected rewards before even this asset was staked.
- For some events even after `endDateStaking` there were new `stakingEventCreationTimeStamp` events. 
As it was not possible to determine the reason for such events, `endDateStaking` and `startDateStaking` have not been used to calculate the dataframe with dates which could improve the performance of the model. 


## Data Modeling Approach
This project includes the following models:
- **staging models**: Raw data is ingested from CSV files into BigQuery, and staging models (`stg_` prefix) are used to clean and prepare data for downstream modeling.
- **intermediate models**: Intermediate models (`int_` prefix) handle complex transformations and business logic before final aggregation.
- **dimensional models**: Output tables with aggregated information for staking and rewards amounts per required dimensions (e.g. asset name, date). These tables be re-used by various stakeholders for further analysis and visualization.

To create a table with consecutive dates, a date range has been generated from the first of July 2023 until the current date. Later on this table has been merged with aggregated staking information per day. 
Rows with days without `stakingEventCreation` have been backfilled with the previous data to keep track of the staking amount. 
Lastly this aggregated staking information has been merged (`dim_assets_merged`) with the rewards information to be able to calculate the total rewards per day.


The final data flow process looks in the following way: 
![dbt-dag.png](analytics_engineering_assessment%2Fassets%2Fdbt-dag.png)

## Performance & Maintainability Considerations
- For production use, incremental models could be more suitable for storing transactional data. This could enhance performance, only processing new or changed data.
- Modularity: The dbt tool has been selected as it provides modular components to enable reusability and to make the project easier to navigate and maintain.
- Documentation: All models are documented in `schema.yml` files, and in-depth explanations are provided within the dbt project's README and inline comments.
- Version Control: Changes to the dbt project are managed [through Git](https://github.com/dpyshnenko/analytics_engineering_assessment), providing an audit trail and facilitating collaboration.

## Quick Start
This project has been completed using `dbt` and `BigQuery` tools. Dashboard has been created using `Google Data Studio`.

### Setting up dbt
To get started with this dbt project, follow these steps:

- Install dbt for BigQuery (`dbt-bigquery`)
- Clone the repository from the dbt project folder. Additionally raw_data could be loaded as `seeds` for testing purposes.
- Set up your `profiles.yml` to connect to your BigQuery instance (you will need to have access to a Google Cloud project).
- Run `dbt deps` to install dependencies.