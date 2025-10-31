package designpattern.factory.factoryMethod;

import designpattern.factory.Product;
import designpattern.factory.ProductA;

public class ConcreteFactoryA extends AbstractFactory {

    @Override
    Product factoryMethod() {
        return new ProductA();
    }
}
