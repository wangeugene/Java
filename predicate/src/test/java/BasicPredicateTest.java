import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.contains;

import static org.junit.jupiter.api.Assertions.assertEquals;

class BasicPredicateTest {
    @Test
    void basicPredicate() {
        List<String> names = Arrays.asList("Adam", "Alexander", "John", "Tom");
        List<String> result = names.stream().filter(name -> name.startsWith("A")).collect(Collectors.toList());

        assertEquals(2, result.size());
        assertThat(result, contains("Adam", "Alexander"));
    }
}
