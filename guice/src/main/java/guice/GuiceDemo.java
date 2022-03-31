package guice;

import com.google.inject.AbstractModule;
import com.google.inject.Guice;
import com.google.inject.Injector;
import com.google.inject.Provides;

import javax.inject.Inject;
import javax.inject.Qualifier;
import java.lang.annotation.Retention;

import static java.lang.annotation.RetentionPolicy.RUNTIME;

public class GuiceDemo {
    @Qualifier
    @Retention(RUNTIME)
    @interface Message{};

    @Qualifier
    @Retention(RUNTIME)
    @interface Count{};

    static class DemoModule extends AbstractModule{
        @Provides
        @Count
        static Integer provideCount(){
            return 3;
        }

        @Provides
        @Message
        static String provideMessage(){
            return "hello world";
        }
    }

    static class Greeter{
        public final String message;
        public final int count;

        @Inject
        Greeter(@Message String message, @Count int count) {
            this.message = message;
            this.count = count;
        }

        void sayHello(){
            for (int i = 0; i < count; i++) {
                System.out.println(message);
            }
        }
    }

    public static void main(String[] args) {
        Injector injector = Guice.createInjector(new DemoModule());
        Greeter greeter = injector.getInstance(Greeter.class);
        greeter.sayHello();
    }
}
