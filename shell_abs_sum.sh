#!/bin/bash

# Read input numbers into an array
read -p "Insert a list of numbers" -a numbers

# Initialize sum variable
sum=0

# Iterate over the array elements using a for loop
for number in "${numbers[@]}"; do
    # Check if the input is an integer
    if [[ "$number" =~ ^-?[0-9]+$ ]]; then
        # Calculate the absolute value and add it to the sum
        absolute_value=${number#-}
        (( sum += absolute_value ))
    fi
done

# Print the sum of absolute values
echo "$sum"

