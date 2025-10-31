package datastructure;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class ArrayListTest {
    @Test
    void testRemoveFromMiddle() {
        List<Integer> integers = new ArrayList<>();
        integers.add(1);
        integers.add(2);
        integers.add(3);
        integers.add(4);
        integers.remove(2);
        assertEquals(3, integers.size());
        assertEquals(4, integers.get(2));
    }
}
