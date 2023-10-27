{{
  config(
    materialized = 'view'
    )
}}

with source as (

    {#-
    Normally we would select from the table here, but we are using seeds to load
    our data in this project
    #}
    select * from {{ ref('raw_logins') }}

),
renamed as (
      select
            id as loginid,
            logintimestamp,
            CASE dayofweek
                  WHEN 1 THEN 'Monday'
                  WHEN 2 THEN 'Tuesday'
                  WHEN 3 THEN 'Wednesday'
                  WHEN 4 THEN 'Thursday'
                  WHEN 5 THEN 'Friday'
                  WHEN 6 THEN 'Saturday'
                  WHEN 7 THEN 'Sunday'
                  ELSE 'Unknown'
            END AS dayofweek,
            testdataid as peopleid
      from source
)

select * from renamed