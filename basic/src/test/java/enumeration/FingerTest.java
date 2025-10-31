package enumeration;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class FingerTest {
    @Test
    void testName() {
        assertEquals("THUMB", Finger.THUMB.name());
        assertEquals("INDEX", Finger.INDEX.name());
        assertEquals("MIDDLE", Finger.MIDDLE.name());
        assertEquals("RING", Finger.RING.name());
        assertEquals("LITTLE", Finger.LITTLE.name());
    }

    @Test
    void testValues() {
        Finger[] fingers = Finger.values();
        assertEquals(5, fingers.length);
        assertEquals(Finger.THUMB, fingers[0]);
        assertEquals(Finger.INDEX, fingers[1]);
        assertEquals(Finger.MIDDLE, fingers[2]);
        assertEquals(Finger.RING, fingers[3]);
        assertEquals(Finger.LITTLE, fingers[4]);
    }

    @Test
    void testValueOf() {
        assertEquals(Finger.THUMB, Finger.valueOf("THUMB"));
        assertEquals(Finger.INDEX, Finger.valueOf("INDEX"));
        assertEquals(Finger.MIDDLE, Finger.valueOf("MIDDLE"));
        assertEquals(Finger.RING, Finger.valueOf("RING"));
        assertEquals(Finger.LITTLE, Finger.valueOf("LITTLE"));
    }
}