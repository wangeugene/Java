package functional.customize;

public class TriFunctionPrinter {
    public static void main(String[] args) {
        TriFunction<Integer, Integer, Integer, Integer> triFunc =
                (x, y, z) -> x * y + z;
        Integer y = triFunc.apply(1, 5, 7);
        // y = 1 * 5 + 7 = 12
        System.out.println("y = " + y);
    }
}
