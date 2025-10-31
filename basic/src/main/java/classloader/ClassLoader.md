## BootLoader Order

4.User: source can be any
3.Application : classPath, user-defined application code
2.Extension : /lib/ext or system variable points
`above can be created by extending Java.lang.ClassLoader`

1.BootStrap: written in C/C++
`each class loader has its own namespace`

## 双亲委派 Parent Delegation Mechanism

indicate logic inside Java.lang.ClassLoader.loadClass method
When loading a class, a class loader first delegates the search for the class
to its parent class loader before attempting to find the class itself
By default, java.class.path property's value is current directory

### defect:

can't load two identical classpath classes into the JVM default.
e.g. Tomcat web server may need to deploy two web apps which use exactly the same dependency package.
Tomcat override the LoadClass method creating two classes: WebAppClassLoader, SharedClassLoader to overcome this issue
