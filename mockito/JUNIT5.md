#annotations
@TestInstance(PER_CLASS)
// only one test instance class will be created, states shared

@TestInstance(PER_METHOD) default
// default mode = no this annotation in front of class keyword 
each method call will create a separate test instance for that

@Before @After
// Junit 4 annotations can't be used with junit5 version

@BeforeAll @AfterAll
// Junit 5, requires PER_CLASS to share states

@BeforeEach @AfterEach
// Junit 5, method based