//
//  RMBClass.h
//  RKRelationshipMappingBenchmark
//
//  Created by Rob Timpone on 8/20/14.
//  Copyright (c) 2014 RECSOLU. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;

@interface RMBClass : NSObject

@property (strong, nonatomic) NSNumber *classId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *grade;

+ (RKObjectMapping *)objectMapping;

@end
