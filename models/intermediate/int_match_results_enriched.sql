with matches as (
    select * from {{ ref('stg_matches') }}
),

match_stats as (
    select * from {{ ref('int_match_stats_enriched') }}
),

final as (
    select
        m.match_id,
        m.matchweek,
        m.match_date,
        m.home_team_id,
        m.away_team_id,
        m.home_goals,
        m.away_goals,
        m.stadium,
        m.referee,

        (m.home_goals - m.away_goals)                       as home_goal_diff,
        (m.away_goals - m.home_goals)                       as away_goal_diff,

        case
            when m.home_goals > m.away_goals then 'home_win'
            when m.home_goals < m.away_goals then 'away_win'
            else 'draw'
        end                                                  as match_result,

        case
            when m.home_goals > m.away_goals then 3
            when m.home_goals = m.away_goals then 1
            else 0
        end                                                  as home_points,

        case
            when m.away_goals > m.home_goals then 3
            when m.home_goals = m.away_goals then 1
            else 0
        end                                                  as away_points,

        case when m.away_goals = 0 then true else false end  as home_clean_sheet,
        case when m.home_goals = 0 then true else false end  as away_clean_sheet,

        case
            when (m.home_goals + m.away_goals) > 3 then true
            else false
        end                                                  as is_high_scoring,

        ms.home_possession,
        ms.away_possession,
        ms.home_shots,
        ms.away_shots,
        ms.home_xg,
        ms.away_xg,
        ms.home_yellows,
        ms.away_yellows,
        ms.home_fouls,
        ms.away_fouls

    from matches m
    left join match_stats ms
        on m.match_id = ms.match_id
)

select * from final