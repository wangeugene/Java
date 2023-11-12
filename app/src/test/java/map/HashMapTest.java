package map;

import copyobjects.User;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

final class HashMapTest {
    private List<User> users = new ArrayList<>();

    @BeforeEach
    void setUp() {
        users.add(User.builder().age(22).salary(2000).name("wang").build());
        users.add(User.builder().age(25).salary(5000).name("wang").build());
        users.add(User.builder().age(32).salary(20000).name("wang").build());
        users.add(User.builder().age(22).salary(3000).name("li").build());
        users.add(User.builder().age(52).salary(3000).name("li").build());
        users.add(User.builder().age(10).salary(10).name("xu").build());
    }

    @Test
    void groupingByTest() {
        Map<String, List<User>> usersByFirstName = new HashMap<>();
        for (User user : users) {
            String name = user.getName();
            usersByFirstName
                    .computeIfAbsent(name, k -> new ArrayList<>())
                    .add(user);
        }
        assertGroupingOkay(usersByFirstName);

        Map<String, List<User>> usersByFirstNameStream = users.
                stream()
                .collect(Collectors.groupingBy(
                        User::getName
                ));
        assertGroupingOkay(usersByFirstNameStream);
    }

    private static void assertGroupingOkay(Map<String, List<User>> usersByFirstName) {
        Assertions.assertEquals(usersByFirstName.size(), 3);
        Assertions.assertEquals(usersByFirstName.get("wang").size(), 3);
        Assertions.assertEquals(usersByFirstName.get("li").size(), 2);
        Assertions.assertEquals(usersByFirstName.get("xu").size(), 1);
    }
}
