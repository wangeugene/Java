package hackerrank;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/**
 * <a href="https://www.hackerrank.com/challenges/java-arraylist/problem">ArrayList Problem</a>
 */
public class DynamicTableLooker {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        List<List<Integer>> table = new ArrayList<>();
        if (sc.hasNextInt()) {
            int n = sc.nextInt();
            for (int i = 0; i < n; i++) {
                List<Integer> row = new ArrayList<>();
                int rowCount = sc.nextInt();
                for (int j = 0; j < rowCount; j++) {
                    int e = sc.nextInt();
                    row.add(e);
                }
                table.add(row);
            }
        }
        if (sc.hasNextInt()) {
            int n = sc.nextInt();
            for (int i = 0; i < n; i++) {
                int[] twoQueries = {0, 0};
                for (int j = 0; j < 2; j++) {
                    twoQueries[j] = sc.nextInt();
                }
                int rowIndex = twoQueries[0] - 1;
                int colIndex = twoQueries[1] - 1;
                if (rowIndex < 0 || colIndex < 0) {
                    System.out.println("ERROR!");
                    continue;
                }
                if (table.size() < rowIndex) {
                    System.out.println("ERROR!");
                    continue;
                }
                if (table.get(rowIndex).isEmpty()) {
                    System.out.println("ERROR!");
                    continue;
                }
                if (table.get(rowIndex).size() < colIndex + 1) {
                    System.out.println("ERROR!");
                    continue;
                }
                System.out.println(table.get(rowIndex).get(colIndex));
            }
        }
    }
}
