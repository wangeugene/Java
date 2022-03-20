package annotation.inject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by IntelliJ IDEA.<br/>
 *
 * @author: Eugene_Wang<br />
 * Date: 3/20/2022<br/>
 * Time: 8:29 PM<br/>
 * To change this template use File | Settings | File Templates.
 */
public class MyDictionary {
    Map<String, String> wordMap;

    public MyDictionary() {
        wordMap = new HashMap<String, String>();
    }

    public void add(final String word, final String meaning) {
        wordMap.put(word, meaning);
    }

    public String getMeaning(final String word) {
        return wordMap.get(word);
    }
}
