package map;

import copyobject.pojo.User;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

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
    void testReverseByListIndex() {
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
    void testFindUsersExistInTwoLists() {
        users.retainAll(user2s);
        Assertions.assertNotNull(users);
        assertEquals(users.size(), 1);
        assertEquals(users.get(0).getName(), "xu");
        assertEquals(users.get(0).getAge(), 10);
    }

    @Test
    void testFlatmapExperiences() {
        List<String> uniqueExperiences = users.stream()
                .filter(u -> u.getExperiences() != null)
                .flatMap(u -> u.getExperiences().stream())
                .distinct()
                .collect(Collectors.toList());
        assertEquals(5, uniqueExperiences.size());
        Assertions.assertTrue(uniqueExperiences.contains("TESLA"));
    }

    @Test
    void testGroupByNameWithLoop() {
        Map<String, List<User>> usersByFirstName = new HashMap<>();
        for (User user : users) {
            String name = user.getName();
            usersByFirstName
                    .computeIfAbsent(name, k -> new ArrayList<>())
                    .add(user);
        }
        assertGroupByName(usersByFirstName);
    }

    @Test
    void testGroupByNameWithStream() {
        Map<String, List<User>> usersByFirstNameStream = users.
                stream()
                .collect(Collectors.groupingBy(
                        User::getName
                ));
        assertGroupByName(usersByFirstNameStream);
    }

    private static void assertGroupByName(Map<String, List<User>> usersByFirstName) {
        assertEquals(usersByFirstName.size(), 3);
        assertEquals(usersByFirstName.get("wang").size(), 3);
        assertEquals(usersByFirstName.get("li").size(), 2);
        assertEquals(usersByFirstName.get("xu").size(), 1);
    }

    @Test
    void testSortBySalaryThenAge() {
        List<User> usersSorted = users.stream()
                .sorted(Comparator.comparing(User::getSalary).reversed().thenComparing(User::getAge))
                .collect(Collectors.toList());

        assertEquals(usersSorted.size(), 6);
        assertEquals(usersSorted.get(0).getSalary(), 20000);
        assertEquals(usersSorted.get(0).getName(), "wang");
        assertEquals(usersSorted.get(1).getAge(), 25);
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
    void testToIntArray() {
        int[] ages = users.stream()
                .mapToInt(User::getAge)
                .toArray();
        assertEquals(ages.length, 6);
        assertEquals(ages[0], 22);
        assertEquals(ages[1], 25);
        assertEquals(ages[2], 32);
        assertEquals(ages[3], 22);
        assertEquals(ages[4], 52);
        assertEquals(ages[5], 10);
    }

    @Test
    void testAverageIntArray() {
        int[] integers = {1, 2, 3, 4, 5};
        int average = (int) Arrays
                .stream(integers)
                .average()
                .orElse(0);
        assertEquals(average, 3);
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
    void testMaxFrequencySalary() {
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

    @Test
    void testMaxRepeatedOneInBinaryRepresentationString() {
        String binaryRepresentation = Integer.toBinaryString(125); // 1111101
        int maxRepeatedOne = Arrays.stream(binaryRepresentation.split("0"))
                .mapToInt(String::length)
                .max()
                .orElse(0);
        assertEquals(maxRepeatedOne, 5);
    }

    @Test
    void testGenerateRangeClosed100() {
        List<Integer> rangeClosed100 = IntStream.rangeClosed(1, 100)
                .boxed()
                .collect(Collectors.toList());
        assertEquals(rangeClosed100.size(), 100);
        assertEquals(rangeClosed100.get(0), 1);
        assertEquals(rangeClosed100.get(99), 100);
    }

    @Test
    void testGeneratePythagoreanTriples() {
        List<int[]> pythagoreanTriples = IntStream.rangeClosed(1, 100)
                .boxed()
                .flatMap(
                        a ->
                                IntStream.rangeClosed(a, 100)
                                        .filter(b -> Math.sqrt(a * a + b * b) % 1 == 0)
                                        .mapToObj(
                                                b -> new int[]{a, b, (int) Math.sqrt(a * a + b * b)}
                                        )
                )
                .collect(Collectors.toList());
        assertNotNull(pythagoreanTriples);
        assertEquals(pythagoreanTriples.get(0).length, 3);
        assertEquals(pythagoreanTriples.get(0)[0], 3);
        assertEquals(pythagoreanTriples.get(0)[1], 4);
        assertEquals(pythagoreanTriples.get(0)[2], 5);
        assertEquals(pythagoreanTriples.get(1)[0], 5);
        assertEquals(pythagoreanTriples.get(1)[1], 12);
        assertEquals(pythagoreanTriples.get(1)[2], 13);
    }
}
