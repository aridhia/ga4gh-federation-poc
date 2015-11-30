#!/usr/bin/env bash

# Defaults
DEFAULT_N_LISTS=3
DEFAULT_M_ITEMS=20
DEFAULT_OUTPUT_FOLDER=/OpenDataArea/tmp-ga4gh-output
DEFAULT_OUTPUT_PREFIX="sample-subset-"

        
if [[ $# < 1 ]]; 
then
    echo "Usage: $0 <Full sample ID list file> [<output folder>] [number of lists (optional)] [number of items per list (optional)]"
    # exit 1
else
    export FULL_SAMPLE_LIST_FILE=$1
    
    echo "# Processing full sample list from \"$FULL_SAMPLE_LIST_FILE\""

    # Optional arguments
    # The output folder
    OUTPUT_FOLDER=${2:-$DEFAULT_OUTPUT_FOLDER}
    # The number of lists
    N_LISTS=${3:-$DEFAULT_N_LISTS}
    # The number of items per list
    M_ITEMS=${4:-$DEFAULT_M_ITEMS}

    echo "# Splitting \"$1\" into $N_LISTS lists of $M_ITEMS items. (Total = $(($N_LISTS * $M_ITEMS)))"
    echo "# Output to $OUTPUT_FOLDER"

    # Take a random subset of the full list 
    read -ra random_selection <<< `sort -R $FULL_SAMPLE_LIST_FILE | head -n $(($N_LISTS * $M_ITEMS))`

    # Distribute it into $N_LISTS
    
    for (( list=0; list<$N_LISTS; list++ )); do
        output_file="$OUTPUT_FOLDER/$DEFAULT_OUTPUT_PREFIX$(($list + 1)).txt"
    
        skip=$((($list) * $M_ITEMS))
        echo "# List $(($list + 1)) of $N_LISTS [$M_ITEMS items per list]" > $output_file

        output_file="$OUTPUT_FOLDER/$DEFAULT_OUTPUT_PREFIX$(($list + 1)).txt"
        for (( i=$skip; i<$(($skip + $M_ITEMS)); i++ )); do
            echo "${random_selection[$i]}" >> $output_file
        done
    done
fi