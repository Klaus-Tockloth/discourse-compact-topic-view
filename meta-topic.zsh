#!/bin/zsh
# ------------------------------------
# Purpose:
# - download topic from Discourse forum
# - transform topic into compact view
#
# Remarks:
# - fill in your personal user-api-key
# - github.com/Klaus-Tockloth/discourse-user-api-key
# - change setting for forum with 'your' forum
# ------------------------------------

if [ -z "$1" ]
  then
    echo
    echo "Usage   :  $0" topic
    echo "Example :  $0" 156355
    echo
    exit 1
fi

topic=$1
forum="meta.discourse.org"

topicJSON="$forum-$topic.json"
topicHTML="$forum-$topic.html"

# download topic data from forum
discourse-reader -forum="$forum" -topic="$topic" -output="$topicJSON" -userapikey="dd5acb3a8527b9225fa49af91050ac1c"
if [ $? -ne 0 ]; then
  echo "error: discourse-reader failed"
  exit 1
fi

# transform downloaded JSON data into HTML page
dagote -templates=topic.tmpl -output="$topicHTML" -format=html -dotstring="$topicJSON,$forum" -dottype="csv"
if [ $? -ne 0 ]; then
  echo "error: dagote failed"
  exit 1
fi

# start browser with html page (macOS, Chrome browser)
open -a "Google Chrome" "$topicHTML"
if [ $? -ne 0 ]; then
  echo "error: open browser failed"
  exit 1
fi
