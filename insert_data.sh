#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Script to insert data from games.csv into worldcup database
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#insert teams
  if [[ $WINNER != "winner" ]]
  then
    # get team_id
    TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'") 

    # if not found
    if [[ -z $TEAM_WINNER_ID ]]
    then
      # set to null
      TEAM_WINNER_ID=null
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    
      #check insert status
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      else
        # print error
        echo Not inserted into teams, $WINNER, already exists
      fi
    fi
  fi

  if [[ $OPPONENT != "opponent" ]]
  then
    # get team_id
    TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'") 

    # if not found
    if [[ -z $TEAM_OPPONENT_ID ]]
    then
      # set to null
      TEAM_OPPONENT_ID=null
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    
      #check insert status
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      else
        # print error
        echo Not inserted into teams, $OPPONENT, already exists
      fi
    fi

#insert games
  if [[ $YEAR != "year" ]]
  then
    # get winner_id and opponent_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #get game_id
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE year=$YEAR and round='$ROUND' and winner_id=$WINNER_ID and opponent_id=$OPPONENT_ID and winner_goals=$WINNER_GOALS and opponent_goals= $OPPONENT_GOALS ") 

    # if not found
    if [[ -z $GAME_ID ]]
    then
      # set to null
      GAME_ID=null
      # insert team
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")  
    
      #check insert status
      if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games
      else
        # print error
        echo Not inserted into teams, record already exists
      fi  
    fi
  fi


  fi


done
