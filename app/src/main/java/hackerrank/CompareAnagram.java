package hackerrank;

public class CompareAnagram {
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
        bubbleSort(as);
        bubbleSort(bs);
        for (int i = 0; i < bs.length; i++) {
            if (as[i] != bs[i]) {
                return false;
            }
        }
        return true;
    }

    static void bubbleSort(char[] chars) {
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
