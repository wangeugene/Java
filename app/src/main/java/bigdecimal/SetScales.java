package bigdecimal;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class SetScales {

    private static BigDecimal numerator;
    private static BigDecimal denominator;
    private static int scale;

    public static void main(String[] args) {
        numerator = BigDecimal.TEN;
        denominator = BigDecimal.valueOf(3);
        scale = 5;
        divideWithHalfUpMode();
        divideWithUpMode();
        divideWithHalfUpModeAndScale();
        divideWithUpModeAndScale();
    }

    private static void divideWithUpMode() {
        BigDecimal quotientUp = numerator.divide(denominator, RoundingMode.UP);
        System.out.println("quotientUp = " + quotientUp);
    }

    private static void divideWithHalfUpMode() {
        BigDecimal quotientHalfUp = numerator.divide(denominator, RoundingMode.HALF_UP);
        System.out.println("quotientHalfUp = " + quotientHalfUp);
    }
    private static void divideWithHalfUpModeAndScale() {
        BigDecimal quotientWithScaleHalfUp = numerator.divide(denominator, scale, RoundingMode.HALF_UP);
        System.out.println("quotientWithScaleHalfUp = " + quotientWithScaleHalfUp);
    }
    private static void divideWithUpModeAndScale() {
        BigDecimal quotientWithScaleUp = numerator.divide(denominator, scale, RoundingMode.UP);
        System.out.println("quotientWithScaleUp = " + quotientWithScaleUp);
    }
}
