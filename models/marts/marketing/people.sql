{{
  config(
    materialized = 'table',
    )
}}

with people as (
    select
        *,
        length(full_name) as name_length
    from {{ ref("stg_login_service__people") }}
),

logins_pivoted_to_people as (
    select * from {{ ref('int_logins_pivoted_to_people') }}
),

final as (

    select
        people.*,
        logins_pivoted_to_people.login_amount
    from people
    left join
        logins_pivoted_to_people
        on people.people_id = logins_pivoted_to_people.people_id
)

select * from final