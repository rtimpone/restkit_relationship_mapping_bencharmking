//
//  RMBStudent.h
//  RKRelationshipMappingBenchmark
//
//  Created by Rob Timpone on 8/20/14.
//  Copyright (c) 2014 RECSOLU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKResponseDescriptor;

@interface RMBStudent : NSObject

@property (strong, nonatomic) NSNumber *studentId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSArray *classes;

+ (RKResponseDescriptor *)responseDescriptor;
+ (RMBStudent *)studentFromDictionary: (NSDictionary *)studentDictionary;

@end
