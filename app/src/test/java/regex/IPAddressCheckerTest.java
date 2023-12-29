package regex;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class IPAddressCheckerTest {
    @Test
    void testIsValidIPAddress() {
        String[] ips = {"000.12.12.034", "121.234.12.12", "23.45.12.56", "00.12.123.123123.123", "122.23", "Hello.IP"};
        boolean[] expected = {true, true, true, false, false, false};
        for (int i = 0; i < ips.length; i++) {
            assertEquals(expected[i], IPAddressChecker.isValidIPAddress(ips[i]));
        }
    }
}