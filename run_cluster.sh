#!/bin/bash

mkdir -p notebook
mkdir -p conf/worker
mkdir -p conf/zeppelin
mkdir -p conf/master
mkdir -p src
mkdir -p data
mkdir -p logs

[[ -z "$1" ]] && NUM_WORKER=2 || NUM_WORKER="$1"

docker-compose up --scale worker=${NUM_WORKER}