package annotation.inject;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Created by IntelliJ IDEA.<br/>
 * <p>
 * {@code @author:} Eugene_Wang<br />
 * Date: 3/20/2022<br/>
 * Time: 8:29 PM<br/>
 * To change this template use File | Settings | File Templates.
 */
@ExtendWith(MockitoExtension.class)
class WithInjectMocksAnnotationTest {
    @Mock
    Map<String, String> words;

    @InjectMocks
    MyDictionary dictionary = new MyDictionary();

    @Test
    void whenUseInjectMocksAnnotationThenCorrect() {
        Mockito.when(words.get("key")).thenReturn("value");
        assertEquals("value", dictionary.getMeaning("key"));
    }
}
