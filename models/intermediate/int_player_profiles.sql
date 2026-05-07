with players as (
    select * from {{ ref('stg_players') }}
),

teams as (
    select * from {{ ref('stg_teams') }}
),

final as (
    select
        p.player_id,
        p.name,
        p.position,
        p.age,
        p.nationality,
        p.team_id,
        t.team_name,
        t.city,
        t.manager,

        case
            when p.age < 23 then 'young'
            when p.age between 23 and 29 then 'prime'
            when p.age between 30 and 33 then 'experienced'
            else 'veteran'
        end as age_group

    from players p
    left join teams t
        on p.team_id = t.team_id
)

select * from final