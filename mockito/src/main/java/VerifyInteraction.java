import java.util.List;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

/**
 * Created by IntelliJ IDEA.<br/>
 *
 * @author: Eugene_Wang<br />
 * Date: 3/20/2022<br/>
 * Time: 12:36 PM<br/>
 * To change this template use File | Settings | File Templates.
 */
public class VerifyInteraction {
    public static void main(String[] args) {
        List mockedList = mock(List.class);
        mockedList.add("one");
        mockedList.clear();

        verify(mockedList).add("one");
        verify(mockedList).clear();
    }
}
