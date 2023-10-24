package factory.factoryMethod;

import factory.Product;
import factory.ProductB;

public class ConcreteFactoryB extends AbstractFactory {
    @Override
    Product factoryMethod() {
        return new ProductB();
    }
}
