-- This file is for combining match stats with matches, goals have been eliminated in join as they are already done in match results
with match_stats as (
    select * from {{ ref("stg_match_stats") }}
),

matches as (
    select * from {{ ref("stg_matches") }}
),

enriched as (
    select
        s.match_id,
        m.matchweek,
        m.match_date,
        m.home_team_id,
        m.away_team_id,
        s.home_xg,
        s.away_xg,
        s.home_shots,
        s.away_shots,
        s.home_possession,
        s.away_possession,
        s.home_fouls,
        s.away_fouls,
        s.home_yellows,
        s.away_yellows
    from match_stats s
    left join matches m on s.match_id = m.match_id
)

select * from enriched