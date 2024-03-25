package designpattern.adaptor;

public class AdapterClient {
    public static void main(String[] args) {
        Adaptor adaptor = new AdaptorImpl(new AdapteeImpl());
        adaptor.fitClient();
    }
}
