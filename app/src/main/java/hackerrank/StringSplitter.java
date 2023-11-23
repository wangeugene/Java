package hackerrank;

public class StringSplitter {
    public static void main(String[] args) {
        String input = "He is a very very good boy,,,,      isn't he?";
        String[] split = input.split("[^A-Za-z]+");
        for (String s : split) {
            System.out.println(s);
        }
    }
}
