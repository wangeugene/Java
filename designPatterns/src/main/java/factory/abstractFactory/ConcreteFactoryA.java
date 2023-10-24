package factory.abstractFactory;

import factory.Product;
import factory.ProductA;
import factory.ProductB;

import java.util.Collection;
import java.util.List;

public class ConcreteFactoryA implements AbstractFactory {
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
        return List.of(new ProductA(), new ProductB());
    }

}
