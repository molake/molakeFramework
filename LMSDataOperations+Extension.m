//
//  MLKDataOperations+Extension.m
//  MLK
//
//  Created by Harly on 15/6/10.
//  Copyright (c) 2015年 Accenture. All rights reserved.
//

#import "MLKDataOperations+Extension.h"
#import <objc/runtime.h>

@implementation MLKDataOperations(Extension)

-(BOOL)updateSpecificColumns:(NSArray*)includedColumns orExculudedColumns:(NSArray*)excludedColumns inModel:(id)model inTable:(NSString*)tableName withWhereConditions:(NSDictionary*)conditions  ofDataBase:(FMDatabase*)db
{
    id modelClass = [model class];
    NSString *baseQuery = @"UPDATE %@ SET %@ WHERE 1=1 %@";
    NSString *setSample = @" %@ = ?,";
    NSString *setQuery = @"";
    NSMutableArray* paraArray = [NSMutableArray new];
    NSString *whereSample = @" AND %@ = ?";
    NSString *whereQuery = @"";
    
    if(includedColumns)
    {
        for (NSString* columnName in includedColumns)
        {
            @autoreleasepool {
                id value = [model valueForKey:columnName]==nil?@"":[model valueForKey:columnName];
                
                setQuery = [setQuery stringByAppendingString:[NSString stringWithFormat:setSample,columnName]];
                
                [paraArray addObject:value];
            }

        }
    }
    else
    {
        unsigned int outCount, i;
        
        objc_property_t *properties = class_copyPropertyList(modelClass, &outCount);
        for (i = 0; i < outCount; i++)
        {
            @autoreleasepool {
                objc_property_t property = properties[i];
                
                NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
                
                if([conditions valueForKey:propName]!=nil)
                {
                    continue;
                }
                if (excludedColumns && [excludedColumns containsObject:propName])
                {
                    continue;
                }
                
                id value = [model valueForKey:propName]==nil?@"":[model valueForKey:propName];
                
                setQuery = [setQuery stringByAppendingString:[NSString stringWithFormat:setSample,propName]];
                
                [paraArray addObject:value];

            }
        }
        
    }
    
    setQuery = [setQuery substringToIndex:setQuery.length-1];
    
    NSEnumerator * enumeratorKey = [conditions keyEnumerator];
    
    for (NSString *key in enumeratorKey)
    {
        whereQuery = [whereQuery stringByAppendingString:[NSString stringWithFormat:whereSample,key]];
        
        [paraArray addObject:[conditions valueForKey:key]];
    }
    
    NSString* finalQuery = [NSString stringWithFormat:baseQuery,tableName,setQuery,whereQuery ];
    
    BOOL result = [db executeUpdate:finalQuery withArgumentsInArray:paraArray];
    
    return result;
}


@end
