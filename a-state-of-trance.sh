#!/usr/bin/env bash

# script to download latest episode for the radio show A State of Trance by Armin van buuren
# inspired by https://github.com/HuwSy/ASOT-Archive and fixed the issues it had

if [ ! -f ./ASOT.log ]; then
  echo "No Log file, creating New Log"
  echo 0 > ASOT.log
fi

EP=`curl -v --silent http://www.asotarchive.org --stderr - | grep '[/]episode[/][\?]p=[0-9]*' -o | head -n 2 | tail -n 1`
NEWEP=`curl -Ls -o /dev/null -w %{url_effective} http://www.asotarchive.org$EP`
echo $NEWEP
CU=`echo $NEWEP | grep -Eo '[0-9]{1,4}'`
LA=`cat ASOT.log`
echo "Current episode"
echo $CU
echo "Last download"
echo $LA
if [ "$LA" \< "$CU" ]; then
  echo "New download"
  RD=`curl -v --silent $NEWEP --stderr - |  grep download\/asotarchive | sed -n 's/.*href="\([^"]*\).*/\1/p'`
#  echo $RD
  wget -c $RD
  echo $CU > ASOT.log
fi
