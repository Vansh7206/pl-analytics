-- Overall Summary based on expected goals and scored goals

with stats as (

    select * from {{ ref('int_match_stats_enriched') }}

),

results as (

    select * from {{ ref('int_team_match_results') }}

),

home_stats as (

    select
        home_team_id                as team_id,
        sum(home_xg)                as total_xg,
        sum(home_shots)             as total_shots,
        avg(home_possession)        as avg_possession

    from stats
    group by home_team_id

),

away_stats as (

    select
        away_team_id                as team_id,
        sum(away_xg)                as total_xg,
        sum(away_shots)             as total_shots,
        avg(away_possession)        as avg_possession

    from stats
    group by away_team_id

),

combined as (

    select
        team_id,
        sum(total_xg)               as total_xg,
        sum(total_shots)            as total_shots,
        avg(avg_possession)         as avg_possession

    from (
        select * from home_stats
        union all
        select * from away_stats
    )

    group by team_id

),

actual_goals as (

    select
        team_id,
        sum(goals_for)              as actual_goals

    from results
    group by team_id

),

final as (

    select
        c.team_id,
        d.team_name,
        round(c.total_xg, 2)                                        as total_xg,
        a.actual_goals,
        a.actual_goals - round(c.total_xg, 2)                       as xg_overperformance,
        c.total_shots,
        round(c.avg_possession, 2)                                  as avg_possession

    from combined c
    left join actual_goals a on c.team_id = a.team_id
    left join {{ ref('dim_teams') }} d on c.team_id = d.team_id

)

select * from final