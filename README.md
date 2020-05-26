# Real-Time Data Streaming with Apache Kafka

## Architecture

insert architecture diagram here.

## Overview

In this example, we create two Kafka topics `subscription` and `bill`, which are taken from the tables `subscription` and `bill` in the MySQL database. Data from MySQL are piped into Kafka using Kafka Connect Source, whose configuration are stored in the `source-connectors` folder.

We use KSQL to process the data stream. Processed data is then piped into S3.

## Running the Source Code

### Step 1: Turn Up the Kafka Cluster

This [docker-compose.yml](docker-compose.yml) launches all services in Confluent Kafka and runs them in containers in your local host, enabling you to build your own development environments.

Run the full setup using the following command:

```
docker-compose up --force-recreate
```

To check that all services are up, run the following command. Ensure you have the same result as the one below:

```
$ docker-compose ps

     Name                    Command                  State                         Ports
------------------------------------------------------------------------------------------------------------
broker            /etc/confluent/docker/run        Up             0.0.0.0:9092->9092/tcp
connect           /etc/confluent/docker/run        Up (healthy)   0.0.0.0:8083->8083/tcp, 9092/tcp
control-center    /etc/confluent/docker/run        Up             0.0.0.0:9021->9021/tcp
ksql-datagen      bash -c echo Waiting for K ...   Up
ksqldb-cli        /bin/sh                          Up
ksqldb-server     /etc/confluent/docker/run        Up (healthy)   0.0.0.0:8088->8088/tcp
mysql             docker-entrypoint.sh mysqld      Up             0.0.0.0:3306->3306/tcp, 33060/tcp
rest-proxy        /etc/confluent/docker/run        Up             0.0.0.0:8082->8082/tcp
schema-registry   /etc/confluent/docker/run        Up             0.0.0.0:8081->8081/tcp
zookeeper         /etc/confluent/docker/run        Up             0.0.0.0:2181->2181/tcp, 2888/tcp, 3888/tcp
```

### Step 2: Create MySQL Database and Tables

Run the following command to create MySQL Database and Tables:

```
docker-compose exec mysql bash -c 'mysql -u root -pAdmin123 < /mysql-scripts/create_db.sql'
```

### Step 3: Deploy Kafka Connect Source Connectors

Run the following commands to deploy the Kafka Connect Source Connectors:

```
curl --request POST http://localhost:8083/connectors/ --header 'Content-Type: application/json' --data @source-connectors/bill_source_connector_config.json
```

```
curl --request POST http://localhost:8083/connectors/ --header 'Content-Type: application/json' --data @source-connectors/subscription_source_connector_config.json
```

### Step 4: Create KSQLDB Streams

Run the commands on the `ksql-scripts` folder on the Control Center KSQLDB interface to create KSQLDB streams.

```
CREATE STREAM bill WITH (KAFKA_TOPIC='mysql_bill', VALUE_FORMAT ='AVRO');
```

```
create stream high_value_customers as select * from subscription s where s.product_a = 'Subscribed' and s.product_b = 'Subscribed' emit changes;
```

### Step 5: Populate MySQL Tables

To see data flowing into Kafka, insert some data into the MySQL tables by running the following commands.

```
docker-compose exec mysql bash -c 'mysql -u root -pAdmin123 < /mysql-scripts/populate_bill.sql'
```

```
docker-compose exec mysql bash -c 'mysql -u root -pAdmin123 < /mysql-scripts/populate_subscription.sql'
```

### Step 6: Deploy Kafka Connect Sink Connector

Run the following command to deploy Kafka Connect Sink Connector to pipe data from Kafka to AWS S3 in JSON format.

```
curl --request POST http://localhost:8083/connectors/ \
     --header 'Content-Type: application/json' \
     --data @sink-connectors/archive_high_value_customer_sink_connector_config.json
```

```
curl --request POST http://localhost:8083/connectors/ \
     --header 'Content-Type: application/json' \
     --data @sink-connectors/archive_subscription_json_sink_connector.json
```
