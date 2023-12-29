package time;

import org.junit.jupiter.api.Test;

import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.Month;

import static org.junit.jupiter.api.Assertions.assertEquals;

class LocalDateTimeTest {
    @Test
    void testWeekDay() {
        LocalDateTime localDateTime = LocalDateTime.of(2023, Month.of(11), 19, 10, 0);
        DayOfWeek dayOfWeek = localDateTime.getDayOfWeek();
        assertEquals(dayOfWeek, DayOfWeek.SUNDAY);
    }
}
