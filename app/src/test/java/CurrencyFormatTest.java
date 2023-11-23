import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;

import java.text.NumberFormat;
import java.util.Locale;

class CurrencyFormatTest {

    @Test
    void testCustomizedCurrencyFormat() {
        NumberFormat us = NumberFormat.getCurrencyInstance(Locale.US);
        NumberFormat china = NumberFormat.getCurrencyInstance(Locale.CHINA);
        NumberFormat india = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
        double amount = 12324.34;
        "Com".compareTo("B");
        Assertions.assertEquals("$12,324.34", us.format(amount));
        Assertions.assertEquals("¥12,324.34", china.format(amount));
        Assertions.assertEquals("₹12,324.34", india.format(amount));
    }
}
