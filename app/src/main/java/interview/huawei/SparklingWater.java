package interview.huawei;


public class SparklingWater {
    public static void main(String[] args) {
        int[] ns = {3, 10, 81};
        for (int n : ns) {
            int totalDrinks = 0;
            while (n >= 3) {
                totalDrinks += n / 3;
                n = n / 3 + n % 3;
            }
            if (n == 2) {
                totalDrinks++;
            }
            System.out.println(totalDrinks);
        }
    }
}
