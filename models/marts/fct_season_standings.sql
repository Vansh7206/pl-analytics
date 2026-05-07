-- This is basically points table 

with team_results as (

    select * from {{ ref('int_team_match_results') }}

),

standings as (

    select
        team_id,
        team_name,
        count(*)                                         as matches_played,
        sum(case when result = 'W' then 1 else 0 end)   as wins,
        sum(case when result = 'D' then 1 else 0 end)   as draws,
        sum(case when result = 'L' then 1 else 0 end)   as losses,
        sum(goals_for)                                   as goals_for,
        sum(goals_against)                               as goals_against,
        sum(goals_for) - sum(goals_against)              as goal_difference,
        sum(case when result = 'W' then 3
                 when result = 'D' then 1
                 else 0 end)                             as points

    from team_results
    group by team_id, team_name

),

final as (

    select
        rank() over (order by points desc, goal_difference desc, goals_for desc) as position,
        team_id,
        team_name,
        matches_played,
        wins,
        draws,
        losses,
        goals_for,
        goals_against,
        goal_difference,
        points

    from standings

)

select * from final

