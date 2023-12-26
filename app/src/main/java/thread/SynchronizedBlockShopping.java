package thread;

import static java.lang.System.out;

class SynchronizedBlockShopper extends Thread {
    static int garlicCount = 0;
    static int potatoCount = 0;

    private static final Object garlicLock = new Object();

    /**
     * /Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home/bin/java -javaagent:/Applications/IntelliJ IDEA.app/Contents/lib/idea_rt.jar=50435:/Applications/IntelliJ IDEA.app/Contents/bin -Dfile.encoding=UTF-8 -classpath /Users/eugene/IdeaProjects/Java/app/out/production/classes:/Users/eugene/IdeaProjects/Java/app/out/production/resources:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.apache.commons/commons-text/1.10.0/3363381aef8cef2dbc1023b3e3a9433b08b64e01/commons-text-1.10.0.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.mapstruct/mapstruct/1.5.5.Final/2ca3cbe39b6e9ea8d5ea521965a89bef2a1e8eeb/mapstruct-1.5.5.Final.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.google.inject/guice/5.1.0/da25056c694c54ba16e78e4fc35f17fc60f0d1b4/guice-5.1.0.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.apache.kafka/kafka-clients/3.6.0/9ec088e4e8f59688c56f6b50a4af6c45df09f51e/kafka-clients-3.6.0.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.launchdarkly/okhttp-eventsource/2.5.0/395b8071cbeb103a3895b67f1c2c3a3f425da375/okhttp-eventsource-2.5.0.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.squareup.okhttp3/okhttp/4.9.3/b0b14b3d12980912723fb8b66afb48dcda742fcb/okhttp-4.9.3.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.apache.logging.log4j/log4j-slf4j18-impl/2.14.0/4166b0ea2d00acce2d68aacf30f6806ebce9024e/log4j-slf4j18-impl-2.14.0.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.slf4j/slf4j-api/2.0.0-alpha1/e979781e847d44d3618c4479d438956593b6b080/slf4j-api-2.0.0-alpha1.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.google.code.gson/gson/2.8.9/8a432c1d6825781e21a02db2e2c33c5fde2833b9/gson-2.8.9.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.fasterxml.jackson.core/jackson-databind/2.15.1/ac9ba74d208faf356e4719a49e59c6ea9237c01d/jackson-databind-2.15.1.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.apache.commons/commons-lang3/3.12.0/c6842c86792ff03b9f1d1fe2aab8dc23aa6c6f0e/commons-lang3-3.12.0.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/javax.inject/javax.inject/1/6975da39a7040257bd51d21a231b76c915872d38/javax.inject-1.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/aopalliance/aopalliance/1.0/235ba8b489512805ac13a8f9ea77a1ca5ebe3e8/aopalliance-1.0.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.google.guava/guava/30.1-jre/d0c3ce2311c9e36e73228da25a6e99b2ab826f/guava-30.1-jre.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib-jdk8/1.6.10/e80fe6ac3c3573a80305f5ec43f86b829e8ab53d/kotlin-stdlib-jdk8-1.6.10.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.squareup.okio/okio/2.8.0/49b64e09d81c0cc84b267edd0c2fd7df5a64c78c/okio-jvm-2.8.0.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib/1.6.10/b8af3fe6f1ca88526914929add63cf5e7c5049af/kotlin-stdlib-1.6.10.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.apache.logging.log4j/log4j-api/2.14.0/23cdb2c6babad9b2b0dcf47c6a2c29d504e4c7a8/log4j-api-2.14.0.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.fasterxml.jackson.core/jackson-annotations/2.15.1/92a90d3739e970e03b5971839e4fe51f13c1fa3/jackson-annotations-2.15.1.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.fasterxml.jackson.core/jackson-core/2.15.1/241c054ba8503de092a12acad9f083dd39935cc0/jackson-core-2.15.1.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.google.guava/failureaccess/1.0.1/1dcf1de382a0bf95a3d8b0849546c88bac1292c9/failureaccess-1.0.1.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.google.guava/listenablefuture/9999.0-empty-to-avoid-conflict-with-guava/b421526c5f297295adef1c886e5246c39d4ac629/listenablefuture-9999.0-empty-to-avoid-conflict-with-guava.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.google.code.findbugs/jsr305/3.0.2/25ea2e8b0c338a877313bd4672d3fe056ea78f0d/jsr305-3.0.2.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.checkerframework/checker-qual/3.5.0/2f50520c8abea66fbd8d26e481d3aef5c673b510/checker-qual-3.5.0.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.google.errorprone/error_prone_annotations/2.3.4/dac170e4594de319655ffb62f41cbd6dbb5e601e/error_prone_annotations-2.3.4.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.google.j2objc/j2objc-annotations/1.3/ba035118bc8bac37d7eff77700720999acd9986d/j2objc-annotations-1.3.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib-jdk7/1.6.10/e1c380673654a089c4f0c9f83d0ddfdc1efdb498/kotlin-stdlib-jdk7-1.6.10.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.jetbrains.kotlin/kotlin-stdlib-common/1.6.10/c118700e3a33c8a0d9adc920e9dec0831171925/kotlin-stdlib-common-1.6.10.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.jetbrains/annotations/13.0/919f0dfe192fb4e063e7dacadee7f8bb9a2672a9/annotations-13.0.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/com.github.luben/zstd-jni/1.5.5-1/fda1d6278299af27484e1cc3c79a060e41b7ef7e/zstd-jni-1.5.5-1.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.lz4/lz4-java/1.8.0/4b986a99445e49ea5fbf5d149c4b63f6ed6c6780/lz4-java-1.8.0.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.xerial.snappy/snappy-java/1.1.10.4/50d0390056017158bdc75c063efd5c2a898d5f0c/snappy-java-1.1.10.4.jar:/Users/eugene/.gradle/caches/modules-2/files-2.1/org.apache.logging.log4j/log4j-core/2.14.0/e257b0562453f73eabac1bc3181ba33e79d193ed/log4j-core-2.14.0.jar thread.SynchronizedBlockShopping
     * The final garlic count is: 40000000
     * The final potato count is: 20000000
     * Elapsed time: 605 ms
     */
    @Override
    public void run() {
        for (int i = 0; i < 10_000_000; i++) {
            addPotato();
            addGarlic();
        }
    }

    private void addGarlic() {
        synchronized (garlicLock) {
            garlicCount++;
        }
    }

    private void addPotato() {
        synchronized (garlicLock) {
            potatoCount++;
            addGarlic();
        }
    }
}

public class SynchronizedBlockShopping {
    public static void main(String[] args) throws InterruptedException {
        Thread bran = new SynchronizedBlockShopper();
        Thread olivia = new SynchronizedBlockShopper();
        long start = System.currentTimeMillis();
        bran.start();
        olivia.start();
        bran.join();
        olivia.join();
        long end = System.currentTimeMillis();
        out.printf("The final garlic count is: %d %nThe final potato count is: %d%n", SynchronizedBlockShopper.garlicCount, SynchronizedBlockShopper.potatoCount);
        out.println("Elapsed time: " + (end - start) + " ms");
    }
}
