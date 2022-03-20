import java.util.LinkedList;
import java.util.List;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

/**
 * Created by IntelliJ IDEA.<br/>
 *
 * @author: Eugene_Wang<br />
 * Date: 3/20/2022<br/>
 * Time: 12:38 PM<br/>
 * To change this template use File | Settings | File Templates.
 */
public class StubMethodCall {
    public static void main(String[] args) {
        LinkedList mockedList = mock(LinkedList.class);
        when(mockedList.get(0)).thenReturn("First");
        System.out.println(mockedList.get(0));
        System.out.println(mockedList.get(999));
    }
}
