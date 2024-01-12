package enumeration;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class FruitTest {
    @Test
    void testGetName() {
        assertEquals("Apple", Fruit.APPLE.getName());
        assertEquals("Banana", Fruit.BANANA.getName());
        assertEquals("Orange", Fruit.ORANGE.getName());
    }

    @Test
    void testValues() {
        Fruit[] fruits = Fruit.values();
        assertEquals(3, fruits.length);
        assertEquals(Fruit.APPLE, fruits[0]);
        assertEquals(Fruit.BANANA, fruits[1]);
        assertEquals(Fruit.ORANGE, fruits[2]);
    }

    @Test
    void testValueOf() {
        assertEquals(Fruit.APPLE, Fruit.valueOf("APPLE"));
        assertEquals(Fruit.BANANA, Fruit.valueOf("BANANA"));
        assertEquals(Fruit.ORANGE, Fruit.valueOf("ORANGE"));
    }
}