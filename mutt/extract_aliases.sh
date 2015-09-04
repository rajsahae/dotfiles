#!/bin/bash

ALIASES=$HOME/.mutt/aliases
MESSAGE=$(cat)

function finish() {
  echo "${MESSAGE}"
  exit 0
}

NEWALIAS=$( \
  echo "${MESSAGE}" | \
  grep ^"From: " |    \
  sed s/[\,\"\']//g | \
  awk '{
    $1="";
    if (NF == 3)
      {print "alias" $0;}
    else if (NF == 2)
      {print "alias" $0 $0;}
    else if (NF > 3)
      {print "alias", tolower($2)"-"tolower($(NF-1)) $0;}
  }'
)

# Skip any new alias that doesn't contain the @ symbol
if [[ ! "$NEWALIAS" =~ "@" ]]; then
  finish
fi

# Skip any address that matches a blacklist item
read -r -d '' BLACKLIST <<-'EOL'
(JIRA) administrator frontapp.com stashprd eat24 cnn-news
gameknot AmericanExpress noreply Taj rollup unroll.me brandyourself Newsletter
splunk HipChat NoReply Scheduler no-reply
EOL

for match in $BLACKLIST; do
  if [[ "$NEWALIAS" =~ "$match" ]]; then
    finish
  fi
done

# Add it if it's not already in the aliases file
if ! grep -Fxq "$NEWALIAS" $ALIASES; then
  echo "$NEWALIAS" >> $ALIASES
fi

finish
