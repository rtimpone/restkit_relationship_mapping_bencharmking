//
//  RMBStudent.m
//  RKRelationshipMappingBenchmark
//
//  Created by Rob Timpone on 8/20/14.
//  Copyright (c) 2014 RECSOLU. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "RMBClass.h"
#import "RMBStudent.h"

@implementation RMBStudent

+ (RKObjectMapping *)objectMappingWithRelationshipMapping
{
    RKObjectMapping *studentMapping = [RKObjectMapping mappingForClass: [RMBStudent class]];
    [studentMapping addAttributeMappingsFromDictionary: @{@"id" : @"studentId",
                                                          @"first_name" : @"firstName",
                                                          @"last_name" : @"lastName"}];
    [studentMapping addRelationshipMappingWithSourceKeyPath: @"classes" mapping: [RMBClass objectMapping]];
    return studentMapping;
}

+ (RKObjectMapping *)objectMappingWithoutRelationshipMapping
{
    RKObjectMapping *studentMapping = [RKObjectMapping mappingForClass: [RMBStudent class]];
    [studentMapping addAttributeMappingsFromDictionary: @{@"id" : @"studentId",
                                                          @"first_name" : @"firstName",
                                                          @"last_name" : @"lastName"}];
    return studentMapping;
}

+ (RKResponseDescriptor *)responseDescriptorWithRelationshipMapping
{
    return [RKResponseDescriptor responseDescriptorWithMapping: [RMBStudent objectMappingWithRelationshipMapping]
                                                        method: RKRequestMethodGET
                                                   pathPattern: @"students/with_relationship_mapping"
                                                       keyPath: @"students"
                                                   statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor *)responseDescriptorWithoutRelationshipMapping
{
    return [RKResponseDescriptor responseDescriptorWithMapping: [RMBStudent objectMappingWithoutRelationshipMapping]
                                                        method: RKRequestMethodGET
                                                   pathPattern: @"students/without_relationship_mapping"
                                                       keyPath: @"students"
                                                   statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

@end
