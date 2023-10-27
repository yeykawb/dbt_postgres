
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/
{{
  config(
    materialized = 'table',
    )
}}

with people as (
    select 
        *,
        length(fullname) as NameLength 
    from {{ ref("stg_people") }}
)

select * from people

/*
    Uncomment the line below to remove records with null `id` values
*/
