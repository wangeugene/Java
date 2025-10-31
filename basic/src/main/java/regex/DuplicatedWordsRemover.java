package regex;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class DuplicatedWordsRemover {
    private final static String WORD_REMOVER_REGEX = "\\b(\\w+)(\\W+\\1\\b)+";
    private final static Pattern pattern = Pattern.compile(WORD_REMOVER_REGEX, Pattern.CASE_INSENSITIVE);


    /**
     * \\b matches a word boundary, which is the position between a word character (\\w)
     * (\\w+) matches one or more word characters and captures them in group 1
     * \\W+ matches one or more non-word characters
     * \\1 matches the contents of group 1,which is the repeated word
     * \\b matches a word boundary
     *
     * @param lines original string
     * @return cleaned string
     */
    public static String removeDuplicatedWords(List<String> lines) {
        StringBuilder cleaned = new StringBuilder();
        for (String line : lines) {
            Matcher matcher = pattern.matcher(line);
            while (matcher.find()) {
                line = line.replaceAll(matcher.group(), matcher.group(1));
            }
            cleaned.append(line).append("\n");
        }
        return cleaned.toString();
    }
}
