#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#get team 
if [[ $YEAR != "year" ]]
then
  #get winner id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  #if not found
  if [[ -z $WINNER_ID ]]
  then
    #insert winner 
    INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_WINNER_TEAM == "INSERT 0 1" ]] 
      then
        echo -e "\nInserted into Winner, $WINNER"
        fi
#get new winner id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi
#get opponent team id
 OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
#if not found
  if [[ -z $OPPONENT_ID ]]
  then
    #insert opponent
    INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_OPPONENT_TEAM == "INSERT 0 1" ]]
      then
        echo -e "\nInserted into Opponent, $OPPONENT"
      fi
#get new opponent id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
fi
#insert game data
INSERT_GAME_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
if [[ $INSERT_GAME_DATA == "INSERT 0 1" ]]
  then
    echo -e "\nInserted into games, $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS"
    fi
  
  
fi

done
echo -e "\nFinished inserting data"