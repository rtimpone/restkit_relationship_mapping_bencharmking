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
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString: @"http://www.example.com/students/without_relationship_mapping"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest: request
                                                                                        success: ^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            
                                                                                            NSDictionary *responseDictionary = (NSDictionary *)JSON;
                                                                                            NSArray *attendeeDictionaries = responseDictionary[@"students"];
                                                                                            
                                                                                            NSMutableArray *attendees = [@[] mutableCopy];
                                                                                            for (NSDictionary *attendeeDictionary in attendeeDictionaries)
                                                                                            {
                                                                                                [attendees addObject: [RMBStudent studentFromDictionary: attendeeDictionary]];
                                                                                            }
                                                                                            
                                                                                            [sender performSelector: callback withObject: attendees withObject: nil];
                                                                                        }
                                                                                        failure: ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                                            [sender performSelector: callback withObject: nil withObject: error];
                                                                                        }];
    [operation start];
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
    [[RKObjectManager sharedManager] addResponseDescriptor: [RMBStudent responseDescriptor]];
}

@end
