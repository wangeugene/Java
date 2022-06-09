import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.Map;

public class TwoArityTest {
    @Test
    void twoArity() {
        Map<String, Integer> salaries = new HashMap<>();
        salaries.put("John", 40000);
        salaries.put("Freddy", 30000);
        salaries.put("Samuel", 50000);
        salaries.replaceAll((name, oldValue) -> name.equals("Freddy") ? oldValue : oldValue + 10000);
        System.out.println(salaries);
    }
}
