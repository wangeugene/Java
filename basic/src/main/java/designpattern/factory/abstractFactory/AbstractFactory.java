package designpattern.factory.abstractFactory;

import designpattern.factory.Product;

import java.util.Collection;

public interface AbstractFactory {
    Product createProductA();

    Product createProductB();

    Collection<Product> createProducts();

}
