package kafka;

import java.util.Properties;

public class ConsumerProperties {
    public static Properties getProperties() {
        var props = new Properties();
        props.put("bootstrap.servers", "rich-sunbird-12750-us1-kafka.upstash.io:9092");
        props.put("sasl.mechanism", "SCRAM-SHA-256");
        props.put("security.protocol", "SASL_SSL");
        props.put("sasl.jaas.config", "org.apache.kafka.common.security.scram.ScramLoginModule required username=\"cmljaC1zdW5iaXJkLTEyNzUwJMkIC8gJ27v70YF_4n00KkgRPlpl9J2O-o9OAOc\" password=\"NjllNWFjZmEtMDZlMi00NTk4LWI2MmEtNzg1ZjdjNDc0N2Q5\";");
        props.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
        props.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
        props.put("auto.offset.reset", "earliest");
        props.put("group.id", "$GROUP_NAME");
        return props;
    }
}