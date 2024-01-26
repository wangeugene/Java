package nullity;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertThrows;

final class LombokNullityTest {
    @SuppressWarnings("DataFlowIssue")
    @Test
    void testNonNull() {
        LombokNullity.printString("Hello, World!");
        assertThrows(NullPointerException.class, () -> LombokNullity.printString(null));
    }
}
