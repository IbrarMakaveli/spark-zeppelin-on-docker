# Spark Standalone Zeppelin on Docker

Here is a docker installation of Spark Standalone with the following feature tools: 
- Scale out workers
- Zeppelin Notebook Spark in python or scala
- Traefik for the reverse proxy of Web UI
- Web UI for: Zeppelin, Master Spark, History Job Spark

## Installation

The default number of workers is 2 in the config

Launch cluster on `Windows` :
```bash
run_cluster.cmd <NUM_WORKER>
```

Launch cluster on `Linux` :
```bash
./run_cluster.sh <NUM_WORKER>
```

## Credit

Original docker spark : https://github.com/suraj95/Spark-on-Docker
