package designpattern.factory.factoryMethod;

import designpattern.factory.Product;

public class AbstractFactoryClient {
    public static void main(String[] args) {
        AbstractFactory abstractFactory = new ConcreteFactoryA();
        Product productA = abstractFactory.factoryMethod();
        productA.name();
    }
}
