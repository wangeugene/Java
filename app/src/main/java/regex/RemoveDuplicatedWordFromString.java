package regex;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class RemoveDuplicatedWordFromString {
    private static final List<String> strings = List.of(
            "Goodbye bye bye world world world",
            "Sam went went to to to his business",
            "Raya is is the the best player in eye eye game",
            "in inCline",
            "Hello hello Ab aB"
    );

    /**
     * \\b matches a word boundary, which is the position between a word character (\\w)
     * (\\w+) matches one or more word characters and captures them in group 1
     * \\W+ matches one or more non-word characters
     * \\1 matches the contents of group 1,which is the repeated word
     * \\b matches a word boundary
     */
    public static void main(String[] args) {
        String regex = "\\b(\\w+)(\\W+\\1\\b)+";
        Pattern p = Pattern.compile(regex, Pattern.CASE_INSENSITIVE);

        for (String input : strings) {
            Matcher m = p.matcher(input);
            while (m.find()) {
                input = input.replaceAll(m.group(), m.group(1));
            }
            System.out.println(input);
        }
    }
}
