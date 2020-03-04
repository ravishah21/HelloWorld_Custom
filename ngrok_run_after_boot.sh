##! /bin/sh
ngrok start --all \
  --log=stdout \
  > ./ngrok.log &
