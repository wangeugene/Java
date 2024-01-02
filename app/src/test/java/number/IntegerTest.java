package number;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.stream.Collectors;

class IntegerTest {
    private List<Integer> integers = List.of(1, 2, 3, 4, 5, 6, 7, 8, 9);

    @Test
    void testToBinaryString() {
        Assertions.assertIterableEquals(List.of("1", "10", "11", "100", "101", "110", "111", "1000", "1001"),
                integers.stream().map(Integer::toBinaryString).collect(Collectors.toList()));
    }
}
