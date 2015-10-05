#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo $'Usage:\n  ./import_production_data.sh /path/to/production/export/folder/'
else
    authors="$1Local_Author_Table.csv";
    corporate="$1Local_Corporate_Name_Table.csv";
    venues="$1Local_Location_Table.csv";
    person_alias="$1Local_Person_Alias_Table.csv";
    person="$1Local_Production_Table.csv";
    production="$1Local_Production_Table.csv";
    assignment="$1Copy_Of_Production_Assignment_Table.csv";
    roles="$1Local_Role_Table.csv";
    year="$1Local_Year_Table.csv";
    rake production_credits:import_data[$authors,$corporate,$venues,$person_alias,$person,$production,$assignment,$roles,$year];
fi
