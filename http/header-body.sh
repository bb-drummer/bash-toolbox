#! /usr/bin/env bash
###/*
# split HTTP header and body from message string
#
# ```
# http_header_body <headers-target-var> <body-target-var> <message-string>
# ```
#
# @param {array} target-var variable to store header data in
# @param {string} target-var variable to store body data in
# @param {string} message-string HTTP message string
#
# @returns {array} target-var an associative array with 'header' and 'body' keys
#
# @uses awk
# @uses http_headers
#
###*/

http_header_body () {
    
    # (Re)define the specified variable as an associative array.
    unset $1;
    declare -gA $1;
    unset $2;
    declare -gA $2;
    #local message header body headers

    declare -A response_headers=();
    declare response_body="";



    head=true
    headercount=0
    while read -r line; do 


        echo -e "Line: \e[94m$line\e[0m";


        if $head; then 
            if [[ $line = $'\r' ]]; then
                head=false
            else
                HTTP_line='^(.*) ([0-9]{3}) (.*)$';
                #Field_line='^(.*): (.*)$';
                #Field_line='(.*):(.*)';

                #header="$header"$'\n'"$line"
                if [[ "$line" =~ $HTTP_line ]]; then
                if [[ "$line" =~ ^(.*)\ ([0-9]{3})\ (.*)$ ]]; then

                    echo "--header status line-";
                    response_headers+=(["Protocol"]=${BASH_REMATCH[1]});
                    response_headers+=(["Status"]=${BASH_REMATCH[2]});
                    response_headers+=(["Statustext"]=${BASH_REMATCH[3]});

                elif [[ $line =~ ^([[:alnum:]_-]+):\ *(( *[^ ]+)*)\ *$ ]]; then


                    echo "--header field line-";

                    echo -e "Line: \e[96m${BASH_REMATCH[0]}\e[0m";
                    echo -e "Field: \e[96m${BASH_REMATCH[1]}\e[0m";
                    echo -e "Value: \e[96m${BASH_REMATCH[2]}\e[0m";
                    response_headers+=(["${BASH_REMATCH[1]}"]=${BASH_REMATCH[2]});

                fi
            fi
        else
            response_body="$response_body"$'\n'"$line"
        fi

    done < <(echo "$3")

    declare -gA $1=${response_headers}
    declare -g $2=${response_body}

<< ////
    #done < <(printf "%s" "$3")
    #elif [[ "$line" =~ $Field_line ]]; then
////

}

