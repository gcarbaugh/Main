
# Load Libraries
import os
from kenpompy.utils import login
import kenpompy.summary as kp
import pandas as pd

# Read in keychain for log-in creds
df = pd.read_csv('C:/Users/carba/Documents/Projects/keychain/keychain.csv',sep=',',header=0)
df = df[df['site'] == 'kenpom']
# Connect to browser
browser = login(df['your_email'].to_list(), df['your_password'].to_list())


eff_stats = kp.get_efficiency(browser)

# `kp.` will return the first ribbons efficiency, four factors, player stats, point distribution, heighy, 
df1 = kp.get_efficiency(browser,2024)

# List of the last 5 seasons
start_year = 2024
seasons = [start_year, start_year-1, start_year-2, start_year-3, start_year-4]

# Initialize an empty DataFrame
all_team_stats = pd.DataFrame()

# Loop through each season and fetch team stats
for year in seasons:
    # Fetch team stats for the current season
    team_stats = kp.get_teamstats(browser, year)
    # Add the season column for reference
    team_stats['season'] = year
    # Append the current season's stats to the combined DataFrame
    all_team_stats = pd.concat([all_team_stats, team_stats], ignore_index=True)



kp.get_playerstats(broi)

# Loop through each season and fetch team stats
all_player_stats = pd.DataFrame()
for year in seasons:
    # Fetch team stats for the current season
    team_stats = kp.get_playerstats(browser, year)
    # Add the season column for reference
    team_stats['season'] = year
    # Append the current season's stats to the combined DataFrame
    all_player_stats = pd.concat([all_player_stats, team_stats], ignore_index=True)


all_player_stats.sort_values(by='Team')
