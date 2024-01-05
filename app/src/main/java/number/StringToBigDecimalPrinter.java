package number;

import java.math.BigDecimal;

public class StringToBigDecimalPrinter {
    public static void main(String[] args) {
        String[] data = {".12", "0.12", "0.0000", "02.34", "-100"};
        BigDecimal f0 = new BigDecimal(data[0]);
        BigDecimal f1 = new BigDecimal(data[1]);
        BigDecimal f2 = new BigDecimal(data[2]);
        BigDecimal f3 = new BigDecimal(data[3]);
        BigDecimal f4 = new BigDecimal(data[4]);
        System.out.println(f0.compareTo(f1));
        System.out.println(f1.compareTo(f2));
        System.out.println(f1.compareTo(f3));
        System.out.println(f3);
        System.out.println(f4);
    }
}
