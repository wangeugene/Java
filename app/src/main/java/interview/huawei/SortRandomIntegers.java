package interview.huawei;

import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;
import java.util.random.RandomGenerator;

public class SortRandomIntegers {

    public static void main(String[] args) {
        List<Integer> ns = new ArrayList<>();
        for (int i = 0; i < 500; i++) {
            int n = RandomGenerator.getDefault().nextInt(500);
            ns.add(n);
        }
        System.out.println("ns.size() = " + ns.size());
        TreeSet<Integer> ts = new TreeSet<>(ns);
        System.out.println("ts.size() = " + ts.size());
        for (Integer t : ts) {
            System.out.println(t);
        }
    }
}
