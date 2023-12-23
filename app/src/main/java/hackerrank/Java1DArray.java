package hackerrank;

/**
 * demo of Greedy Algorithm
 */
public class Java1DArray {
    private static boolean canWin(int leap, int[] game) {
        int lastElement = game[game.length - 1];
        if(lastElement == 1){

        }else{
        }
        return false;
    }

    public static void main(String[] args) {
        int[] game = {0, 1, 0, 0, 1, 0, 0, 0, 1};
        final int leap = 3;
        System.out.println(canWin(leap, game));
    }
}
