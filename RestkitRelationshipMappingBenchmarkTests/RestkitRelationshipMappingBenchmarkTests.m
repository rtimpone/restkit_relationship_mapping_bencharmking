//
//  RestkitRelationshipMappingBenchmarkTests.m
//  RestkitRelationshipMappingBenchmarkTests
//
//  Created by Rob Timpone on 8/20/14.
//
//

#import "NetworkManager.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import <XCTest/XCTest.h>

@interface RestkitRelationshipMappingBenchmarkTests : XCTestCase
@property (nonatomic) BOOL requestComplete;
@end

@implementation RestkitRelationshipMappingBenchmarkTests

//a static array to hold strings representing test outcomes
static NSMutableArray *testResults;

//This is called once at the start of the test suite
+ (void)setUp
{
    //setup restkit and network manager singleton
    [NetworkManager setupRestKit];
    [NetworkManager sharedInstance];
    
    testResults = [NSMutableArray new];
}

//This is called before each individual test
- (void)setUp
{
    [super setUp];
    
    //reset the request complete flag after each test is run
    self.requestComplete = NO;
}

//This is called once after all tests have finished
+ (void)tearDown
{
    [super tearDown];
    [self printTestResults];
}

#pragma mark - Relationship Mapping Test Cases
//These tests parse and map json responses with 500, 1000, and 5000 students, each with 10-15 classes, using RestKit relationship mapping
//Relationships are established using addRelationshipMappingWithSourceKeyPath in the RMBStudent class's object mapping
- (void)test500StudentsWithRelationshipMapping
{
    [self runTestForNumberOfStudents: 500 usingRelationshipMapping: YES];
}

- (void)test1000StudentsWithRelationshipMapping
{
    [self runTestForNumberOfStudents: 1000 usingRelationshipMapping: YES];
}

- (void)test5000StudentsWithRelationshipMapping
{
    [self runTestForNumberOfStudents: 5000 usingRelationshipMapping: YES];
}

#pragma mark - Non-Relationship Mapping Test Cases
//These tests parse and map json responses with 500, 1000, and 5000 students, each with 10-15 classes, without using RestKit relationship mapping
//Relationships are instead established by manually parsing the response dictionary using setWillMapDeserializedResponseBlock, and assigning an array of RMBClasses to each RMBStudent
- (void)test500StudentsWithoutRelationshipMapping
{
    [self runTestForNumberOfStudents: 500 usingRelationshipMapping: NO];
}

- (void)test1000StudentsWithoutRelationshipMapping
{
    [self runTestForNumberOfStudents: 1000 usingRelationshipMapping: NO];
}

- (void)test5000StudentsWithoutRelationshipMapping
{
    [self runTestForNumberOfStudents: 5000 usingRelationshipMapping: NO];
}

#pragma mark - Large Data Set Test Cases
//These large data set tests are very time consuming when testing on an actual device
//Uncomment these tests to run them as part of the test suite
//- (void)test10000StudentsWithRelationshipMapping
//{
//    [self runTestForNumberOfStudents: 10000 usingRelationshipMapping: YES];
//}
//
//- (void)test10000StudentsWithoutRelationshipMapping
//{
//    [self runTestForNumberOfStudents: 10000 usingRelationshipMapping: NO];
//}

#pragma mark - Helpers
- (void)runTestForNumberOfStudents: (NSInteger)numberOfStudents usingRelationshipMapping: (BOOL)useRelationshipMapping
{
    NSTimeInterval timeElapsed = [self getNumberOfStudents: numberOfStudents usingRelationshipMapping: useRelationshipMapping];
    NSString *testResult = [NSString stringWithFormat: @"Mapping %ld students %@ relationship mapping: %f", (long)numberOfStudents, useRelationshipMapping ? @"with" : @"without", timeElapsed];
    [testResults addObject: testResult];
}

//Makes a fake API request that receives one of the json files as a response and parses and maps it
- (NSTimeInterval)getNumberOfStudents: (NSInteger)numberOfStudents usingRelationshipMapping: (BOOL)useRelationshipMapping
{
    //the file to use as the response depends on the number of students requested
    NSString *responseFileName = [NSString stringWithFormat: @"%ld_students.json", (long)numberOfStudents];
    
    //return a successful (200) json response for all requests to host "www.example.com"
    [OHHTTPStubs stubRequestsPassingTest: ^BOOL(NSURLRequest *request) {
        return [request.URL.host isEqualToString: @"www.example.com"];
    } withStubResponse: ^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithFileAtPath: OHPathForFileInBundle(responseFileName, nil)
                                                statusCode: 200
                                                   headers: @{ @"Content-Type" : @"application/json" }];
    }];
    
    //mark the time before the api request
    NSDate *startDate = [NSDate date];
    
    //make an api request - this will be intercepted by OHHTTPStubs and return the json file specified above as a successful (200) response
    if (useRelationshipMapping)
    {
        [[NetworkManager sharedInstance] getStudentsMappingUsingRelationshipMappingWithCallback: @selector(getStudentsCallback:error:) sender: self];
    }
    else
    {
        [[NetworkManager sharedInstance] getStudentsMappingWithoutUsingRelationshipMappingWithCallback: @selector(getStudentsCallback:error:) sender: self];
    }
    
    //stay in run loop until mapping is finished
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];
    while (!self.requestComplete && [theRL runMode: NSDefaultRunLoopMode beforeDate: [NSDate distantFuture]]);
    
    //return the number of seconds elapsed since the api call
    return -[startDate timeIntervalSinceNow];
}

//Prints the contents of the static testResults array, which contains strings representing the outcome of each test
+ (void)printTestResults
{
    NSLog(@" ");
    NSLog(@"===========================================================================================");
    
    //print test results summary to the console
    for (NSString *testResult in testResults)
    {
        NSLog(@"%@", testResult);
    }
    
    NSLog(@"===========================================================================================");
    NSLog(@" ");
}

#pragma mark - Callbacks
//Mark the request as complete, which will let the test exit the run loop and finish
- (void)getStudentsCallback: (NSArray *)students error: (NSError *)error
{
    self.requestComplete = YES;
}

@end
