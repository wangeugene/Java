package designpattern.factory.factoryMethod;

import designpattern.factory.Product;
import designpattern.factory.ProductB;

public class ConcreteFactoryB extends AbstractFactory {
    @Override
    Product factoryMethod() {
        return new ProductB();
    }
}
