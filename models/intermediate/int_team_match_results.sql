-- So here we are starting to create first model of creating teams alongs with matches so for that we are joining team along with its matches. Every team plays each other twice, so there is home team and away team

with matches as (                   --matches data 381 rows one each team playing twice
    select * from {{ ref('stg_matches') }}
),

teams as (                          --team data its name is most imp
    select * from {{ ref('stg_teams') }}
),
home as (                           --Home team perspective
    select
        m.match_id,
        m.matchweek,
        m.match_date,
        m.home_team_id                          as team_id,
        t.team_name,
        m.home_goals                            as goals_for,
        m.away_goals                            as goals_against,
        'home'                                  as venue,
        case
            when m.home_goals > m.away_goals then 'W'
            when m.home_goals = m.away_goals then 'D'
            else 'L'
        end                                     as result

    from matches m
    left join teams t on m.home_team_id = t.team_id
),
away as (                   --away team perspective
    select
        m.match_id,
        m.matchweek,
        m.match_date,
        m.away_team_id                          as team_id,
        t.team_name,
        m.away_goals                            as goals_for,
        m.home_goals                            as goals_against,
        'away'                                  as venue,
        case
            when m.away_goals > m.home_goals then 'W'
            when m.away_goals = m.home_goals then 'D'
            else 'L'
        end                                     as result

    from matches m
    left join teams t on m.away_team_id = t.team_id
)
--joining both
select * from home
union all
select * from away
