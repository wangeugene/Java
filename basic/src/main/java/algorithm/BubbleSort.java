package algorithm;

import java.util.Arrays;

public class BubbleSort {
    private final static int[] arr = {8, 7, 0, 2, 4, 3, 5, 6, 1, 9};

    public static void main(String[] args) {
        String srt = Arrays.toString(bubbleSort(arr));
        System.out.println(srt);
        Arrays.stream(arr).forEach(System.out::print);
    }

    public static int[] bubbleSort(int[] arr) {
        for (int out = arr.length - 1; out > 0; out--) {
            for (int in = 0; in < out; in++) {
                if (arr[in] > arr[in + 1]) {
                    int swap = arr[in];
                    arr[in] = arr[in + 1];
                    arr[in + 1] = swap;
                }
            }
        }
        return arr;
    }

    public static void bubbleSort(char[] chars) {
        for (int out = chars.length - 1; out > 0; out--) {
            for (int in = 0; in < out; in++) {
                if (chars[in] > chars[in + 1]) {
                    char swap = chars[in + 1];
                    chars[in + 1] = chars[in];
                    chars[in] = swap;
                }
            }
        }
    }
}
