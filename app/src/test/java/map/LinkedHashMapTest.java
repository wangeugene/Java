package map;

import org.junit.jupiter.api.Test;
import java.util.LinkedHashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;

class LinkedHashMapTest {
    @Test
    void testItemsOrderRetained() {
        Map<String, Integer> basket = new LinkedHashMap<>();
        basket.put("apple", 2);
        basket.put("orange", 1);
        basket.put("banana", 3);
        assertEquals(basket.keySet().toArray()[0], "apple");
        assertEquals(basket.keySet().toArray()[1], "orange");
        assertEquals(basket.keySet().toArray()[2], "banana");
    }

    @Test
    void testGetNullKey() {
        Map<String, Integer> basket = new LinkedHashMap<>();
        basket.put(null, 2);
        assertEquals(basket.get(null), 2);
    }
}
