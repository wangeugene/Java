package adaptor;

public class AdapteeImpl implements Adaptee {
    @Override
    public void notFitClient(){
        System.out.println("Not Fit Client");
    }
}
