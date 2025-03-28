### Construction:

1. Extend Thread
2. Implement Runnable
3. Implement Callable

### 6 Statuses

New,Running,Blocked,Waiting,Timed-Wait,Terminated.

### Start

call threadObject.start() for a single thread

### ThreadPool

The `Executors` class is a static utility classes to trigger
But not recommended to use, because it used an unbounded linked list as work queue for thread objects.
MaximumPoolSize = workQueueSize + corePoolSize

### Synchronized vs ReentrantLock

Synchronized: built-in keyword, unfair lock, can be used to define method or code block,
Reentrant Lock: a class in JDK, unfair lock & fair lock, finer-granular control, built upon inner abstract class
AQS -> AbstractQueuedSynchronizer, tryLock() & lock() : async & syn, under the hood is compare and set

### Locks

Class-level lock: static synchronized
Object-level lock: synchronized

### wait vs sleep

wait: non-static method should be only called from a synchronized context will release the lock
sleep: static method, no need to be called from a synchronized context, won't release the lock

### notify vs notifyAll

notify: sending notification to a single thread waiting on the object's monitor
notifyAll: sending notification to all threads waiting on the object's monitor

### inter-thread communicating

wait,notify,notifyAll

### volatile

can be used to describe with variables only, all threads read its value from the main memory rather than
CPU cache, so each thread can get an updated value of the variable

### thread starvation

because the current thread is of low priority can't get the CPU resource to execute

### LiveLock

the states of threads change between one another without making any progress

### BlockingQueue

Thread-Safe Queue used to implement

### scheduling goals

fairness
wait time

### What's the difference between a thread in wait status or in block status?

WAIT & TIMED_WAIT are Java unique thread statuses in addition to the standard four thread statuses:
NEW, RUNNABLE, BLOCKED, TERMINATED;

### Why should you avoid using Java's synchronized statement on an immutable object such as an Integer?

If you change that variable's value, you will be synchronized to a different object

If you run multiple Java applications at the same time, they will execute in separate JVM processes