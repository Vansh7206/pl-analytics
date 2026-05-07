import pandas as pd
import numpy as np
import random
from itertools import permutations
from datetime import date, timedelta

random.seed(42)
np.random.seed(42)

# ─────────────────────────────────────────
# 1. RAW TEAMS
# ─────────────────────────────────────────

teams_data = [
    (1,  "Arsenal",           "London",     "Emirates Stadium",       1886, "Mikel Arteta"),
    (2,  "Aston Villa",       "Birmingham", "Villa Park",             1874, "Unai Emery"),
    (3,  "Brentford",         "London",     "Gtech Community Stadium",1889, "Thomas Frank"),
    (4,  "Brighton",          "Brighton",   "Amex Stadium",           1901, "Roberto De Zerbi"),
    (5,  "Burnley",           "Burnley",    "Turf Moor",              1882, "Vincent Kompany"),
    (6,  "Chelsea",           "London",     "Stamford Bridge",        1905, "Mauricio Pochettino"),
    (7,  "Crystal Palace",    "London",     "Selhurst Park",          1905, "Oliver Glasner"),
    (8,  "Everton",           "Liverpool",  "Goodison Park",          1878, "Sean Dyche"),
    (9,  "Fulham",            "London",     "Craven Cottage",         1879, "Marco Silva"),
    (10, "Liverpool",         "Liverpool",  "Anfield",                1892, "Jurgen Klopp"),
    (11, "Luton Town",        "Luton",      "Kenilworth Road",        1885, "Rob Edwards"),
    (12, "Manchester City",   "Manchester", "Etihad Stadium",         1880, "Pep Guardiola"),
    (13, "Manchester United", "Manchester", "Old Trafford",           1878, "Erik ten Hag"),
    (14, "Newcastle United",  "Newcastle",  "St. James Park",         1892, "Eddie Howe"),
    (15, "Nottm Forest",      "Nottingham", "City Ground",            1865, "Nuno Espirito Santo"),
    (16, "Sheffield United",  "Sheffield",  "Bramall Lane",           1889, "Chris Wilder"),
    (17, "Tottenham",         "London",     "Tottenham Hotspur Stadium",1882,"Ange Postecoglou"),
    (18, "West Ham",          "London",     "London Stadium",         1895, "David Moyes"),
    (19, "Wolves",            "Wolverhampton","Molineux",             1877, "Gary O'Neil"),
    (20, "Bournemouth",       "Bournemouth","Vitality Stadium",       1899, "Andoni Iraola"),
]

raw_teams = pd.DataFrame(teams_data, columns=[
    "team_id", "team_name", "city", "stadium", "founded_year", "manager"
])

# ─────────────────────────────────────────
# 2. RAW PLAYERS
# ─────────────────────────────────────────

positions = ["GK", "DEF", "MID", "FWD"]
position_weights = [0.08, 0.35, 0.35, 0.22]  # roughly realistic squad distribution

first_names = [
    "James", "Oliver", "Harry", "Jack", "George", "Noah", "Charlie", "Liam",
    "Mason", "Ethan", "Lucas", "Oscar", "Archie", "Leo", "Henry", "Kai",
    "Raheem", "Marcus", "Declan", "Trent", "Jordan", "Callum", "Jude", "Phil",
    "Ben", "Aaron", "Reece", "Kyle", "John", "Ivan", "Pedro", "Luis",
    "Carlos", "Ahmed", "Samir", "Riyad", "Youri", "Wilfried", "Ilkay", "Bruno"
]

last_names = [
    "Smith", "Jones", "Williams", "Taylor", "Brown", "Davies", "Evans", "Wilson",
    "Thomas", "Roberts", "Johnson", "White", "Walker", "Hall", "Allen", "Young",
    "Hernandez", "Silva", "Martinez", "Garcia", "Rodriguez", "Lopez", "Perez",
    "Sanchez", "Diaz", "Torres", "Fernandez", "Gomez", "Castro", "Reyes",
    "Muller", "Schmidt", "Fischer", "Weber", "Hoffmann", "Becker", "Klein",
    "Mbeki", "Diallo", "Traore", "Kone", "Toure", "Camara", "Coulibaly"
]

nationalities = [
    "English", "French", "Spanish", "German", "Brazilian", "Argentine",
    "Portuguese", "Dutch", "Belgian", "Nigerian", "Senegalese", "Ivorian",
    "Moroccan", "Danish", "Norwegian", "Swedish", "Polish", "Croatian"
]

players = []
player_id = 1

for team_id in range(1, 21):
    for _ in range(25):
        fname = random.choice(first_names)
        lname = random.choice(last_names)
        pos = random.choices(positions, weights=position_weights)[0]
        age = random.randint(17, 36)
        nat = random.choice(nationalities)
        players.append((player_id, team_id, f"{fname} {lname}", pos, age, nat))
        player_id += 1

raw_players = pd.DataFrame(players, columns=[
    "player_id", "team_id", "name", "position", "age", "nationality"
])

# ─────────────────────────────────────────
# 3. RAW MATCHES
# ─────────────────────────────────────────

# Every team plays every other team home and away = 380 matches
team_ids = list(range(1, 21))

# Build all home-away pairs (each ordered pair = one fixture)
all_fixtures = [(h, a) for h in team_ids for a in team_ids if h != a]
# That gives 380 fixtures

# Shuffle and assign matchweeks
# Each matchweek has 10 matches (20 teams / 2)
random.shuffle(all_fixtures)

referees = [
    "Michael Oliver", "Anthony Taylor", "Stuart Attwell", "Craig Pawson",
    "Simon Hooper", "John Brooks", "Paul Tierney", "David Coote",
    "Chris Kavanagh", "Jarrod Gillett"
]

season_start = date(2023, 8, 12)

matches = []
match_id = 1

for matchweek in range(1, 39):  # 38 matchweeks
    week_fixtures = all_fixtures[(matchweek - 1) * 10: matchweek * 10]
    match_date = season_start + timedelta(weeks=matchweek - 1)

    for home_team_id, away_team_id in week_fixtures:
        home_goals = int(np.random.poisson(1.4))
        away_goals = int(np.random.poisson(1.1))

        # Referee — intentionally null a few
        if match_id in [45, 180]:
            referee = None
        else:
            referee = random.choice(referees)

        home_stadium = raw_teams.loc[raw_teams["team_id"] == home_team_id, "stadium"].values[0]

        matches.append((
            match_id, matchweek, match_date.isoformat(),
            home_team_id, away_team_id,
            home_goals, away_goals,
            home_stadium, referee
        ))
        match_id += 1

raw_matches = pd.DataFrame(matches, columns=[
    "match_id", "matchweek", "match_date",
    "home_team_id", "away_team_id",
    "home_goals", "away_goals",
    "stadium", "referee"
])

# Intentional mess #1 — duplicate one match row
duplicate_row = raw_matches[raw_matches["match_id"] == 100].copy()
raw_matches = pd.concat([raw_matches, duplicate_row], ignore_index=True)

# Intentional mess #2 — one negative goals value
raw_matches.loc[raw_matches["match_id"] == 200, "home_goals"] = -1

# ─────────────────────────────────────────
# 4. RAW MATCH STATS
# ─────────────────────────────────────────

# Stats correlated loosely with actual goals so data feels plausible
match_stats = []

for _, row in raw_matches[raw_matches["match_id"].duplicated(keep="first") == False].iterrows():
    mid = row["match_id"]
    hg = max(row["home_goals"], 0)  # treat -1 as 0 for stat generation
    ag = row["away_goals"]

    # Possession: home slight advantage baseline
    home_poss = round(np.clip(np.random.normal(52, 8), 35, 70), 1)
    away_poss = round(100 - home_poss, 1)

    # Shots: more possession = more shots (roughly)
    home_shots = max(int(np.random.normal(12 + (home_poss - 50) * 0.3, 3)), 2)
    away_shots = max(int(np.random.normal(10 + (away_poss - 50) * 0.3, 3)), 1)

    # xG: correlated with shots and goals
    home_xg = round(max(np.random.normal(hg * 0.6 + home_shots * 0.08, 0.3), 0.1), 2)
    away_xg = round(max(np.random.normal(ag * 0.6 + away_shots * 0.08, 0.3), 0.1), 2)

    home_fouls  = random.randint(8, 18)
    away_fouls  = random.randint(8, 18)
    home_yellows = random.randint(0, 4)
    away_yellows = random.randint(0, 4)

    match_stats.append((
        mid,
        home_xg, away_xg,
        home_shots, away_shots,
        home_poss, away_poss,
        home_fouls, away_fouls,
        home_yellows, away_yellows
    ))

raw_match_stats = pd.DataFrame(match_stats, columns=[
    "match_id",
    "home_xg", "away_xg",
    "home_shots", "away_shots",
    "home_possession", "away_possession",
    "home_fouls", "away_fouls",
    "home_yellows", "away_yellows"
])

# ─────────────────────────────────────────
# 5. EXPORT
# ─────────────────────────────────────────

raw_teams.to_csv("data/raw_teams.csv", index=False)
raw_players.to_csv("data/raw_players.csv", index=False)
raw_matches.to_csv("data/raw_matches.csv", index=False)
raw_match_stats.to_csv("data/raw_match_stats.csv", index=False)

print("✅ raw_teams.csv      →", len(raw_teams), "rows")
print("✅ raw_players.csv    →", len(raw_players), "rows")
print("✅ raw_matches.csv    →", len(raw_matches), "rows  (includes 1 duplicate + 1 negative goals)")
print("✅ raw_match_stats.csv→", len(raw_match_stats), "rows")
print("\nIntentional messiness injected:")
print("  • match_id 45 and 180 → referee = NULL")
print("  • match_id 100        → duplicate row")
print("  • match_id 200        → home_goals = -1")