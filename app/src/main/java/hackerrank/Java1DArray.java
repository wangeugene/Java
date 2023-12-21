package hackerrank;

import java.util.ArrayList;
import java.util.List;

public class Java1DArray {
    private static boolean canWin(int leap, int[] game) {
        List<Integer> firstRange0Indices = new ArrayList<>();
        for (int i = 0; i < game.length; i++) {
            if (game[i] != 1) {
                firstRange0Indices.add(i);
            } else {
                break;
            }
        }
        List<Integer> remainingRange0Indices = new ArrayList<>();
        for (int i = firstRange0Indices.get(firstRange0Indices.size() - 1) + 1; i < game.length; i++) {
            if (game[i] == 0) {
                remainingRange0Indices.add(i);
            }
        }
        int n = game.length / leap;
        for (Integer firstRange0Index : firstRange0Indices) {
            int cursorIndex = 0;
            for (int i = 1; i <= n; i++) {
                cursorIndex = firstRange0Index + i * leap;
                if (!remainingRange0Indices.contains(cursorIndex)) {
                    return false;
                }
            }
            return cursorIndex >= game.length - 1;
        }
        return false;
    }

    public static void main(String[] args) {
        int[] game = {0, 1, 0, 0, 1, 0, 0, 0, 1};
        final int leap = 3;
        System.out.println(canWin(leap, game));
    }
}
