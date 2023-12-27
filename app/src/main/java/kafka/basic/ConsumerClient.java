package kafka.basic;

import kafka.ConsumerPropertiesProvider;
import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;

import java.time.Duration;
import java.util.Collections;

/**
 * read from console
 * offset = 0, key = null, value = this is a message to be sent to the todolist_topic topic.
 * so the offset starts from 0 index
 */
public class ConsumerClient {
    public static void main(String[] args) throws Exception {
        var props = ConsumerPropertiesProvider.getProperties();

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
}
