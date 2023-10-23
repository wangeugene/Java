package singleton;

public class SingletonClient {
    public static void main(String[] args) {
        Singleton singleton = Singleton.getSingleton();
        singleton.SayMyName();
    }
}
