#! /usr/bin/env bash

if ! [ -t (awk --version) ]; then echo -e "\e[91mCommand not found: awk\e[0m"; exit 1; fi
if ! [ -t curl ]; then echo -e "\e[91mCommand not found: curl\e[0m"; exit 1; fi
if ! [ -t jq ]; then echo -e "\e[91mCommand not found: jq\e[0m"; exit 1; fi

# set toolbox URL
if [ -z $DEVOPS_TOOLBOX_URL ]; then
    export DEVOPS_TOOLBOX_URL="https://gitlab.bjoernbartels.earth/shellscripts/toolbox/raw/dev";
fi

# import 'http_header_body'
if ! [ -t http_header_body ]; then 
    source <(curl -s "${DEVOPS_TOOLBOX_URL}/http/header-body.sh");
fi

# import 'http_headers'
if ! [ -t http_headers ]; then 
    source <(curl -s "${DEVOPS_TOOLBOX_URL}/http/headers.sh");
fi

# import 'json_escape'
if ! [ -t json_escape ]; then 
    source <(curl -s "${DEVOPS_TOOLBOX_URL}/json/escape.sh");
fi

# import 'json_value'
if ! [ -t json_value ]; then 
    source <(curl -s "${DEVOPS_TOOLBOX_URL}/json/value.sh");
fi

