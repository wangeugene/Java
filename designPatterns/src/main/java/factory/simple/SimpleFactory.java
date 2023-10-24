package factory.simple;

import factory.Product;
import factory.ProductA;
import factory.ProductB;

public final class SimpleFactory {
    public static Product create(String type){
        if("A".equals(type)) {
            return new ProductA();
        }else if("B".equals(type)){
            return new ProductB();
        }else{
            return new Product() {
                @Override
                public void name() {
                    System.out.println("Undefined Product");
                }
            };
        }
    }
}
