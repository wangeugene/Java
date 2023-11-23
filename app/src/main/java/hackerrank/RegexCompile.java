package hackerrank;

public class RegexCompile {
    public static void main(String[] args) {
        String IP = "10.10.10.17";
        System.out.println(IP.matches(new MyRegex().pattern));
    }

    static class MyRegex {
        final String pattern = "^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$";
    }
}
