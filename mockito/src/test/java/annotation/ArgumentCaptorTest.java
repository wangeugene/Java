package annotation;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

@ExtendWith(MockitoExtension.class)
class ArgumentCaptorTest {
    @Mock
    List<String> list;
    @Captor
    ArgumentCaptor<String> argCaptor;

    @Test
    void testInterceptMethodArgument() {
        list.add("one");
        Mockito.verify(list).add(argCaptor.capture());
        assertEquals("one", argCaptor.getValue());
    }
}
