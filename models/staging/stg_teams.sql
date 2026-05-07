--Normal staging has been done here
with source as (

    select * from {{ source('football_raw', 'teams') }}
),
renamed as (

    select
        team_id,                
        team_name,
        city,
        stadium,
        founded_year,
        manager

    from source
)

select * from renamed