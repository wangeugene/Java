package multimap;

import lombok.Data;

/**
 * Created by IntelliJ IDEA.<br/>
 *
 * @author: Eugene_Wang<br />
 * Date: 3/20/2022<br/>
 * Time: 11:43 AM<br/>
 * To change this template use File | Settings | File Templates.
 */
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

    public String getName() {
        return name;
    }
}
