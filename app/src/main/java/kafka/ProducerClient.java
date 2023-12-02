package kafka;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.util.Properties;

/**
 * Remote one free broker, web ui for that more broker
 * The broker WEB UI url: <a href="https://console.upstash.com/kafka/514bfd93-8a06-4841-8cd4-0b4064f310a2/030665d9-9278-4e36-a9c0-3d64921b088d"/>
 * The followings are from the UI,which means event(message/record) sent to the topic succeeded
 * Messages
 * 1
 * Partitions
 * 1
 * Current Storage
 * 125B
 */
public class ProducerClient {
    public static void main(String[] args) throws Exception {
        var props = new Properties();
        props.put("bootstrap.servers", "rich-sunbird-12750-us1-kafka.upstash.io:9092");
        props.put("sasl.mechanism", "SCRAM-SHA-256");
        props.put("security.protocol", "SASL_SSL");
        props.put("sasl.jaas.config", "org.apache.kafka.common.security.scram.ScramLoginModule required username=\"cmljaC1zdW5iaXJkLTEyNzUwJMkIC8gJ27v70YF_4n00KkgRPlpl9J2O-o9OAOc\" password=\"NjllNWFjZmEtMDZlMi00NTk4LWI2MmEtNzg1ZjdjNDc0N2Q5\";");
        props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

        try (var producer = new KafkaProducer<String, String>(props)) {
            String topic = "todolist_topic";
            String message = "this is a message to be sent to the todolist_topic topic.";
            ProducerRecord<String, String> record = new ProducerRecord<>(topic, message);
            producer.send(record);
        }
    }
}
