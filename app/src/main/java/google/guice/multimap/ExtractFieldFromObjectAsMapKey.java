package google.guice.multimap;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Maps;

import java.util.ArrayList;
import java.util.List;

/**
 * derive key directly from value object
 */
public class ExtractFieldFromObjectAsMapKey {
    public static void main(String[] args) {
        List<Color> colors = new ArrayList<>();
        colors.add(new Color("red", 255, 0, 0));
        colors.add(new Color("green", 0, 255, 0));

        ImmutableMap<String, Color> map = Maps.uniqueIndex(colors, Color::getName);
        System.out.println("map = " + map);
    }
}
