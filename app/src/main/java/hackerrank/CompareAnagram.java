package hackerrank;

public class CompareAnagram {
    public static void main(String[] args) {
        boolean is = isAnagram("Abul", "BulA");
        System.out.println(is ? "Anagram" : "Not Anagram");
    }

    static boolean isAnagram(String a, String b) {
        // Complete the function
        if (a.length() != b.length()) {
            return false;
        }
        char[] arrs = a.toUpperCase().toCharArray();
        char[] brrs = b.toUpperCase().toCharArray();
        arrs = bubbleSort(arrs);
        brrs = bubbleSort(brrs);
        for (int i = 0; i < brrs.length; i++) {
            if (arrs[i] != brrs[i]) {
                return false;
            }
        }
        return true;
    }

    static char[] bubbleSort(char[] arrs) {
        for (int out = arrs.length - 1; out > 0; out--) {
            for (int in = 0; in < out; in++) {
                if (arrs[in] > arrs[in + 1]) {
                    char swap = arrs[in + 1];
                    arrs[in + 1] = arrs[in];
                    arrs[in] = swap;
                }
            }
        }
        return arrs;
    }
}
