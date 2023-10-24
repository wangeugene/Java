package factory.factoryMethod;

import factory.Product;

public class AbstractFactoryClient {
    public static void main(String[] args) {
        AbstractFactory abstractFactory = new ConcreteFactoryA();
        Product productA = abstractFactory.factoryMethod();
        productA.name();
    }
}
