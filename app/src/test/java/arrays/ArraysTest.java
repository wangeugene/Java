package arrays;

import org.junit.jupiter.api.Test;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * expanded elements in the array are initialized with their default values, which are 0.
 */
final class ArraysTest {
    private int[] numbers = {1, 2, 3, 4, 5, 6, 7};

    @Test
    void testCopyArray() {
        int[] numbersCopied = Arrays.copyOf(numbers, 10);
        assertEquals(numbersCopied.length, 10);
        assertEquals(numbersCopied[numbersCopied.length - 1], 0);
    }
}
