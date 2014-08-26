//
//  NSDictionary+MapArrayOfDictionariesIntoArrayOfObjects.m
//  RestkitRelationshipMappingBenchmark
//
//  Created by Rob Timpone on 8/21/14.
//
//

#import "NSDictionary+MapArrayOfDictionariesIntoArrayOfObjects.h"

@implementation NSDictionary (MapArrayOfDictionariesIntoArrayOfObjects)

- (NSArray *)mapArrayOfDictionariesForKey: (NSString *)key intoArrayOfObjectsUsingMappingBlock: (id (^)(NSDictionary *objectDictionary))mappingBlock
{
    NSMutableArray *objects = [@[] mutableCopy];
    
    NSArray *objectDictionaries = [self objectForKey: key];
    for (NSDictionary *objectDictionary in objectDictionaries)
    {
        [objects addObject: mappingBlock(objectDictionary)];
    }
    
    return objects;
}

@end
