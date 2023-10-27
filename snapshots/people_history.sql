{% snapshot people_history %}

{{
   config(
       target_database='postgres',
       target_schema='analytics',
       unique_key='PeopleId',

       strategy='check',
       check_cols=['FullName']
   )
}}

select * from {{ ref('stg_people') }}

{% endsnapshot %}