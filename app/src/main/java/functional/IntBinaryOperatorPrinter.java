package functional;

import java.util.function.IntBinaryOperator;

public class IntBinaryOperatorPrinter {
    public static void main(String[] args) {
        IntBinaryOperator intBinaryOperatorProduct = (x, y) -> x * y;
        System.out.println(intBinaryOperatorProduct.applyAsInt(5, 7));
    }
}
