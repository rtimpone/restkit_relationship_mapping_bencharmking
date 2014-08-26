//
//  NSDictionary+MapArrayOfDictionariesIntoArrayOfObjects.h
//  RestkitRelationshipMappingBenchmark
//
//  Created by Rob Timpone on 8/21/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MapArrayOfDictionariesIntoArrayOfObjects)

/** Map and array of dictionaries into an array of objects using a block
 
 Retrieves an array of dictionaries from a dictionary using a key, then applies a mapping block to each dictionary in the array.  The id return value of each block execution is added to an array, which is returned.
 
 @param key the dictionary key that maps to the array of dictionaries
 @param mappingBlock the block to execute for each dictionary in the array, takes a dictionary as a param and returns an id
 
 @return an array of objects resulting from executing the mappingBlock on each dictionary in the array
 
*/
- (NSArray *)mapArrayOfDictionariesForKey: (NSString *)key intoArrayOfObjectsUsingMappingBlock: (id (^)(NSDictionary *objectDictionary))mappingBlock;

@end
