package multimap;

import com.google.common.collect.ArrayListMultimap;

import java.util.Collection;

import static java.util.Arrays.asList;

/**
 * save list as map value
 */
public class ArrayListMapExample {
    public static void main(String[] args) {
        ArrayListMultimap<String, String> map = ArrayListMultimap.create();
        String key = "identifier001";
        Collection<String> fieldNames = asList("NAV", "CLIENT", "PRICE");
        map.putAll(key, fieldNames);
        System.out.println("map = " + map);
    }
}
