{{
    config(
        materialized = "table"
    )
}}

{{ dbt_date.get_date_dimension('2023-07-01', '2024-02-17') }}
