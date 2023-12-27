package functional.customize;

public class TriFunctionalComputeFormula {
    public static void main(String[] args) {
        TriFunctional<Integer, Integer, Integer, Integer> triFunc =
                (x, y, z) -> x * y + z;
        Integer y = triFunc.apply(1, 5, 7);
        // y = 1 * 5 + 7 = 12
        System.out.println("y = " + y);
    }
}
