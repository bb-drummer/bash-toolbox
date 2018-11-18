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
    echo `echo $(<$2) | jq --raw-output '$(<$1)'`;

    # @deprecated 
    # printf '%s' "$2" | python -c 'import json,sys;obj=json.load(sys.stdin);print obj[0]["$1"]'
}

