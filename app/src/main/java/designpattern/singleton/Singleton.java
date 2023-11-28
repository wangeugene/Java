package designpattern.singleton;

public class Singleton {
    private Singleton() {
    }
    private volatile static Singleton singleton = new Singleton();

    public static Singleton getSingleton() {
        if(singleton == null){
            synchronized (Singleton.class){
                if(singleton == null){
                    singleton = new Singleton();
                }
                return singleton;
            }
        }else{
            return singleton;
        }
    }

    protected void SayMyName(){
        System.out.println("My name is Singleton");
    }
}
