with squad as (
    select * from {{ ref('int_squad_composition') }}
),

players as (
    select * from {{ ref('int_player_profiles') }}
),

-- most common nationality per team
top_nationality as (
    select
        team_id,
        nationality,
        count(*)                                    as nationality_count,
        row_number() over (
            partition by team_id
            order by count(*) desc
        )                                           as rn
    from players
    group by team_id, nationality
),

final as (
    select
        s.team_id,
        s.team_name,
        s.manager,

        -- squad size & positions
        s.squad_size,
        s.num_goalkeepers,
        s.num_defenders,
        s.num_midfielders,
        s.num_forwards,

        -- age
        s.avg_age,
        s.youngest_age,
        s.oldest_age,

        -- age group breakdown
        s.num_young,
        s.num_prime,
        s.num_experienced,
        s.num_veterans,

        -- nationality
        s.num_nationalities,
        tn.nationality                              as most_common_nationality,

        -- derived flags
        case
            when s.avg_age < 25 then 'young squad'
            when s.avg_age between 25 and 28 then 'balanced squad'
            else 'experienced squad'
        end                                         as squad_profile,

        case
            when s.num_nationalities >= 10 then 'highly diverse'
            when s.num_nationalities between 6 and 9 then 'diverse'
            else 'homogeneous'
        end                                         as diversity_label

    from squad s
    left join top_nationality tn
        on s.team_id = tn.team_id
        and tn.rn = 1
)

select * from final