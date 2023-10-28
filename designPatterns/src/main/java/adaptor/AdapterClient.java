package adaptor;

public class AdapterClient {
    private static Adaptor adaptor;

    public static void main(String[] args) {
        adaptor = new AdaptorImpl(new AdapteeImpl());
        adaptor.fitClient();
    }
}
