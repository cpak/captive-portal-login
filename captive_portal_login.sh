
# on start, check access by curling http://captive.apple.com/hotspot-detect.html
# /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport

AIRPORT_TOOL=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport
TEST_URL="http://captive.apple.com/hotspot-detect.html"
SUCCESS_REGEX="<HTML><HEAD><TITLE>Success"
SSID_REGEX=" SSID: ([a-zA-Z0-9_-]+)"

SSID=$1
USERNAME=$2
PASSWORD=$3

# Logs $1 to Console app
log() {
    syslog -s -k Facility com.apple.console \
        Level Notice \
        Sender CaptivePortalLogin \
        Message "$1"
}

# Gets current wifi network name, if any
get_SSID() {
    local AP_STATUS=$($AIRPORT_TOOL -I)
    local CURRENT_SSID
    if [[ $AP_STATUS =~ $SSID_REGEX ]]
    then
        CURRENT_SSID=${BASH_REMATCH[1]}
        echo "$CURRENT_SSID"
    else
        echo "No SSID in airport status output"
    fi  
}

# Checks internet connection by curling Apples test page
has_internet_access() {
    local RES=$(curl -s $TEST_URL)
    if [[ $RES =~ $SUCCESS_REGEX ]]
    then
        return 0
    else
        return 1
    fi  
}

# POSTs the login request
login() {
    log 'Attempting login...'

    # TODO make requst more generic and remove extraneous params

    curl 'https://1.1.1.1/login.html' \
        -H 'Origin: https://1.1.1.1' \
        -H 'Accept-Encoding: gzip, deflate, br' \
        -H 'Accept-Language: en-GB,en;q=0.8,en-US;q=0.6,sv;q=0.4' \
        -H 'Upgrade-Insecure-Requests: 1' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
        -H 'Cache-Control: max-age=0' \
        -H 'Referer: https://1.1.1.1/login.html?redirect=1.1.1.1/' \
        -H 'Connection: keep-alive' \
        --data "buttonClicked=4&err_flag=0&err_msg=&info_flag=0&info_msg=&redirect_url=http%3A%2F%2F1.1.1.1%2F&network_name=Guest+Network&username=$USERNAME&password=$PASSWORD" --compressed --insecure

}

main () {
    if [[ $(get_SSID) == $SSID  ]]
    then
        log "On $SSID"
        if has_internet_access;
        then
            log "Has teh interwebz!!1"
        else
            login
        fi
    else
        log "Not on $SSID. Nothing to do."
    fi
}

# TODO build a sane polling loop
#while :; do
#    main
#    sleep 5
#done

main

