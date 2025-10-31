package enumeration;

import lombok.Getter;

@Getter
public enum Fruit {
    APPLE("Apple"), BANANA("Banana"), ORANGE("Orange");
    private final String name;

    Fruit(String name) {
        this.name = name;
    }
}
