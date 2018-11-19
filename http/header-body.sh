#! /usr/bin/env bash
###/*
# split HTTP header and body from message string
#
# ```
# http_header_body <headers-target-var> <body-target-var> <message-string>
# ```
#
# @param {array} headers-target-var variable to store header data in
# @param {string} body-target-var variable to store body data in
# @param {string} message-string HTTP message string
#
# @returns {array} target-var an associative array with 'header' and 'body' keys
#
# @uses awk
# @uses http_headers
#
###*/

http_header_body () {
    
    unset $1;
    declare -gA $1;
    declare -A response_headers
    body="";

    IFS=$'\r';
    
    head=true

    while read -r line
    do

        if [ $head == "true" ]; then 

            if [[ $line = $'\r' ]] || [[ $line = $'\n' ]] || [[ $line == "\r" ]] || [[ $line == "\n" ]] || [[ $line == "" ]]; then

                head=false

            else
            
                if [[ "$line" =~ ^HTTP(.*)\ ([0-9]{3})\ (.*)$ ]]; then

                    declare -gA $1["Protocol"]="${BASH_REMATCH[1]}";
                    declare -gA $1["Status"]="${BASH_REMATCH[2]}";
                    declare -gA $1["Statustext"]="${BASH_REMATCH[3]}";

                elif [[ $line =~ ^([[:alnum:]_-]+):\ *(( *[^ ]+)*)\ *$ ]]; then

                    declare -gA $1["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}";

                fi

            fi

        else
            
            body="${body}"$(echo -e "${line}");

        fi

    done <<< "$3"

    unset $2;
    declare -g $2="${body}"
    
    unset IFS

}

