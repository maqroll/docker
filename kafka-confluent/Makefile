kafkaCmd = docker exec -it kafka-confluent_kafka_1 $1
schemaRegistryCmd = docker exec -it kafka-confluent_schema-registry_1 $1

createTopic:
	$(kafkaCmd) /usr/bin/kafka-topics --zookeeper zookeeper:32181 --create --partitions 1 --replication-factor 1 --topic atopic

listTopics:
	$(kafkaCmd) /usr/bin/kafka-topics --zookeeper zookeeper:32181 --list

# always read with the related schema version
consume:
	$(schemaRegistryCmd) /usr/bin/kafka-avro-console-consumer --bootstrap-server kafka:29092 --from-beginning --property print.key=true --topic atopic --timeout-ms 10000

# {"f1":"a"} -> ok (register schema in schema registry)
# {"a2":"b"} -> fail
# {"f1":5} -> fail
# {} -> fail
produce:
	$(schemaRegistryCmd) /usr/bin/kafka-avro-console-producer --broker-list kafka:29092 --property value.schema='{"type":"record","name":"myrecord","fields":[{"name":"f1","type":"string"}]}' --topic atopic

# {"f1":"a"} -> fail
# {"f1":"a","f2":null} -> ok (register new schema in schema registry)
# {"f1":"a","f2":4} -> ok	
produce2:
	$(schemaRegistryCmd) /usr/bin/kafka-avro-console-producer --broker-list kafka:29092 --property value.schema='{"type":"record","name":"myrecord","fields":[{"name":"f1","type":"string"},{"name":"f2","type":["int","null"],"default":5}]}' --topic atopic

# you can use *produce* after using *produce2* without creating a new schema version