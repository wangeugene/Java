package bigdecimal;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class SetScales {
    public static void main(String[] args) {
        BigDecimal ten = BigDecimal.TEN;
        BigDecimal three = BigDecimal.valueOf(3);
        BigDecimal halfUp = ten.divide(three, RoundingMode.HALF_UP);
        System.out.println("halfUp = " + halfUp);
        BigDecimal roundUp = ten.divide(three, RoundingMode.UP);
        System.out.println("roundUp = " + roundUp);
        BigDecimal scale4HalfUp = ten.divide(three, 4, RoundingMode.HALF_UP);
        System.out.println("scale4HalfUp = " + scale4HalfUp);
        BigDecimal scale4RoundUp = ten.divide(three, 4, RoundingMode.UP);
        System.out.println("scale4RoundUp = " + scale4RoundUp);
    }
}
