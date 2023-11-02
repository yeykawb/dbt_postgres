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
    select * from {{ source('login_service', 'raw_logins') }}

),

renamed as (
    select
        id::text as login_id,
        logintimestamp::timestamp as login_timestamp,
        testdataid as people_id,
        case dayofweek
            when 1 then 'Monday'
            when 2 then 'Tuesday'
            when 3 then 'Wednesday'
            when 4 then 'Thursday'
            when 5 then 'Friday'
            when 6 then 'Saturday'
            when 7 then 'Sunday'
            else 'Unknown'
        end as day_of_week
    from source
)

select * from renamed