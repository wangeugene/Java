package arrays;

import org.junit.jupiter.api.Test;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.assertEquals;


public class CharArraySortingTest {

    @Test
    void testCharacterSorting() {
        String a = "hello";
        String b = "ellho";
        char[] as = a.toCharArray();
        char[] bs = b.toCharArray();
        Arrays.sort(as);
        Arrays.sort(bs);
        assertEquals(new String(as),new String(bs));
        assertEquals("ehllo", new String(as));
    }
}
