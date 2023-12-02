package kafka;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;

import java.time.Duration;
import java.util.Collections;
import java.util.Properties;

/**
 * read from console
 * offset = 0, key = null, value = this is a message to be sent to the todolist_topic topic.
 * so the offset starts from 0 index
 */
public class ConsumerClient {
    public static void main(String[] args) throws Exception {
        var props = getProperties();

        try (var consumer = new KafkaConsumer<String, String>(props)) {
            String topic = "todolist_topic";
            consumer.subscribe(Collections.singleton(topic));
            while (true) {
                ConsumerRecords<String, String> recorders = consumer.poll(Duration.ofMillis(100));
                for (ConsumerRecord<String, String> recorder : recorders) {
                    System.out.printf("offset = %d, key = %s, value = %s%n", recorder.offset(),
                            recorder.key(),
                            recorder.value());
                }
            }
        }
    }

    private static Properties getProperties() {
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
