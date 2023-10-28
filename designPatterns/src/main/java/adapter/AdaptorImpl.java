package adapter;

public class AdaptorImpl implements Adaptor {
    private Adaptee adaptee;

    public AdaptorImpl(Adaptee adaptee) {
        this.adaptee = adaptee;
    }

    @Override
    public void fitClient() {
        adaptee.notFitClient();
        System.out.println("fit Client");
    }
}
