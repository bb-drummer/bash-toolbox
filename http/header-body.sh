#! /usr/bin/env bash
###/*
# split HTTP header and body from message string
#
# ```
# http_header_body <target-var> <message-string>
# ```
#
# @param {array} target-var variable to store header and body data in
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
    local message header body headers

    # split the HTTP message
    echo "$2" | awk -v bl=1 'bl{bl=0; h=($0 ~ /HTTP\/1/)} /^\r?$/{bl=1} {print $0>(h?"header":"body")}'

    # assign keys and values
    http_headers header_data $(<header)
    $1[header]=$(<header_data)
    $1[body]=$(<body)

}