{{
  config(
    materialized = 'incremental',
    unique_key = 'loginid',
    on_schema_change = 'append_new_columns',
    incremental_strategy = 'merge',
    merge_exclude_columns = ['_dbt_inserted_at']
    )
}}

with logins as (
    select * from {{ ref("stg_logins") }}
),

people as (
    select * from {{ ref("dim_people") }}
),

rename as (
    select
        l.loginid,
        l.logintimestamp,
        l.dayofweek,
        l.peopleid,
        p.fullname
    from logins as l
    left join people as p on l.peopleid = p.peopleid
),

final as (
    select
        *,
        {{ 
            dbt_utils.generate_surrogate_key(
                dbt_utils.get_filtered_columns_in_relation(
                        from=ref("stg_logins")
                )
            )
        }} as _dbt_hash,
        current_timestamp as _dbt_inserted_at,
        current_timestamp as _dbt_updated_at
    from rename
)

select * from final

{% if is_incremental() %}

    where _dbt_hash not in (select _dbt_hash from {{ this }})

{% endif %}