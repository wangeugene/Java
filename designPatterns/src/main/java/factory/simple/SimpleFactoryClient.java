package factory.simple;

import factory.Product;

public class SimpleFactoryClient {
    public static void main(String[] args) {
        Product a = SimpleFactory.create("A");
        a.name();

        Product b = SimpleFactory.create("B");
        b.name();
    }
}
