package kafka.live;

import com.launchdarkly.eventsource.EventHandler;
import com.launchdarkly.eventsource.EventSource;
import com.launchdarkly.eventsource.MessageEvent;
import kafka.ProducerPropertiesProvider;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.net.MalformedURLException;
import java.net.URI;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

/**
 * Login the upstash.com using my GitHub account will see the console, the following url session id will change!
 * The broker WEB UI url: <a href="https://console.upstash.com/kafka/514bfd93-8a06-4841-8cd4-0b4064f310a2/030665d9-9278-4e36-a9c0-3d64921b088d"/>
 * Key Hashing is the process of determining the mapping of a key to a partition
 * In the default Kafka partitioner, the keys are hashed using hte murmur2 algorithm
 * targetPartition = Math.abs(Utils.murmur2(keyBytes)) % (numPartitions - 1 );
 * This means that same key will go to the same partition
 * and adding partitions to a topic will completely alter the formula
 * It is most likely preferred to not override the behaviour of the partitioner, but it is possible to do so
 * using partitioner.class
 * <p>
 * When key = null
 * Default partitioner as the following
 * RoundRobin: partitions 0,1,2,0,1,2,0,1,2 // higher latency, because context switching
 * Sticky Partitioner: all records sending a single partition until:
 * the batch is full or linger.ms has elapsed
 * batch messages sent successfully ( pre-defined batch size, say 16K is one batch for event messages)
 * good for: Larger batches and reduced latency
 * Over time, records are still spread evenly across partitions
 */
public class WikimediaLiveMonitor {
    private static final Logger logger = LoggerFactory.getLogger(WikimediaLiveMonitor.class);

    public static void main(String[] args) throws MalformedURLException {
        Properties props = ProducerPropertiesProvider.getBasicProperties();
        // set high throughput producer config
        props.put(ProducerConfig.LINGER_MS_CONFIG, "20");
        props.put(ProducerConfig.BATCH_SIZE_CONFIG, Integer.toString(32 * 1024));
        props.put(ProducerConfig.COMPRESSION_TYPE_CONFIG, "snappy");

        KafkaProducer<String, String> kafkaProducer = new KafkaProducer<>(props);
        String topic = "wikimedia.recent";
        String url = "https://stream.wikimedia.org/v2/stream/recentchange";
        EventHandler eventHandler = new WikimediaEventHandler(topic, kafkaProducer);
        EventSource.Builder builder = new EventSource.Builder(eventHandler, URI.create(url));
        try (EventSource eventSource = builder.build()) {
            eventSource.start();
            TimeUnit.SECONDS.sleep(10);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    static class WikimediaEventHandler implements EventHandler {
        private final String topic;
        private final KafkaProducer<String, String> kafkaProducer;

        public WikimediaEventHandler(String topic, KafkaProducer<String, String> kafkaProducer) {
            this.topic = topic;
            this.kafkaProducer = kafkaProducer;
        }

        @Override
        public void onOpen() {
            logger.info("opened");
        }

        @Override
        public void onClosed() {
            kafkaProducer.close();
        }

        @Override
        public void onMessage(String event, MessageEvent messageEvent) {
            String data = messageEvent.getData();
            System.out.println(data);
            ProducerRecord<String, String> record = new ProducerRecord<>(topic, data);
            kafkaProducer.send(record);
        }

        @Override
        public void onComment(String comment) {
            System.out.println("onCommented");
        }

        @Override
        public void onError(Throwable t) {
            System.err.println(t.getMessage());
        }
    }
}
