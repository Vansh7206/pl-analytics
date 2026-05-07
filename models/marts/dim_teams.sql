-- This will be used for power bi purposes

with teams as (
    select * from {{ ref("stg_teams") }}
)

select 
    team_id,
    team_name,
    city,
    stadium,
    founded_year,
    manager

from teams