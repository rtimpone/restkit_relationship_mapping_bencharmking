//
//  RMBClass.m
//  RKRelationshipMappingBenchmark
//
//  Created by Rob Timpone on 8/20/14.
//  Copyright (c) 2014 RECSOLU. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "RMBClass.h"

@implementation RMBClass

+ (RKObjectMapping *)objectMapping
{
    RKObjectMapping *classMapping = [RKObjectMapping mappingForClass: [RMBClass class]];
    [classMapping addAttributeMappingsFromDictionary: @{@"id" : @"classId",
                                                        @"name" : @"name",
                                                        @"grade" : @"grade"}];
    return classMapping;
}

@end