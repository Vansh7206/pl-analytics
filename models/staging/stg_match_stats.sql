--Normal staging has been done here
with source as (

    select * from {{ source('football_raw', 'match_stats') }}

),

renamed as (

    select
        match_id,
        home_xg,
        away_xg,
        home_shots,
        away_shots,
        home_possession,
        away_possession,
        home_fouls,
        away_fouls,
        home_yellows,
        away_yellows

    from source

)

select * from renamed