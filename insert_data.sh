#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.


echo "$($PSQL "TRUNCATE TABLE teams,games")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

do
  if [[ $YEAR != 'year' ]]
  then
    
    # get winner id
    WINNERID="$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")"

    if [[ -z $WINNERID ]]
    then
 
      # if not insert new
      INSERTWINNER="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"

      if [[ $INSERTWINNER == "INSERT 0 1" ]]
      then
        echo "INSERT TEAM $INNER"
        WINNERID="$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")"
      fi

    fi
    # echo "winid:$WINNERID"


    # get opponent id
    OPPOID="$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")"

    if [[ -z $OPPOID ]]
    then
      # if not insert new
      INSERTOPPO="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"

      if [[ $INSERTOPPO == "INSERT 0 1" ]]
      then
        echo "INSERT OPPO $OPPONENT"
        OPPOID="$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")"
      fi

    fi
    # echo "oppoID:$OPPOID"

    # insert games
    # echo "$YEAR,$ROUND,$WINNERID,$OPPOID,$WINNER_GOALS,$OPPONENT_GOALS"
    INSERTGAME="$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNERID,$OPPOID,$WINNER_GOALS,$OPPONENT_GOALS) ")"

    if [[ $INSERTGAME == "INSERT 0 1" ]]
    then
      echo "insert game item $YEAR,$ROUND"
    fi

  fi
done