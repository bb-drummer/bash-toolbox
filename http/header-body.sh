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
    declare -A response_headers
    response_body="";

    IFS=$'\r';
    
    head=true
    body=false

    while read -r line
    do

        echo -e "\nHead: \e[94m$head\e[0m";
        echo -e "Line: \e[94m$line\e[0m";

        if [ $head == "true" ]; then 

            if [[ $line = $'\r' ]] || [[ $line = $'\n' ]] || [[ $line == "\r" ]] || [[ $line == "\n" ]] || [[ $line == "" ]]; then

                head=false

            else
            
                if [[ "$line" =~ ^HTTP(.*)\ ([0-9]{3})\ (.*)$ ]]; then

                    #echo "--header status line-";

                    declare -gA $1["Protocol"]="${BASH_REMATCH[1]}";
                    declare -gA $1["Status"]="${BASH_REMATCH[2]}";
                    declare -gA $1["Statustext"]="${BASH_REMATCH[3]}";

                    #echo -e "Protocol: \e[96m"$$1["Protocol"]"\e[0m";
                    #echo -e "Status: \e[96m"$$1["Statustext"]"\e[0m";
                    #echo -e "Statustext: \e[96m"$$1["Statustext"]"\e[0m";

                elif [[ $line =~ ^([[:alnum:]_-]+):\ *(( *[^ ]+)*)\ *$ ]]; then

                    #echo "--header field line-";

                    #echo -e "Field: \e[96m${BASH_REMATCH[1]}\e[0m";
                    #echo -e "Value: \e[96m${BASH_REMATCH[2]}\e[0m";

                    declare -gA $1["${BASH_REMATCH[1]}"]="${BASH_REMATCH[2]}";

                fi

            fi

        else
            
            #echo -e "--body line-";
            #echo -e "Body line: \e[94m$line\e[0m";
            
            if [[ $body == "true" ]]; then
                response_body="${response_body}\n${line}";
            fi
            
            body=true

        fi

    done <<< "$3"

    echo ${response_body};
    unset $2;
    declare -g $2="${response_body}"
    
    unset IFS

}

