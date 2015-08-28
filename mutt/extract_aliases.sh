#!/bin/sh

ALIASES=$HOME/.mutt/aliases
MESSAGE=$(cat)

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

if ! grep -Fxq "$NEWALIAS" $ALIASES; then
  echo "$NEWALIAS" >> $ALIASES
fi

echo "${MESSAGE}"
