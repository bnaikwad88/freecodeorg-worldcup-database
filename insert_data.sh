#! /bin/bash

# using if loop to be able to run tests without affecting original database

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

#start by emptying the rows in the tables of the database so we can rerun the file
echo $($PSQL "TRUNCATE TABLE games, teams")


# read the games.csv file using cat and apply a while loop to read row by row
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS


do
  if [[ $WINNER != 'winner' ]]
  then
    WINNER_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_TEAM ]]
    then
      INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_TEAM == 'INSERT 0 1' ]]
      then
        echo Inserted Winner $WINNER
      fi
    fi
  fi


  if [[ $OPPONENT != 'opponent' ]]
  then
    OPPONENT_TEAM=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_TEAM ]]
    then
      INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT_TEAM == 'INSERT 0 1' ]]
      then
        echo Inserted Opponent $OPPONENT
      fi
    fi
  fi
   

  if [[ $YEAR != 'year' ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    
    INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year,round, winner_id, opponent_id,winner_goals, opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")
     echo "Insert success : $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS"
  fi
done
  
