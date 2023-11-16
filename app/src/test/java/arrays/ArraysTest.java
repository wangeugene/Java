package arrays;

import org.junit.jupiter.api.Test;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.assertEquals;

final class ArraysTest {
    private int[] ints = {1, 2, 3, 4, 5, 6, 7};

    @Test
    void testCopyOf() {
        int[] intsCopyOf = Arrays.copyOf(ints, 10);
        Arrays.stream(intsCopyOf).forEach(System.out::println);
        assertEquals(intsCopyOf.length, 10);
        assertEquals(intsCopyOf[intsCopyOf.length - 1], 0);
    }
}
