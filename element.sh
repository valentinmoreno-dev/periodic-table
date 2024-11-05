

#!/bin/bash

# Define the PSQL variable
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument was provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Determine if the input is a number or string
if [[ $1 =~ ^[0-9]+$ ]]; then
  # If the input is a number (atomic number)
  QUERY_CONDITION="elements.atomic_number = $1"
else
  # If the input is a string (symbol or name)
  QUERY_CONDITION="elements.symbol = '$1' OR elements.name = '$1'"
fi

# Query the database for element information
ELEMENT_INFO=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number = properties.atomic_number JOIN types ON properties.type_id = types.type_id WHERE $QUERY_CONDITION;")

# Check if the element was found
if [[ -z $ELEMENT_INFO ]]; then
  echo "I could not find that element in the database."
else
  # Parse the result and output the formatted information
  IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT <<< "$ELEMENT_INFO"
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
