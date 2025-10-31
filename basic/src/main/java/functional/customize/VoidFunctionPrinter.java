package functional.customize;

public class VoidFunctionPrinter {
    public static void main(String[] args) {
        VoidFunction noArgumentFunc = () -> System.out.println("No Argument Functional");
        noArgumentFunc.apply();
    }
}
