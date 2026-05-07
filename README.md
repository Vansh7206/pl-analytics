# ⚽ Premier League Analytics Pipeline

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![AWS S3](https://img.shields.io/badge/AWS%20S3-232F3E?style=for-the-badge&logo=amazonaws&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)
![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

Production-style data engineering pipeline built on synthetic Premier League 2023/24 data.

This project simulates how modern analytics teams structure data workflows using:
- Cloud storage
- Data warehousing
- Layered transformations
- Data quality testing
- BI dashboards

---

# 🚀 Project Overview

The pipeline ingests raw football data into AWS S3, loads it into Snowflake, transforms it using dbt’s layered architecture, and serves analytical models to Power BI dashboards.

## Pipeline Flow

```text
Python → AWS S3 → Snowflake → dbt → Power BI
```

---

# 🏗️ Architecture

## Data Pipeline

- Synthetic data generated using Python
- Raw CSVs stored in AWS S3
- Snowflake used as the cloud warehouse
- dbt handles transformations and testing
- Power BI consumes mart models for analytics

---

# 📦 Tech Stack

| Layer | Tool |
|---|---|
| Data Generation | Python, Pandas, Faker |
| Cloud Storage | AWS S3 |
| Data Warehouse | Snowflake |
| Transformation | dbt Core |
| Visualization | Power BI |

---

# 🧱 dbt Architecture

The project follows a 4-layer medallion architecture.

## 1️⃣ Staging Layer (`stg_*`)
Light cleaning and standardization of raw Snowflake tables.

### Models
- `stg_matches`
- `stg_match_stats`
- `stg_teams`
- `stg_players`

---

## 2️⃣ Intermediate Layer (`int_*`)
Business logic, joins, and enrichments.

### Models
- `int_match_stats_enriched`
- `int_match_results_enriched`
- `int_team_match_results`
- `int_player_profiles`
- `int_squad_composition`

---

## 3️⃣ Core Layer (`fct_*`, `dim_*`)
Central analytical models used across dashboards.

### Fact Models
- `fct_team_performance`
- `fct_season_standings`
- `fct_home_away_performance`
- `fct_title_race`

### Dimension Models
- `dim_teams`

---

## 4️⃣ Mart Layer (`mart_*`)
Dashboard-ready aggregated outputs.

### Models
- `mart_matchweek_summary`
- `mart_squad_analysis`

---

# 🧪 Data Quality Testing

dbt tests ensure data reliability across the pipeline.

## Tests Implemented
- Not null tests
- Unique tests
- Accepted values tests
- Foreign key validation
- Custom singular tests

## Example Custom Test
`assert_points_calculation`

Validates:
- Win = 3 points
- Draw = 1 point
- Loss = 0 points

---

# 📊 Power BI Dashboards

## 🏆 Season Standings
- Full league table
- Goal difference rankings
- League-wide KPIs

## 📈 Title Race Analysis
- Cumulative points progression
- League position tracking
- Matchweek-by-matchweek title race

## ⚡ Team Performance
- xG vs actual goals
- Home vs away performance
- Possession and shots analysis

## 📅 Matchweek Trends
- Goals by matchweek
- Average xG trends
- Yellow cards analysis
- Home vs away win trends

## 👥 Squad Analysis
- Squad age profile
- Nationality diversity
- Manager overview
- Team composition insights

---

# 🗃️ Snowflake Configuration

```yaml
Database: FOOTBALL_DB
Raw Schema: football_raw
dbt Schema: dbt_dev
Warehouse: FOOTBALL_WH
```

---

# 📂 Source Tables

| Table | Description |
|---|---|
| `matches` | Fixtures, scores, dates, matchweek |
| `match_stats` | xG, shots, possession, cards |
| `teams` | Club metadata and managers |
| `players` | Player profiles and nationalities |

---

# ⚙️ Setup Instructions

## Clone Repository

```bash
git clone https://github.com/Vansh7206/pl-analytics.git
cd pl-analytics
```

## Install Dependencies

```bash
pip install dbt-snowflake
```

## Install dbt Packages

```bash
dbt deps
```

## Run Models

```bash
dbt run
```

## Run Tests

```bash
dbt test
```

## Generate Documentation

```bash
dbt docs generate
dbt docs serve
```

---

# 📁 Project Structure

```text
pl-analytics/
├── models/
│   ├── staging/
│   ├── intermediate/
│   └── marts/
│       ├── core/
│       └── reporting/
├── tests/
├── macros/
├── seeds/
├── analyses/
├── dbt_project.yml
└── README.md
```

---

# 💡 Why This Project?

Most football projects focus only on dashboards.

This project focuses on the complete analytics engineering lifecycle:
- Data ingestion
- Warehouse modeling
- Transformation pipelines
- Data testing
- BI-ready marts

The goal was to build a production-style analytics workflow rather than just visualizations.

---

# 🔗 DAG Lineage

Add your dbt DAG screenshot here:

```text
assets/lineage_dag.png
```

---

# 👨‍💻 Author

### Vansh Chandan
BCA Student — K.J. Somaiya Institute of Technology, Mumbai

- Building projects in Data Engineering & Analytics
- Exploring dbt, Snowflake, ML, and scalable data systems

## Connect With Me

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=flat&logo=linkedin)](https://linkedin.com/in/vansh7206)

[![GitHub](https://img.shields.io/badge/GitHub-Vansh7206-black?style=flat&logo=github)](https://github.com/Vansh7206)

---

# ⭐ Future Improvements

- Airflow orchestration
- Incremental dbt models
- CI/CD integration
- Real football API ingestion
- Automated dashboard refreshes

---

## Built with Python • Snowflake • dbt • AWS S3 • Power BI