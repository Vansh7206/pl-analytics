with enriched as (
    select * from {{ ref('int_match_results_enriched') }}
),

home_record as (
    select
        '2023-24'                               as season,
        home_team_id                            as team_id,
        'home'                                  as venue,
        count(*)                                as matches_played,
        sum(home_points)                        as total_points,
        sum(case when match_result = 'home_win'
                 then 1 else 0 end)             as wins,
        sum(case when match_result = 'draw'
                 then 1 else 0 end)             as draws,
        sum(case when match_result = 'away_win'
                 then 1 else 0 end)             as losses,
        sum(home_goals)                         as goals_scored,
        sum(away_goals)                         as goals_conceded,
        sum(case when home_clean_sheet
                 then 1 else 0 end)             as clean_sheets,
        round(avg(home_possession), 2)          as avg_possession,
        round(avg(home_shots), 2)               as avg_shots
    from enriched
    group by home_team_id           -- season removed from group by (it's a literal)
),

away_record as (
    select
        '2023-24'                               as season,
        away_team_id                            as team_id,
        'away'                                  as venue,
        count(*)                                as matches_played,
        sum(away_points)                        as total_points,
        sum(case when match_result = 'away_win'
                 then 1 else 0 end)             as wins,
        sum(case when match_result = 'draw'
                 then 1 else 0 end)             as draws,
        sum(case when match_result = 'home_win'
                 then 1 else 0 end)             as losses,
        sum(away_goals)                         as goals_scored,
        sum(home_goals)                         as goals_conceded,
        sum(case when away_clean_sheet
                 then 1 else 0 end)             as clean_sheets,
        round(avg(away_possession), 2)          as avg_possession,
        round(avg(away_shots), 2)               as avg_shots
    from enriched
    group by away_team_id           -- season removed from group by (it's a literal)
),

combined as (
    select * from home_record
    union all
    select * from away_record
)

select
    season,
    team_id,
    venue,
    matches_played,
    total_points,
    wins,
    draws,
    losses,
    goals_scored,
    goals_conceded,
    (goals_scored - goals_conceded)                             as goal_difference,
    clean_sheets,
    avg_possession,
    avg_shots,
    round(wins * 1.0 / nullif(matches_played, 0) * 100, 1)     as win_percentage
from combined
order by team_id, venue