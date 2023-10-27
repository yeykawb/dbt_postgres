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
    select * from {{ ref('raw_people') }}
),

renamed as (

      select 
            id as peopleid,
            concat(firstname, ' ', lastname) as fullname

      from source
)

select * from renamed
  