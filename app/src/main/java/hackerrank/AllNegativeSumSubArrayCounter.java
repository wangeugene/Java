package hackerrank;

/**
 * count all the sub-arrays with a negative sum.
 * [-2], [-5], [-2,4,-5] are the sub-arrays with a negative sum.
 * [1, -2], [4, -5] are the sub-arrays with a negative sum.
 * [-2,-5] is not counted as a valid subarray as the indices of -2 and -5 are not continuous.
 */
public class AllNegativeSumSubArrayCounter {
    public static void main(String[] args) {
        int[] arr = {1, -2, 4, -5, 1};
        int countNegativeSumArray = 0;
        for (int i = 0; i < arr.length; i++) {
            int sum = 0;
            for (int j = i; j < arr.length; j++) {
                sum += arr[j];
                if (sum < 0) {
                    countNegativeSumArray++;
                }
            }
        }
        System.out.println(countNegativeSumArray);
    }
}
