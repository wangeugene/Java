package designpattern.decorator;

public class DecoratorClient {
    private static Decorator decorator = new DecoratorImpl();
    public static void main(String[] args) {
        System.out.println(decorator.enhance());
    }
}
