-- This file is used to rename columns, date format and getting out bad rows in home_goals section
with source as (
    select * from {{ source('football_raw','matches') }}
),

renamed as (
    select
        match_id,
        matchweek,
        match_date::date         as match_date,
        home_team_id,
        away_team_id,
        home_goals,
        away_goals,
        stadium,
        referee

        from source
        where home_goals >= 0 
)

select * from renamed