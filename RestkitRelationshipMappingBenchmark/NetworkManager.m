//
//  NetworkManager.m
//  RKRelationshipMappingBenchmark
//
//  Created by Rob Timpone on 8/20/14.
//  Copyright (c) 2014 RECSOLU. All rights reserved.
//

#import "NetworkManager.h"
#import <RestKit/RestKit.h>
#import "RMBClass.h"
#import "RMBStudent.h"

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation NetworkManager

+ (instancetype)sharedInstance
{
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkManager alloc] init];
    });
    return sharedInstance;
}

- (void)getStudentsMappingUsingRelationshipMappingWithCallback: (SEL)callback sender: (id)sender
{
    [[RKObjectManager sharedManager] getObjectsAtPath: @"students/with_relationship_mapping"
                                           parameters: nil
                                              success: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  
                                                  //the callback takes two parameters, a success object and an error, one of which will be nil
                                                  [sender performSelector: callback withObject: mappingResult.array withObject: nil];
                                              }
                                              failure: ^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  //the callback takes two parameters, a success object and an error, one of which will be nil
                                                  [sender performSelector: callback withObject: nil withObject: error];
                                              }];
}

- (void)getStudentsMappingWithoutUsingRelationshipMappingWithCallback: (SEL)callback sender: (id)sender
{
    RKObjectRequestOperation *operation = [[RKObjectManager sharedManager] appropriateObjectRequestOperationWithObject: nil
                                                                                                                method: RKRequestMethodGET
                                                                                                                  path: @"students/without_relationship_mapping"
                                                                                                            parameters: nil];
    
    //a dictionary where each key is a student id that maps to an array of RMBClass objects
    NSMutableDictionary *studentIdToClassesDictionary = [@{} mutableCopy];
    
    [operation setWillMapDeserializedResponseBlock: ^id(id deserializedResponseBody) {
        
        NSDictionary *dictionary = (NSDictionary *)deserializedResponseBody;
        
        //get an array of student dictionaries from the response
        NSArray *students = dictionary[@"students"];
        for (NSDictionary *studentDict in students)
        {
            //get the student id and the array of class dictionaries from each student dictionary
            NSNumber *studentId = studentDict[@"id"];
            NSArray *classes = studentDict[@"classes"];

            for (NSDictionary *classDict in classes)
            {
                //instantiate an RMBClass object for each class dictionary
                RMBClass *class = [[RMBClass alloc] init];
                class.classId = classDict[@"id"];
                class.name = classDict[@"name"];
                class.grade = classDict[@"grade"];
                
                //add each new RMBClass to the array of class objects for the current student id
                NSMutableArray *classesForStudent = [studentIdToClassesDictionary[studentId] mutableCopy];
                if (!classesForStudent)
                {
                    classesForStudent = [NSMutableArray new];
                }
                [classesForStudent addObject: class];
                studentIdToClassesDictionary[studentId] = classesForStudent;
            }
        }
        return deserializedResponseBody;
    }];
    
    [operation setCompletionBlockWithSuccess: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {

        //assign the corresponding array of classes created earlier to each student
        for (RMBStudent *student in mappingResult.array)
        {
            student.classes = studentIdToClassesDictionary[student.studentId];
        }

        //the callback takes two parameters, a success object and an error, one of which will be nil
        [sender performSelector: callback withObject: mappingResult.array withObject: nil];
        
    } failure: ^(RKObjectRequestOperation *operation, NSError *error) {
        
        //the callback takes two parameters, a success object and an error, one of which will be nil
        [sender performSelector: callback withObject: nil withObject: error];
    }];
    
    [[RKObjectManager sharedManager] enqueueObjectRequestOperation: operation];
}

+ (void)setupRestKit
{
    //setup an http client with base url
    NSURL *baseUrl = [NSURL URLWithString: @"https://www.example.com/"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL: baseUrl];

    //set shared manager
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient: client];
    [RKObjectManager setSharedManager: objectManager];
    
    //setup response descriptor
    [[RKObjectManager sharedManager] addResponseDescriptor: [RMBStudent responseDescriptorWithRelationshipMapping]];
    [[RKObjectManager sharedManager] addResponseDescriptor: [RMBStudent responseDescriptorWithoutRelationshipMapping]];
}

@end
