with matches as (
    select * from {{ ref('int_match_results_enriched') }}
),

final as (
    select
        m.matchweek,                                -- ← added m. prefix

        -- volume
        count(m.match_id)                               as total_matches,
        sum(m.home_goals + m.away_goals)                as total_goals,
        round(avg(m.home_goals + m.away_goals), 2)      as avg_goals_per_match,

        -- results breakdown
        count(case when m.match_result = 'home_win' then 1 end)   as home_wins,
        count(case when m.match_result = 'away_win' then 1 end)   as away_wins,
        count(case when m.match_result = 'draw'     then 1 end)   as draws,

        -- clean sheets
        sum(case when m.home_clean_sheet then 1 else 0 end)       as home_clean_sheets,
        sum(case when m.away_clean_sheet then 1 else 0 end)       as away_clean_sheets,

        -- high scoring
        count(case when m.is_high_scoring then 1 end)             as high_scoring_matches,

        -- xG
        round(avg(ms.home_xg + ms.away_xg), 2)         as avg_total_xg,

        -- cards & fouls
        sum(ms.home_yellows + ms.away_yellows)          as total_yellows,
        sum(ms.home_fouls + ms.away_fouls)              as total_fouls

    from matches m
    left join {{ ref('int_match_stats_enriched') }} ms
        on m.match_id = ms.match_id

    group by m.matchweek
    order by m.matchweek
)

select * from final