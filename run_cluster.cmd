@echo off

if not exist notebook mkdir notebook
if not exist conf\worker mkdir conf\worker
if not exist conf\zeppelin mkdir conf\zeppelin
if not exist conf\master mkdir conf\master
if not exist src mkdir src
if not exist data mkdir data
if not exist logs mkdir logs

set NUM_WORKER=%1

docker-compose up --scale worker=%NUM_WORKER%