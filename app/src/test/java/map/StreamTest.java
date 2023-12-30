package map;

import copyobject.pojo.User;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.*;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.assertEquals;

final class StreamTest {
    private List<User> users = new ArrayList<>();
    private List<User> user2s = new ArrayList<>();

    @BeforeEach
    void setUp() {
        users.add(User.builder().age(22).salary(2000).name("wang").experiences(List.of("IBM", "APPLE", "TESLA")).build());
        users.add(User.builder().age(25).salary(5000).name("wang").build());
        users.add(User.builder().age(32).salary(20000).name("wang").build());
        users.add(User.builder().age(22).salary(3000).name("li").experiences(List.of("IBM", "MICROSOFT", "TENCENT")).build());
        users.add(User.builder().age(52).salary(3000).name("li").build());
        users.add(User.builder().age(10).salary(10).name("xu").build());

        user2s.add(User.builder().age(10).salary(10).name("xu").build());
        user2s.add(User.builder().age(25).salary(15000).name("x_wang").build());
        user2s.add(User.builder().age(32).salary(120000).name("x_wang").build());
        user2s.add(User.builder().age(22).salary(13000).name("x_li").build());
    }

    @Test
    void testReverseListIndex() {
        Collections.reverse(users);
        assertEquals(users.get(0).getName(), "xu");
        assertEquals(users.get(0).getAge(), 10);
        assertEquals(users.get(1).getName(), "li");
        assertEquals(users.get(1).getAge(), 52);
        assertEquals(users.get(2).getName(), "li");
        assertEquals(users.get(2).getAge(), 22);
        assertEquals(users.get(3).getName(), "wang");
        assertEquals(users.get(3).getAge(), 32);
        assertEquals(users.get(4).getName(), "wang");
        assertEquals(users.get(4).getAge(), 25);
    }

    @Test
    void testFindCommons() {
        users.retainAll(user2s);
        Assertions.assertNotNull(users);
        assertEquals(users.size(), 1);
        assertEquals(users.get(0).getName(), "xu");
        assertEquals(users.get(0).getAge(), 10);
    }

    @Test
    void testMaxSalary() {
        Integer max = users.stream()
                .map(User::getSalary)
                .max(Comparator.naturalOrder())
                .map(Double::intValue)
                .orElse(0);
        assertEquals(20000, max);
    }

    @Test
    void testListExperiences() {
        List<String> uniqueExperiences = users.stream()
                .filter(u -> u.getExperiences() != null)
                .flatMap(u -> u.getExperiences().stream())
                .distinct()
                .collect(Collectors.toList());
        assertEquals(5, uniqueExperiences.size());
        Assertions.assertTrue(uniqueExperiences.contains("TESLA"));
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
                .collect(Collectors.toList());

        assertEquals(usersSorted.size(), 6);
        assertEquals(usersSorted.get(0).getSalary(), 20000);
        assertEquals(usersSorted.get(0).getName(), "wang");
        assertEquals(usersSorted.get(1).getAge(), 25);
    }

    @Test
    void testSumSalary() {
        Double sumSalary = users.stream()
                .map(User::getSalary)
                .reduce(0.0, Double::sum);
        assertEquals(sumSalary, 33010);
    }

    @Test
    void testMeanSalary() {
        Double meanSalary = users.stream()
                .map(User::getSalary)
                .reduce(0.0, Double::sum) / users.size();
        assertEquals(meanSalary, 5501.666666666667);
    }

    @Test
    void testMedianSalary() {
        Double medianSalary = users.stream()
                .map(User::getSalary)
                .sorted()
                .skip(users.size() / 2)
                .limit(1 + (users.size() % 2))
                .reduce(0.0, Double::sum);
        assertEquals(medianSalary, 3000);
    }

    @Test
    void testMostOccurrenceSalary() {
        Double mostOccurrenceSalary = users.stream()
                .map(User::getSalary)
                .collect(Collectors.groupingBy(s -> s, Collectors.counting()))
                .entrySet()
                .stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse(0.0);
        assertEquals(mostOccurrenceSalary, 3000);
    }

    private static void assertGroupingOkay(Map<String, List<User>> usersByFirstName) {
        assertEquals(usersByFirstName.size(), 3);
        assertEquals(usersByFirstName.get("wang").size(), 3);
        assertEquals(usersByFirstName.get("li").size(), 2);
        assertEquals(usersByFirstName.get("xu").size(), 1);
    }
}
