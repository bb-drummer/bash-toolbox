#! /usr/bin/env bash
###/*
# retrieve value from JSON encoded data (string)
#
# ```
# json_value <jq-json-var-name> <JSON-data>
# ```
#
# @param {string} JSON-string JSON data string
# @param {string} jq-json-var-name 'jq' formated key name to retrieve
#
# @returns {mixed} a value for the corresponding key or NULL
#
# @uses jq
# @deprecated @uses python(sys,json)
#
###*/

json_value () {

    echo `printf '%s' "$2" | jq --raw-output "$1"`;

}

