package kafka;

import java.util.Properties;

/**
 * Remote one free broker, web ui for that more broker
 * <a href="https://console.upstash.com/kafka/514bfd93-8a06-4841-8cd4-0b4064f310a2/030665d9-9278-4e36-a9c0-3d64921b088d">...</a>"
 * The followings are from the UI, which means event (message/record) sent to the topic succeeded
 * Messages
 * 1
 * Partitions
 * 1
 * Current Storage
 * 125B
 */
public class ProducerPropertiesProvider {
    public static Properties getBasicProperties() {
        var props = new Properties();
        props.put("bootstrap.servers", "rich-sunbird-12750-us1-kafka.upstash.io:9092");
        props.put("sasl.mechanism", "SCRAM-SHA-256");
        props.put("security.protocol", "SASL_SSL");
        props.put("sasl.jaas.config", "org.apache.kafka.common.security.scram.ScramLoginModule required username=\"cmljaC1zdW5iaXJkLTEyNzUwJMkIC8gJ27v70YF_4n00KkgRPlpl9J2O-o9OAOc\" password=\"NjllNWFjZmEtMDZlMi00NTk4LWI2MmEtNzg1ZjdjNDc0N2Q5\";");
        props.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        props.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        return props;
    }
}
