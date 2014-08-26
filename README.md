RestKit Relationship Mapping Benchmarking
=========================================

A test suite to benchmark RestKit's nested relationship mapping vs. manually mapping a deserialized response body.  Some projects I'm working on are taking a very long time to map nested one-to-many relationships using RestKit, and I'd really appreciate any feedback or tips to make the mapping process more performant.  

To run the project:
- Clone the Xcode project
- Run `pod install` on the command line to setup the workspace
- Open the workspace and use command-u to run the tests
- The time elapsed for each test will be printed to the Xcode console when the tests complete

Each test uses RestKit to make a fake API call that is intercepted by OHHTTPStubs, which returns a 200 response and a json test fixture that serves as the response body.  If the test is using RestKit's relationship mapping, RestKit establishes relationships between students and classes using addRelationshipMappingWithSourceKeyPath:mapping:.  If the test does not use RestKit's mapping, setWillMapDeserializedResponseBlock: is used to manually parse the deserializedResponseBody before mapping, and classes are assigned to students in setCompletionBlockWithSuccess:.  See the NetworkManager class for details on how this works.

This project **does not use core data**, objects are just stored in memory.

The data model used in this project is fairly simple.  Each student has an id, first name, last name, and an array of 10-15 classes.  Each class has an id, a name, and a grade.  

The project comes with 4 pairs of tests for 500, 1,000, 5,000, and 10,000 students in a json response.  The 10,000 student tests are commented out due to the amount of time they take to complete when running tests on an actual device. 

Here are example test results from an iPod Touch:

- Mapping 500 students with relationship mapping: 6.9 sec
- Mapping 500 students without relationship mapping: 0.3 sec
- Mapping 1,000 students with relationship mapping: 13.7 sec
- Mapping 1,000 students without relationship mapping: 0.8 sec
- Mapping 5,000 students with relationship mapping: 68.4 sec
- Mapping 5,000 students without relationship mapping: 3.2 sec
