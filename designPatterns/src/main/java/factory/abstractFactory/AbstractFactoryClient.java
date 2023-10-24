package factory.abstractFactory;

import factory.Product;

import java.util.Collection;

public class AbstractFactoryClient {
    public static void main(String[] args) {
        ConcreteFactoryA concreteFactoryA = new ConcreteFactoryA();
        Product productA = concreteFactoryA.createProductA();
        productA.name();
        Product productB = concreteFactoryA.createProductB();
        productB.name();
        Collection<Product> products = concreteFactoryA.createProducts();
        products.forEach(Product::name);
        ConcreteFactoryB concreteFactoryB = new ConcreteFactoryB();
        Collection<Product> productsB = concreteFactoryB.createProducts();
        productsB.forEach(Product::name);
    }
}
