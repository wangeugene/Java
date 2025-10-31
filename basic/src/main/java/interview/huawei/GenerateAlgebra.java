package interview.huawei;

import java.util.stream.IntStream;

/**
 * generate a series of a + sum of b *  2 ^ (0 ... n)
 */
public class GenerateAlgebra {
    public static void main(String[] args) {
        int a = 1;
        int b = 3;
        int n = 5;
        int[] result = new int[5];
        for (int j = 0; j < n; j++) {
            result[j] = a + (int) IntStream.range(0, j + 1)
                    .mapToDouble(x -> Math.pow(2, x) * b)
                    .sum();
        }
        for (int i : result) {
            System.out.printf("%d ", i);
        }
    }
}
