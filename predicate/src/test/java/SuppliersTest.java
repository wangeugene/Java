import org.junit.jupiter.api.Test;

import java.util.function.Supplier;

public class SuppliersTest {
    public double squareLazy(Supplier<Double> lazyValue) {
        return Math.pow(lazyValue.get(), 2);
    }
    @Test
    void suppliers() {
        Supplier<Double> lazyValue = () -> {
            try {
                Thread.sleep(100 );
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            return 9d;
        };
        Double valueSquared = squareLazy(lazyValue);
        System.out.println(valueSquared);
    }
}
