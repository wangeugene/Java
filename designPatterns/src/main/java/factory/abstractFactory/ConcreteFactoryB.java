package factory.abstractFactory;

import factory.Product;
import factory.ProductA;
import factory.ProductB;
import factory.ProductC;

import java.util.Collection;
import java.util.List;

public class ConcreteFactoryB implements AbstractFactory {
    @Override
    public Product createProductA() {
        return new ProductA();
    }

    @Override
    public Product createProductB() {
        return new ProductB();
    }

    @Override
    public Collection<Product> createProducts() {
        return List.of(new ProductA(), new ProductC());
    }
}
