package regex;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class DuplicatedWordsRemoverTest {
    @Test
    void testRemoveDuplicatedWords() {
        List<String> lines = List.of(
                "Goodbye bye bye world world world",
                "Sam went went to to to his business",
                "Raya is is the the best player in eye eye game",
                "in inCline",
                "Hello hello Ab aB"
        );
        assertEquals("Goodbye bye world\n" +
                "Sam went to his business\n" +
                "Raya is the best player in eye game\n" +
                "in inCline\n" +
                "Hello Ab\n", DuplicatedWordsRemover.removeDuplicatedWords(lines));
    }
}