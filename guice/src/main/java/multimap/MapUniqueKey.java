package multimap;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.Maps;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class MapUniqueKey {
    public static void main(String[] args) {
        List<Color> colors = new ArrayList<>();
        colors.add(new Color("red", 255, 0, 0));
        colors.add(new Color("green", 0, 255, 0));

        ImmutableMap<String, Color> stringColorImmutableMap = Maps.uniqueIndex(colors, Color::getName);
        for (Map.Entry<String, Color> entry : stringColorImmutableMap.entrySet()) {
            System.out.println(entry.getKey() + " : " + entry.getValue());
        }
    }
}
