package map;

import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.Map;

public class HashMapTest {
    @Test
    void testItemsOrder() {
        Map<String, Integer> basket = new HashMap<>();
        basket.put("apple", 2);
        basket.put("orange", 1);
        basket.put("banana", 3);
        basket.forEach((k, v) -> System.out.println(k + " " + v));
    }
}
