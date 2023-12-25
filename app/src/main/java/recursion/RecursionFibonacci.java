package recursion;

public class RecursionFibonacci {
    static int fibonacci(int n) {
        if (n <= 1) return n;
        return fibonacci(n - 1) + fibonacci(n - 2);
    }
    public static void main(String[] args) {
        System.out.println("The 5th fibonacci number is: " + fibonacci(5));
        System.out.println("The 10th fibonacci number is: " + fibonacci(10));
        System.out.println("The 17th fibonacci number is: " + fibonacci(17));
    }
}
