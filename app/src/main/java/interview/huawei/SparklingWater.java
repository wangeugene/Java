package interview.huawei;


import java.util.ArrayList;
import java.util.List;

public class SparklingWater {
    final static int exchangeBenchmark = 3;

    public static void main(String[] args) {
        int[] bottles = {10, 40, 81};
        List<Integer> list = new ArrayList<>();
        for (int bottle : bottles) {
            list.add(countBottles(bottle));
        }
        list.forEach(System.out::println);
    }

    private static int countBottles(int divider) {
        int count = 0;
        return factorize(count, divider);
    }

    private static int factorize(int count, int divider) {
        if (divider < 3) {
            if (divider != 0) {
                count++;
            }
            return count;
        } else {
            divider = divider / exchangeBenchmark;
            count += divider;
            return factorize(count, divider);
        }
    }
}
