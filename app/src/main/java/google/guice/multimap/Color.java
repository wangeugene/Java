package google.guice.multimap;

import lombok.Data;

@Data
public class Color {
    String name;
    int r;
    int g;
    int b;

    public Color(String name, int r, int g, int b) {
        this.name = name;
        this.r = r;
        this.g = g;
        this.b = b;
    }

    @Override
    public String toString() {
        return String.format("%s %s %s %s", name, r, g, b);
    }
}
