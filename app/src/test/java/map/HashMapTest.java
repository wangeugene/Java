package map;

import copyobjects.User;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.*;
import java.util.stream.Collectors;

final class HashMapTest {
    private List<User> users = new ArrayList<>();
    private List<User> user2s = new ArrayList<>();

    @BeforeEach
    void setUp() {
        users.add(User.builder().age(22).salary(2000).name("wang").build());
        users.add(User.builder().age(25).salary(5000).name("wang").build());
        users.add(User.builder().age(32).salary(20000).name("wang").build());
        users.add(User.builder().age(22).salary(3000).name("li").build());
        users.add(User.builder().age(52).salary(3000).name("li").build());
        users.add(User.builder().age(10).salary(10).name("xu").build());

        user2s.add(User.builder().age(10).salary(10).name("xu").build());
        user2s.add(User.builder().age(25).salary(15000).name("x_wang").build());
        user2s.add(User.builder().age(32).salary(120000).name("x_wang").build());
        user2s.add(User.builder().age(22).salary(13000).name("x_li").build());
    }

    @Test
    void testFindCommons() {
        users.retainAll(user2s);
        Assertions.assertNotNull(users);
        Assertions.assertEquals(users.size(), 1);
        Assertions.assertEquals(users.get(0).getName(), "xu");
        Assertions.assertEquals(users.get(0).getAge(), 10);
    }

    @Test
    void testGroupingBy() {
        Map<String, List<User>> usersByFirstName = new HashMap<>();
        for (User user : users) {
            String name = user.getName();
            usersByFirstName
                    .computeIfAbsent(name, k -> new ArrayList<>())
                    .add(user);
        }
        assertGroupingOkay(usersByFirstName);
    }

    @Test
    void testGroupingByStream() {
        Map<String, List<User>> usersByFirstNameStream = users.
                stream()
                .collect(Collectors.groupingBy(
                        User::getName
                ));
        assertGroupingOkay(usersByFirstNameStream);
    }

    @Test
    void testSortByTwoKeys() {
        List<User> usersSorted = users.stream()
                .sorted(Comparator.comparing(User::getSalary).reversed().thenComparing(User::getAge))
                .toList();

        Assertions.assertEquals(usersSorted.size(), 6);
        Assertions.assertEquals(usersSorted.get(0).getSalary(), 20000);
        Assertions.assertEquals(usersSorted.get(0).getName(), "wang");
        Assertions.assertEquals(usersSorted.get(1).getAge(), 1);
    }

    private static void assertGroupingOkay(Map<String, List<User>> usersByFirstName) {
        Assertions.assertEquals(usersByFirstName.size(), 3);
        Assertions.assertEquals(usersByFirstName.get("wang").size(), 3);
        Assertions.assertEquals(usersByFirstName.get("li").size(), 2);
        Assertions.assertEquals(usersByFirstName.get("xu").size(), 1);
    }
}
