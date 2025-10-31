package number;

import java.math.BigInteger;

public class BigIntegerArithmetics {
    public static void main(String[] args) {
        BigInteger a = BigInteger.valueOf(1234129123);
        BigInteger b = BigInteger.valueOf(20000000);
        System.out.println(a.add(b));
        System.out.println(a.multiply(b));

        int overFlowedInteger = a.intValue() * b.intValue();
        System.out.println(overFlowedInteger);
    }
}
