package nullity;


import lombok.NonNull;

public class LombokNullity {
    public static void printString(@NonNull String s) {
        System.out.println(s);
    }
}
