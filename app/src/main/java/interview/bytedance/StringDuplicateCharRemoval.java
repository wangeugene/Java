package interview.bytedance;

import java.util.function.Function;

/**
 * \\w is to match single character
 */
public class StringDuplicateCharRemoval {
    public static void main(String[] args) {
        Function<String, String> changeAAAtoAA
                = s -> s.replaceAll("(\\w)\\1{2,}", "$1$1");
        String text = "xAAAAiOSBobCCC";
        String replacement = changeAAAtoAA.apply(text);
        System.out.println(replacement);

        Function<String, String> changeAABBtoAAB
                = s -> s.replaceAll("(\\w)\\1(\\w)\\2", "$1$1$2");
        String text2 = "xAABBCCoxOOXXi";
        String replacement2 = changeAABBtoAAB.apply(text2);
        System.out.println(replacement2);

        String text3 = text + text2;
        System.out.println(text3);
        String replacement3 = changeAAAtoAA.andThen(changeAABBtoAAB).apply(text3);
        System.out.println(replacement3);
    }
}

