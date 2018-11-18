#! /usr/bin/env bash
###/*
# escape string for to be used in JSON
#
# ```
# escaped_str=`json_escape <custom-string>`
# ```
#
# @param {string} custom-string string to encode
#
# @returns {string} a JSON encoded string
#
# @uses python(sys,json)
#
###*/

json_escape () {
    printf '%s' "$1" | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

