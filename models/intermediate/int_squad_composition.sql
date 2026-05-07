-- Built on top of int_player_profiles
with player_profiles as (
    select * from {{ ref('int_player_profiles') }}
),

final as (
    select
        team_id,
        team_name,
        manager,

        -- squad size
        count(player_id)                                        as squad_size,

        -- position breakdown
        count(case when position = 'GK'  then 1 end)           as num_goalkeepers,
        count(case when position = 'DEF' then 1 end)           as num_defenders,
        count(case when position = 'MID' then 1 end)           as num_midfielders,
        count(case when position = 'FWD' then 1 end)           as num_forwards,

        -- age analysis
        round(avg(age), 1)                                      as avg_age,
        min(age)                                                as youngest_age,
        max(age)                                                as oldest_age,

        -- age group breakdown
        count(case when age_group = 'young'       then 1 end)  as num_young,
        count(case when age_group = 'prime'       then 1 end)  as num_prime,
        count(case when age_group = 'experienced' then 1 end)  as num_experienced,
        count(case when age_group = 'veteran'     then 1 end)  as num_veterans,

        -- nationality diversity
        count(distinct nationality)                             as num_nationalities

    from player_profiles
    group by team_id, team_name, manager
)

select * from final