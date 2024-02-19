# Bitvavo Analytics Engineering Assessment pipeline

One of the ways Bitvavo earns passive income is by staking cryptocurrencies. Think of staking as depositing 
cryptocurrencies in a "high-yield savings account". Assets are locked up for a certain term. In exchange 
for locking up these assets, Bitvavo receives rewards in either the same asset or others as staking rewards.

The data is based on [dbt project folder](https://github.com/bitvavo/data-analytics-engineering-assessment)
containing data related to cryptocurrency staking. The dataset includes information about the 
amount of assets staked and the expected rewards for various cryptocurrencies. 

This models answers the following question:
- How much asset is staked every consecutive day since the first of July 2023 until the current date, 
and how much reward is expected for each of those consecutive days?

## Quick Start
This project has been completed using `dbt` and `BigQuery` tools. Dashboard has been created using `Google Data Studio`.

### Setting up dbt
To get started with this dbt project, follow these steps:

- Install dbt for BigQuery.
- Clone the repository from the dbt project folder. Additionally raw_data could be loaded as `seeds` for testing purposes.
- Set up your `profiles.yml` to connect to your BigQuery instance (you will need to have access to a Google Cloud project).
- Run `dbt deps` to install dependencies.

### Running the dbt project

To execute the dbt models and see the results:

- Run `dbt run` to execute all models.
- Run `dbt test` to execute tests and ensure data integrity.
- Use `dbt docs generate` and dbt docs serve to generate and view documentation.

## SQLFluff
I've used [SQLFluff](https://www.sqlfluff.com/) for linting SQL files.

## Install dbt packages
The following packages are required to run the project:
- `dbt_date`
- `dbt_utils`

To install dbt packages, run the following command:
```bash
dbt deps
```