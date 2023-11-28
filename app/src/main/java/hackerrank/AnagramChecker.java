package hackerrank;

import algorithm.BubbleSort;

public class AnagramChecker {
    public static void main(String[] args) {
        String[] tests = {"Abul", "BulA", "Fxi", "Fix", "Road", "rod"};
        for (int i = 0; i < tests.length; i += 2) {
            boolean is = isAnagram(tests[i], tests[i + 1]);
            System.out.println(is ? "Anagram" : "Not Anagram");
        }
    }

    static boolean isAnagram(String a, String b) {
        if (a.length() != b.length()) {
            return false;
        }
        char[] as = a.toUpperCase().toCharArray();
        char[] bs = b.toUpperCase().toCharArray();
        BubbleSort.bubbleSort(as);
        BubbleSort.bubbleSort(bs);
        for (int i = 0; i < bs.length; i++) {
            if (as[i] != bs[i]) {
                return false;
            }
        }
        return true;
    }

}
