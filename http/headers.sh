#! /usr/bin/env bash
###/*
# parse HTTP headers from string
#
# ```
# http_headers <target-var> <header-string>
# ```
#
# @param {array} target-var variable to store header data in
# @param {string} header-string HTTP header string
#
# @returns {array} target-var an associative array of header keys and values
#
# @see https://stackoverflow.com/a/24961572
#
###*/

http_headers () {

  {
    # (Re)define the specified variable as an associative array.
    unset $1;
    declare -gA $1;
    local line rest

    # Get the first line, assuming HTTP/1.0 or above. Note that these fields
    # have Capitalized names.
    IFS=$' \t\n\r' read $1[Proto] $1[Status] rest
    # Drop the CR from the message, if there was one.
    declare -gA $1[Message]="${rest%$'\r'}"

    # Now read the rest of the headers. 
    while true; do
      # Get rid of the trailing CR if there is one.
      IFS=$'\r' read line rest;
      # Stop when we hit an empty line
      if [[ -z $line ]]; then break; fi
      # Make sure it looks like a header
      # This regex also strips leading and trailing spaces from the value
      if [[ $line =~ ^([[:alnum:]_-]+):\ *(( *[^ ]+)*)\ *$ ]]; then
        # Force the header to lower case, since headers are case-insensitive,
        # and store it into the array
        declare -gA $1[${BASH_REMATCH[1],,}]="${BASH_REMATCH[2]}"
      else
        printf "Ignoring non-header line: %q\n" "$line" >> /dev/stderr
      fi
    done

  } < <(echo "$2")

}
