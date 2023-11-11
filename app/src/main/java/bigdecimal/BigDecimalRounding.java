package bigdecimal;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.function.Consumer;

public class BigDecimalRounding {

    private static BigDecimal numerator = BigDecimal.TEN;
    private static BigDecimal denominator = BigDecimal.valueOf(3);
    private static int scale = 5;
    final static Consumer<BigDecimal> print = x -> System.out.println(x.getClass().getSimpleName() + " = " + x);

    public static void main(String[] args) {
        divideWithHalfUpMode();
        divideWithUpMode();
        divideWithHalfUpModeAndScale();
        divideWithUpModeAndScale();
    }

    private static void divideWithUpMode() {
        BigDecimal quotientUp = numerator.divide(denominator, RoundingMode.UP);
        print.accept(quotientUp);

    }

    private static void divideWithHalfUpMode() {
        BigDecimal quotientHalfUp = numerator.divide(denominator, RoundingMode.HALF_UP);
        print.accept(quotientHalfUp);
    }

    private static void divideWithHalfUpModeAndScale() {
        BigDecimal quotientWithScaleHalfUp = numerator.divide(denominator, scale, RoundingMode.HALF_UP);
        print.accept(quotientWithScaleHalfUp);
    }

    private static void divideWithUpModeAndScale() {
        BigDecimal quotientWithScaleUp = numerator.divide(denominator, scale, RoundingMode.UP);
        print.accept(quotientWithScaleUp);
    }
}
