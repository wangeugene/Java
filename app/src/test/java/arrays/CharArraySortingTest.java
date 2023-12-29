package arrays;

import org.junit.jupiter.api.Test;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.assertEquals;


class CharArraySortingTest {
    @Test
    void testCharacterSorting() {
        char[] as = "hello".toCharArray();
        char[] bs = "ellho".toCharArray();
        Arrays.sort(as);
        Arrays.sort(bs);
        assertEquals("ehllo", new String(as));
    }
}
