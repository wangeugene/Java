package hackerrank;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class HourGlassSubMatrixMaxSumFinder {
    public static void main(String[] args) {
        int[][] arr2D = {
                {-1, -1, 0, -9, -2, -2},
                {-2, -1, -6, -8, -2, -5},
                {-1, -1, -1, -2, -3, -4},
                {-1, -9, -2, -4, -4, -5},
                {-7, -3, -3, -2, -9, -9},
                {-1, -3, -1, -2, -4, -5}
        };
        List<List<Integer>> arr = Arrays.stream(arr2D)
                .map(row -> Arrays.stream(row).boxed().collect(Collectors.toList()))
                .collect(Collectors.toList());

        int sum = getSum(arr);
        System.out.println(sum);
    }

    private static int getSum(List<List<Integer>> arr) {
        int sum = Integer.MIN_VALUE;
        for (int row = 0; row < 4; row++) {
            for (int col = 0; col < 4; col++) {
                // calculate the hour glass pattern
                int firstRowSum = arr.get(row).get(col) + arr.get(row).get(col + 1) + arr.get(row).get(col + 2);
                int secondRowSum = arr.get(row + 1).get(col + 1);
                int thirdRowSum = arr.get(row + 2).get(col) + arr.get(row + 2).get(col + 1) + arr.get(row + 2).get(col + 2);
                int sumOfCurrentHourGlass = firstRowSum + secondRowSum + thirdRowSum;
                if (sumOfCurrentHourGlass >= sum) {
                    sum = sumOfCurrentHourGlass;
                }
            }
        }
        return sum;
    }
}
