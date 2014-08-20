RestKit Relationship Mapping Benchmarking
=========================================

A test suite to compare RestKit's nested relationship mapping vs. manually mapping a deserialized response body

To run the project:
1. Clone the project
2. Run `pod install` on the command line to setup the workspace
3. Open the workspace and use command-u to run the tests
4. The time elapsed for each test will be printed to the console when the tests complete

Each test uses RestKit to make an API call that is intercepted by OHHTTPStubs, which returns a 200 response and a json test fixture that serves as the response.  If the test is using RestKit's relationship mapping, RestKit establishes relationships between students and classes using addRelationshipMappingWithSourceKeyPath:mapping:.  If the test does not use RestKit's mapping, setWillMapDeserializedResponseBlock: is used to manually parse the deserializedResponseBody before mapping, and classes are assigned to students in setCompletionBlockWithSuccess:.  

The data model used in this project is fairly simple.  Each student has an id, first name, last name, and an array of 10-15 classes.  Each class has a class id, a name, and a grade.  The json fixtures included in the project were randomly generated using a ruby script.  

The project comes with 4 pairs of tests for 500, 1000, 5000, and 10000 students in a json response.  The 10,000 student tests are commented out due to the amount of time they take to complete when running tests on an actual device. 

Here are examples of test results on various devices:

iPhone 5S
Mapping 500 students without relationship mapping: 0.796878

Mapping 500 students with relationship mapping: 6.845290

Mapping 1000 students without relationship mapping: 1.768241

Mapping 1000 students with relationship mapping: 13.748651

Mapping 5000 students without relationship mapping: 7.852664

Mapping 5000 students with relationship mapping: 68.060347

iPod 5th Gen
Mapping 500 students without relationship mapping: 0.800056
Mapping 500 students with relationship mapping: 6.883298
Mapping 1000 students without relationship mapping: 1.747130
Mapping 1000 students with relationship mapping: 13.783035
Mapping 5000 students without relationship mapping: 7.844685
Mapping 5000 students with relationship mapping: 68.331392

iPhone Simulator 64-bit
Mapping 500 students without relationship mapping: 0.110703
Mapping 500 students with relationship mapping: 0.898177
Mapping 1000 students without relationship mapping: 0.283562
Mapping 1000 students with relationship mapping: 1.564621
Mapping 5000 students without relationship mapping: 0.910137
Mapping 5000 students with relationship mapping: 7.806178
