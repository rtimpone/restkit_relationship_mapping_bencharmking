//
//  RMBStudent.m
//  RKRelationshipMappingBenchmark
//
//  Created by Rob Timpone on 8/20/14.
//  Copyright (c) 2014 RECSOLU. All rights reserved.
//

#import "NSDictionary+MapArrayOfDictionariesIntoArrayOfObjects.h"
#import <RestKit/RestKit.h>
#import "RMBClass.h"
#import "RMBStudent.h"

@implementation RMBStudent

+ (RKObjectMapping *)objectMapping
{
    RKObjectMapping *studentMapping = [RKObjectMapping mappingForClass: [RMBStudent class]];
    [studentMapping addAttributeMappingsFromDictionary: @{@"id" : @"studentId",
                                                          @"first_name" : @"firstName",
                                                          @"last_name" : @"lastName"}];
    [studentMapping addRelationshipMappingWithSourceKeyPath: @"classes" mapping: [RMBClass objectMapping]];
    return studentMapping;
}

+ (RKResponseDescriptor *)responseDescriptor
{
    return [RKResponseDescriptor responseDescriptorWithMapping: [RMBStudent objectMapping]
                                                        method: RKRequestMethodGET
                                                   pathPattern: @"students/with_relationship_mapping"
                                                       keyPath: @"students"
                                                   statusCodes: RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RMBStudent *)studentFromDictionary: (NSDictionary *)studentDictionary
{
    RMBStudent *student = [[RMBStudent alloc] init];
    student.studentId = studentDictionary[@"id"];
    student.firstName = studentDictionary[@"first_name"];
    student.lastName = studentDictionary[@"last_name"];
    student.classes = [studentDictionary mapArrayOfDictionariesForKey: @"classes" intoArrayOfObjectsUsingMappingBlock: ^id(NSDictionary *objectDictionary) {
        return [RMBClass classFromDictionary: objectDictionary];
    }];
    
    return student;
}

@end
