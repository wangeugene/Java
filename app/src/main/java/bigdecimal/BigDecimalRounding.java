package bigdecimal;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class BigDecimalRounding {

    private static BigDecimal numerator = BigDecimal.TEN;
    private static BigDecimal denominator = BigDecimal.valueOf(3);
    private static int scale = 5;

    public static void main(String[] args) {
        divideWithHalfUpMode();
        divideWithUpMode();
        divideWithHalfUpModeAndScale();
        divideWithUpModeAndScale();
    }

    private static void divideWithUpMode() {
        BigDecimal quotientUp = numerator.divide(denominator, RoundingMode.UP);
    }

    private static void divideWithHalfUpMode() {
        BigDecimal quotientHalfUp = numerator.divide(denominator, RoundingMode.HALF_UP);
    }
    private static void divideWithHalfUpModeAndScale() {
        BigDecimal quotientWithScaleHalfUp = numerator.divide(denominator, scale, RoundingMode.HALF_UP);
    }
    private static void divideWithUpModeAndScale() {
        BigDecimal quotientWithScaleUp = numerator.divide(denominator, scale, RoundingMode.UP);
    }
}
