# A working example of Azure Service Bus Queue Sender and Receiver using Spring Boot and JMS.

## build.gradle.kts

```kotlin
implementation("com.azure.spring:spring-cloud-azure-starter-servicebus-jms:5.22.0")
```

## application.properties

```properties
spring.jms.servicebus.connection-string=${servicebus.connection.string}
spring.jms.servicebus.pricing-tier=Standard
customize.servicebus.queue.name=${servicebus.queue.name}
```

## QueueSenderAndReceiver.java

```java
package com.eugene.java.azure.servicebus;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jms.annotation.JmsListener;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.stereotype.Service;

@Service
@EnableJms
public class QueueMessageReceiver implements CommandLineRunner {
    private static final Logger LOGGER = LoggerFactory.getLogger(QueueMessageReceiver.class);

    @Value("${customize.servicebus.queue.name}")
    private String queueName;

    private final JmsTemplate jmsTemplate;

    public QueueMessageReceiver(JmsTemplate jmsTemplate) {
        this.jmsTemplate = jmsTemplate;
    }

    @Override
    public void run(String... args) {
        LOGGER.info("Sending message");
        var message = "Hello, Azure Service Bus!";
        jmsTemplate.convertAndSend(queueName, message);
    }

    @JmsListener(destination = "${customize.servicebus.queue.name}", containerFactory = "jmsListenerContainerFactory")
    public void receiveMessage(String message) {
        LOGGER.error("Message received: {}", message);
    }
}
```