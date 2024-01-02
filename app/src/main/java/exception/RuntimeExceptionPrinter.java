package exception;

/**
 * demonstrate runtime exception won't stop the program
 */
public class RuntimeExceptionPrinter {
    public static void main(String[] args) {
        try {
            throwMainException();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        printHello();
    }

    private static void throwMainException() {
        throw new RuntimeException("Main Exception");
    }

    private static void printHello() {
        System.out.println("Hello");
    }
}
