//
//  NetworkManager.h
//  RKRelationshipMappingBenchmark
//
//  Created by Rob Timpone on 8/20/14.
//  Copyright (c) 2014 RECSOLU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (instancetype)sharedInstance;
+ (void)setupRestKit;

- (void)getStudentsMappingUsingRelationshipMappingWithCallback: (SEL)callback sender: (id)sender;
- (void)getStudentsMappingWithoutUsingRelationshipMappingWithCallback: (SEL)callback sender: (id)sender;

@end
