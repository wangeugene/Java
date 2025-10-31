package map;

import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;

class HashMapTest {
    @Test
    void testItemsReordered() {
        Map<String, Integer> basket = new HashMap<>();
        basket.put("apple", 2);
        basket.put("orange", 1);
        basket.put("banana", 3);
        assertEquals(basket.keySet().toArray()[0], "orange");
        assertEquals(basket.keySet().toArray()[1], "banana");
        assertEquals(basket.keySet().toArray()[2], "apple");
    }

    @Test
    void testGetNullKey() {
        Map<String, Integer> basket = new HashMap<>();
        basket.put(null, 2);
        assertEquals(basket.get(null), 2);
    }
}
