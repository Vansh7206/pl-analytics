with enriched as (
    select * from {{ ref('int_match_results_enriched') }}
),

team_match_points as (

    select
        '2023-24'       as season,
        matchweek,                  -- was: gameweek
        match_date,
        home_team_id    as team_id,
        home_points     as points,
        home_goals      as goals_scored,
        away_goals      as goals_conceded,
        home_goal_diff  as goal_difference
    from enriched

    union all

    select
        '2023-24'       as season,
        matchweek,                  -- was: gameweek
        match_date,
        away_team_id    as team_id,
        away_points     as points,
        away_goals      as goals_scored,
        home_goals      as goals_conceded,
        away_goal_diff  as goal_difference
    from enriched
),

running_totals as (
    select
        season,
        matchweek,                  -- was: gameweek
        match_date,
        team_id,
        points,
        goals_scored,
        goals_conceded,
        goal_difference,

        sum(points) over (
            partition by season, team_id
            order by matchweek      -- was: gameweek
            rows between unbounded preceding and current row
        )                                           as cumulative_points,

        sum(goals_scored) over (
            partition by season, team_id
            order by matchweek      -- was: gameweek
            rows between unbounded preceding and current row
        )                                           as cumulative_goals_scored,

        sum(goal_difference) over (
            partition by season, team_id
            order by matchweek      -- was: gameweek
            rows between unbounded preceding and current row
        )                                           as cumulative_goal_difference,

        row_number() over (
            partition by season, team_id
            order by matchweek      -- was: gameweek
        )                                           as matches_played

    from team_match_points
),

with_position as (
    select
        *,
        rank() over (
            partition by season, matchweek      -- was: gameweek
            order by cumulative_points desc,
                     cumulative_goal_difference desc,
                     cumulative_goals_scored desc
        )                                           as league_position
    from running_totals
)

select * from with_position
order by matchweek, league_position             -- was: gameweek