package mockito;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Created by IntelliJ IDEA.<br/>
 *
 * Date: 3/20/2022<br/>
 * Time: 7:35 PM<br/>
 * To change this template use File | Settings | File Templates.
 */
@ExtendWith(MockitoExtension.class)
class MethodStubTest {
    @Mock
    List<String> list;

    @Test
    void testVerifyMethodCall() {
        list.add("one");
        Mockito.verify(list).add("one");
        assertEquals(0, list.size());

    }

    @Test
    void testMethodStub() {
        Mockito.when(list.size()).thenReturn(100);
        assertEquals(100, list.size());
    }
}
