package factory.factoryMethod;

import factory.Product;
import factory.ProductA;

public class ConcreteFactoryA extends AbstractFactory {

    @Override
    Product factoryMethod() {
        return new ProductA();
    }
}
