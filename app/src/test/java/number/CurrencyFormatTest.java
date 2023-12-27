package number;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.text.NumberFormat;
import java.util.Locale;

class CurrencyFormatTest {

    /**
     * NBSP: Non-breaking space
     */
    @Test
    void testCustomizedCurrencyFormat() {
        NumberFormat us = NumberFormat.getCurrencyInstance(Locale.US);
        NumberFormat china = NumberFormat.getCurrencyInstance(Locale.CHINA);
        NumberFormat india = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
        double amount = 12324.34;
        Assertions.assertEquals("$12,324.34", us.format(amount));
        Assertions.assertEquals("￥12,324.34", china.format(amount));
        Assertions.assertEquals("₹ 12,324.34", india.format(amount));
    }
}
