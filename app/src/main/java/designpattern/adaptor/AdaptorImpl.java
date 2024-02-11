package designpattern.adaptor;

public class AdaptorImpl implements Adaptor {
    private final Adaptee adaptee;

    public AdaptorImpl(Adaptee adaptee) {
        this.adaptee = adaptee;
    }

    @Override
    public void fitClient() {
        adaptee.notFitClient();
        System.out.println("fit Client");
    }
}
