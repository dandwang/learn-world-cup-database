#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_FUN(){
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  else
    echo -e "\nWelcome to My Salon, how can I help you?\n"
  fi
  
  SERVICELIST=$($PSQL "SElECT service_id,name from services")

  echo "$SERVICELIST" |  while read SERVICE_ID LINE SERVICE_NAME;
  do
  
    echo  "$SERVICE_ID) $SERVICE_NAME"
  done

  read SERVICE_ID_SELECTED

  if contains_service_id "$SERVICE_ID_SELECTED"; then
   
    SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME="$($PSQL "SELECT name from customers where phone='$CUSTOMER_PHONE'")"
  
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      
      read CUSTOMER_NAME

      CUSTOMER_INSERT=$($PSQL "INSERT INTO customers(name,phone)values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    fi

    echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
    read SERVICE_TIME
    
    CUSTOMER_ID="$($PSQL "SELECT customer_id from customers where phone='$CUSTOMER_PHONE'")"
    

    APPOINTMENTS="$($PSQL "INSERT INTO appointments(customer_id,service_id,time)values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")" 

    # if [[ $APPOINTMENTS == 'INSERT 0 1' ]]
    # then
      
    #   echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED  at $SERVICE_TIME, $CUSTOMER_NAME."
    #   MAIN_FUN
    # fi
    echo -e "\nI have put you down for a $SERVICE_NAME_SELECTED  at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    MAIN_FUN "I could not find that service. What would you like today?"
  fi
}

contains_service_id() {
  local input_id="$1"
  local service_id

  for service_id in $(echo "$SERVICELIST" | awk -F'|' '{print $1}'); do
    if [[ "$service_id" == "$input_id" ]]; then
      return 0 # ID 存在
    fi
  done

  return 1 # ID 不存在
}


MAIN_FUN
