package functional.customize;

public interface TriFunctional<T, U, V, R> {
    R apply(T t, U u, V v);
}
