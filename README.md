![java](https://img.shields.io/badge/java-1.8.0-red?style=flat-square)
![scala](https://img.shields.io/badge/scala-2.11.12-e20001?style=flat-square)
![python](https://img.shields.io/badge/python-3.5.3-blue?style=flat-square)

![spark](https://img.shields.io/badge/spark-2.4.5-yellow?style=flat-square)
![traefik](https://img.shields.io/badge/traefik-2.2-38abc8?style=flat-square)
![zeppelin](https://img.shields.io/badge/zeppelin-0.8.2-3372a7?style=flat-square)

# Spark Standalone Zeppelin on Docker

Here is a docker installation of Spark Standalone with the following feature tools: 
- Scale out workers
- Zeppelin Notebook Spark in python or scala
- Traefik for the reverse proxy of Web UI
- Web UI for : Zeppelin, Master Spark, History Job Spark

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

## Work environment

### Web UI

Name              | URL
---               | ---
Spark Master      | http://master.localhost/
History Job Spark | http://history.localhost/
Zeppelin Notebook | http://zeppelin.localhost/
Traefik           | http://traefik.localhost/

### Volumes mounted

All along the data keep are the following : your code, logs, notebooks and input data.

That is to say that if you lose your containers or restart it, its data will not be lost.

Local      | Docker                   | User                    | Description
---        | ---                      | ---                     | --- 
`src`      | `/tmp/src`               | Master Spark            | Put here your `scala` and `python` code
`data`     | `/tmp/data`              | Master Spark & Zeppelin | The data you want to use in your processes
`logs`     | `/tmp/logs`              | History Jobs Spark      | Logs of the different executions of Job Spark
`notebook` | `/usr/zeppelin/notebook` | Zeppelin                | The notebooks will be saved on this directory by Zeppelin

## Credit

Original docker spark : https://github.com/suraj95/Spark-on-Docker
