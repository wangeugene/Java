import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.List;

class OperatorsTest {
    @Test
    void test(){
        List<String> names = Arrays.asList("bob", "josh", "megan");
        names.replaceAll(String::toUpperCase);

    }
}
