# ⚽ Premier League Analytics Pipeline

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![AWS S3](https://img.shields.io/badge/AWS%20S3-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)
![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

> A production-style analytics engineering pipeline built on synthetic Premier League 2023/24 data — covering the full lifecycle from raw ingestion to BI-ready dashboards.

Most football analytics projects stop at visualizations. This one starts where they end.

---

## 🔁 Pipeline Overview

```
Python (Synthetic Data) → AWS S3 → Snowflake → dbt (4-layer) → Power BI
```

**20 dbt models** across 4 layers. **5 Power BI dashboards**. End-to-end tested with custom data quality checks.

---

## 🏗️ Architecture

### Why this stack?

| Layer | Tool | Role |
|---|---|---|
| Data Generation | Python, Pandas, Faker | Synthetic PL 2023/24 data |
| Cloud Storage | AWS S3 | Raw CSV landing zone |
| Data Warehouse | Snowflake | Centralized analytical store |
| Transformation | dbt Core | Layered modeling + testing |
| Visualization | Power BI | Dashboard consumption |

This mirrors how real analytics engineering teams structure modern data platforms — S3 as a data lake, Snowflake as the warehouse, dbt handling all transformation logic with version control and lineage.

---

## 🧱 dbt Modeling Architecture

The project follows a strict 4-layer medallion architecture. Every model has a defined role — nothing is ad hoc.

### Layer 1 — Staging (`stg_*`)
Light cleaning, type casting, and column renaming on top of raw Snowflake tables. No business logic.

| Model | Source |
|---|---|
| `stg_matches` | `raw.matches` |
| `stg_match_stats` | `raw.match_stats` |
| `stg_teams` | `raw.teams` |
| `stg_players` | `raw.players` |

### Layer 2 — Intermediate (`int_*`)
Business logic, joins, and enrichments. This is where raw facts become meaningful entities.

- `int_match_stats_enriched` — xG, shots, possession joined to match context
- `int_match_results_enriched` — Results with home/away outcome logic
- `int_team_match_results` — Per-team, per-match result records
- `int_player_profiles` — Player metadata with team context
- `int_squad_composition` — Squad-level aggregations

### Layer 3 — Core (`fct_*`, `dim_*`)
Central analytical models that power all dashboards. Stable, tested, reusable.

**Facts**
- `fct_team_performance` — Season-wide performance metrics per team
- `fct_season_standings` — Full league table with points, GD, position
- `fct_home_away_performance` — Split performance by venue
- `fct_title_race` — Cumulative points progression by matchweek

**Dimensions**
- `dim_teams` — Club metadata, managers, identity

### Layer 4 — Marts (`mart_*`)
Dashboard-ready, pre-aggregated outputs. Consumed directly by Power BI.

- `mart_matchweek_summary` — Matchweek-level trends (goals, xG, cards)
- `mart_squad_analysis` — Squad profiles for age, nationality, composition

---

## 🔗 DAG Lineage

![DAG Lineage](assets/lineage_dag.png)

The lineage DAG shows full traceability from `raw.*` source tables through to mart models — a key part of making this pipeline auditable and maintainable.

---

## 🧪 Data Quality Testing

Every model is covered. Tests run as part of the `dbt test` pipeline.

**Built-in dbt tests applied across models:**
- `not_null` — Critical fields never empty
- `unique` — Primary keys are deduplicated
- `accepted_values` — Categorical fields stay within bounds
- `relationships` — Foreign key integrity across layers

**Custom singular test — `assert_points_calculation`**

Validates that the points logic is correct across every match result:

```sql
-- Win = 3pts, Draw = 1pt, Loss = 0pts
-- Fails if any row breaks this rule
```

This isn't just defensive testing — it's documenting business logic as code.

---

## 📊 Power BI Dashboards

Five dashboards, each serving a distinct analytical question.

| Dashboard | Key Metrics |
|---|---|
| 🏆 Season Standings | League table, goal difference, KPIs |
| 📈 Title Race | Cumulative points, position by matchweek |
| ⚡ Team Performance | xG vs actual goals, home/away split, possession |
| 📅 Matchweek Trends | Goals, xG, yellow cards, win trends over time |
| 👥 Squad Analysis | Age profile, nationality diversity, manager overview |

---

## 🗃️ Snowflake Configuration

```yaml
Database:   FOOTBALL_DB
Raw Schema: football_raw
dbt Schema: dbt_dev
Warehouse:  FOOTBALL_WH
```

### Source Tables

| Table | Description |
|---|---|
| `matches` | Fixtures, scores, dates, matchweek number |
| `match_stats` | xG, shots, possession, cards per match |
| `teams` | Club metadata and managers |
| `players` | Player profiles and nationalities |

---

## ⚙️ Setup

```bash
# Clone
git clone https://github.com/Vansh7206/pl-analytics.git
cd pl-analytics

# Install dbt
pip install dbt-snowflake

# Install packages
dbt deps

# Run all models
dbt run

# Run tests
dbt test

# Generate + serve docs
dbt docs generate
dbt docs serve
```

---

## 📁 Project Structure

```
pl-analytics/
├── models/
│   ├── staging/           # stg_* models
│   ├── intermediate/      # int_* models
│   └── marts/
│       ├── core/          # fct_* and dim_* models
│       └── reporting/     # mart_* models
├── tests/                 # Custom singular tests
├── macros/
├── seeds/
├── analyses/
├── assets/                # DAG screenshots, dashboard images
├── dbt_project.yml
└── README.md
```

---

## 🚀 Future Improvements

- [ ] Airflow orchestration for scheduled runs
- [ ] Incremental dbt models for large fact tables
- [ ] CI/CD pipeline with dbt Cloud or GitHub Actions
- [ ] Real data ingestion via football API (e.g. football-data.org)
- [ ] Automated Power BI dashboard refresh

---

## 👨‍💻 Author

**Vansh Chandan** 

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/vansh-chandan-875a373a3/)
[![GitHub](https://img.shields.io/badge/GitHub-Vansh7206-black?style=flat&logo=github)](https://github.com/Vansh7206)

---

*Built with Python · AWS S3 · Snowflake · dbt Core · Power BI*