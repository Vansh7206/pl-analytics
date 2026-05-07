-- This test fails if any team has incorrect points calculation
-- A win must = 3, draw = 1, loss = 0
-- If this query returns any rows, the test fails

select
    team_id,
    team_name,
    wins,
    draws,
    losses,
    points,
    (wins * 3) + (draws * 1) + (losses * 0) as expected_points

from {{ ref('fct_season_standings') }}

where points != (wins * 3) + (draws * 1) + (losses * 0)