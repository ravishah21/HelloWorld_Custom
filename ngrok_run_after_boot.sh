##! /bin/sh
cd
ngrok start --all \
  --log=stdout \
  > ngrok.log &
