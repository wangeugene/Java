package functional;

public class NoArgumentMain {
    public static void main(String[] args) {
        NoArgumentFunctional noArgumentFunc = () -> {
            System.out.println("No Argument Functional");
        };
        noArgumentFunc.apply();
    }
}
