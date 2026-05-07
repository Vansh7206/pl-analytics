--Normal staging has been done here
with source as (

    select * from {{ source('football_raw', 'players') }}

),
renamed as (

    select
        player_id,
        team_id,
        name,
        position,
        age,
        nationality

    from source

)

select * from renamed