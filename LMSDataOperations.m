//
//  MLKDataOperations.m
//  MLK
//
//  Created by Harly on 15/6/3.
//  Copyright (c) 2015年 Accenture. All rights reserved.
//

#import "MLKDataOperations.h"
#import <objc/runtime.h>
#import "MLKLogHelper.h"

@implementation MLKDataOperations


- (MLKLogHelper*)logHelper {
    if (!_logHelper) {
        _logHelper = [[MLKLogHelper alloc] init];
    }
    return _logHelper;
}

-(NSArray*)superSearchUsingQuery:(NSString*)query withAliasNams:(NSArray*)alias andParameters: (NSArray*) paraArray inDataBase:(FMDatabase*)db
{
    FMResultSet* result = [db executeQuery:query withArgumentsInArray:paraArray];
    NSMutableArray* resultArray = [[NSMutableArray alloc]init];
    while ([result next])
    {
        id object = [[NSObject alloc]init];
        for (NSString* key in alias)
        {
            @autoreleasepool {
                NSString* columnValue = [result stringForColumn:key];
                objc_setAssociatedObject(object, [key UTF8String],columnValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
            
        }
        
        [resultArray addObject:object];
    }
    return resultArray;

}

-(NSArray*)searchModel:(NSString*)modelName InTable:(NSString*)tableName whereDictionary:(NSDictionary*)whereCondition orWhereBlock:(NSString* (^)(NSString* , NSMutableArray*))whereBlock ofDataBase :(FMDatabase*)db {
    Class modelClass = NSClassFromString(modelName);
    
    NSString* baseQuery = @"SELECT %@ FROM %@ %@";
    NSString* columnSample = @" %@,";
    NSString* columnQuery = @"";
    NSString* whereSample = @" AND %@ = ?";
    NSString* whereQuery = @"WHERE delete_flg = 0 ";
    NSMutableArray* paraArray = [[NSMutableArray alloc]init];
    NSMutableArray* columnArray = [[NSMutableArray alloc]init];
    NSMutableArray* modelArray = [[NSMutableArray alloc]init];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(modelClass, &outCount);
    
    for (i = 0; i < outCount; i++)
    {
        @autoreleasepool {
            objc_property_t property = properties[i];
            
            NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
            
            columnQuery = [columnQuery stringByAppendingString:[NSString stringWithFormat:columnSample,propName]];
            
            [columnArray addObject:propName];
        }
        
    }
    
    columnQuery = [columnQuery substringToIndex:columnQuery.length-1];
    
    if(whereBlock)
    {
        whereQuery = whereBlock(whereQuery,paraArray);
    }
    else
    {
        
        NSEnumerator * enumeratorKey = [whereCondition keyEnumerator];
        
        for (NSString *key in enumeratorKey)
        {
            whereQuery = [whereQuery stringByAppendingString:[NSString stringWithFormat:whereSample,key]];
            
            [paraArray addObject:[whereCondition valueForKey:key]];
        }
    }
    
    NSString* finalQuery = [NSString stringWithFormat:baseQuery,columnQuery,tableName,whereQuery ];
    //LOG_FOR_TABLET
    //[self.logHelper log:[self class] methodName:_cmd logMessage:finalQuery logLevel:ACCESS];
    
    FMResultSet* result = [db executeQuery:finalQuery withArgumentsInArray:paraArray];
    
    while ([result next])
    {
        id model = [[modelClass alloc]init];
        for (NSString* columnName in columnArray)
        {
            NSString* columnValue = [result stringForColumn:columnName];
            [model setValue:columnValue forKey:columnName];
        }
        [modelArray addObject:model];
        
    }
    
    return modelArray;
}

-(NSArray*)searchModelOnline:(NSString*)modelName InTable:(NSString*)tableName whereDictionary:(NSDictionary*)whereCondition orWhereBlock:(NSString* (^)(NSString* , NSMutableArray*))whereBlock ofDataBase :(FMDatabase*)db
{
    Class modelClass = NSClassFromString(modelName);
    
    NSString* baseQuery = @"SELECT %@ FROM %@ %@";
    NSString* columnSample = @" %@,";
    NSString* columnQuery = @"";
    NSString* whereSample = @" AND %@ = ?";
    NSString* whereQuery = @"WHERE 1=1 ";
    NSMutableArray* paraArray = [[NSMutableArray alloc]init];
    NSMutableArray* columnArray = [[NSMutableArray alloc]init];
    NSMutableArray* modelArray = [[NSMutableArray alloc]init];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(modelClass, &outCount);
    
    for (i = 0; i < outCount; i++)
    {
        @autoreleasepool {
            objc_property_t property = properties[i];
            
            NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
            
            columnQuery = [columnQuery stringByAppendingString:[NSString stringWithFormat:columnSample,propName]];
            [columnArray addObject:propName];

        }
    }
    
    columnQuery = [columnQuery substringToIndex:columnQuery.length-1];
    
    if(whereBlock)
    {
        whereQuery = whereBlock(whereQuery,paraArray);
    }
    else
    {
        
        NSEnumerator * enumeratorKey = [whereCondition keyEnumerator];
        
        for (NSString *key in enumeratorKey)
        {
            whereQuery = [whereQuery stringByAppendingString:[NSString stringWithFormat:whereSample,key]];
            
            [paraArray addObject:[whereCondition valueForKey:key]];
        }
    }

    NSString* finalQuery = [NSString stringWithFormat:baseQuery,columnQuery,tableName,whereQuery ];
    //LOG_FOR_TABLET
    //[self.logHelper log:[self class] methodName:_cmd logMessage:finalQuery logLevel:ACCESS];
    
    FMResultSet* result = [db executeQuery:finalQuery withArgumentsInArray:paraArray];
    
    while ([result next])
    {
        id model = [[modelClass alloc]init];
        for (NSString* columnName in columnArray)
        {
            NSString* columnValue = [result stringForColumn:columnName];
            [model setValue:columnValue forKey:columnName];
        }
        [modelArray addObject:model];

    }
    
    return modelArray;



}


- (BOOL)searchExist:(NSString*)modelName InTable:(NSString*)tableName whereDictionary:(NSDictionary*)whereCondition orWhereBlock:(NSString* (^)(NSString* , NSMutableArray*))whereBlock ofDataBase :(FMDatabase*)db
{
    return NO;
}

- (BOOL)deleteInTable:(NSString *)tableName whereDictionary:(NSDictionary *)whereCondition orWhereBlock:(NSString *(^)(NSString *, NSMutableArray *))whereBlock ofDataBase:(FMDatabase *)db {
    
    NSString* baseQuery = @"DELETE FROM %@ %@";
    NSString* whereSample = @" AND %@ = ?";
    NSString* whereQuery = @"WHERE 1=1 ";
    NSMutableArray* paraArray = [[NSMutableArray alloc]init];
    
    if(whereBlock)
    {
        whereQuery = whereBlock(whereQuery,paraArray);
    }
    else
    {
        
        NSEnumerator * enumeratorKey = [whereCondition keyEnumerator];
        
        for (NSString *key in enumeratorKey)
        {
            whereQuery = [whereQuery stringByAppendingString:[NSString stringWithFormat:whereSample,key]];
            
            [paraArray addObject:[whereCondition valueForKey:key]];
        }
    }
    
    NSString* finalQuery = [NSString stringWithFormat:baseQuery,tableName,whereQuery ];

    BOOL result = [db executeUpdate:finalQuery withArgumentsInArray:paraArray];
    return result;
}

- (BOOL)superDeleteUsingQuery:(NSString *)query withParameters:(NSArray *)paraArray inDataBase:(FMDatabase *)db {
    BOOL result = [db executeUpdate:query withArgumentsInArray:paraArray];
    return result;
}

- (BOOL)superUpdateUsingQuery:(NSString *)query withParameters:(NSArray *)paraArray inDataBase:(FMDatabase *)db {
    BOOL result = [db executeUpdate:query withArgumentsInArray:paraArray];
    return result;
}

-(BOOL)insertModel:(id)model intoTable:(NSString*)tableName ofDataBase:(FMDatabase*)db
{
    id modelClass = [model class];
    NSString* baseQuery = @"INSERT INTO %@ (%@) VALUES (%@)";
    NSString* propertySample = @"%@,";
    NSString* propertyQuery=@"";
    NSString* parameterSample = @"?,";
    NSString* parameterQuery=@"";
    NSMutableArray* paraArray = [NSMutableArray new];
    unsigned int outCount, i;

    objc_property_t *properties = class_copyPropertyList(modelClass, &outCount);
    for (i = 0; i < outCount; i++)
    {
        @autoreleasepool {
            objc_property_t property = properties[i];
            
            NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
            
            propertyQuery = [propertyQuery stringByAppendingString:[NSString stringWithFormat:propertySample,propName]];
            parameterQuery = [parameterQuery stringByAppendingString:parameterSample];
            id value = [model valueForKey:propName]==nil?@"":[model valueForKey:propName];
            [paraArray addObject:value];
        }
        
    }
    propertyQuery = [propertyQuery substringToIndex:propertyQuery.length-1];
    parameterQuery = [parameterQuery substringToIndex:parameterQuery.length-1];
    //Combine the query:
    NSString* finalQuery = [NSString stringWithFormat:baseQuery,tableName,propertyQuery,parameterQuery ];
    //LOG_FOR_TABLET
//    [self.logHelper log:[self class] methodName:_cmd logMessage:finalQuery logLevel:ACCESS];
    
    BOOL result = [db executeUpdate:finalQuery withArgumentsInArray:paraArray];
    if (!result)
    {
//        MLKLogHelper *logHelper = [[MLKLogHelper alloc] init];
//        [logHelper log:[self class] methodName:_cmd logMessage:[@"DBエラーが発生しました。エラー対象SQL：" stringByAppendingString:finalQuery] logLevel:ERROR];
    }
    return result;
}

/*-(BOOL)insertModel:(id)model intoTable:(NSString*)tableName ofDataBase:(FMDatabase*)db {
    id modelClass = [model class];
    NSString* baseQuery = @"INSERT INTO %@ (%@) VALUES (%@)";
    NSString* propertySample = @"%@,";
    NSString* propertyQuery=@"";
    NSString* parameterSample = @"%@,";
    NSString* parameterQuery=@"";
    //NSMutableArray* paraArray = [NSMutableArray new];
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList(modelClass, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        
        propertyQuery = [propertyQuery stringByAppendingString:[NSString stringWithFormat:propertySample,propName]];
        
        
        id value = [model valueForKey:propName]==nil?NULL:[NSString stringWithFormat:@"'%@'",[model valueForKey:propName]];
        
        parameterQuery = [parameterQuery stringByAppendingString:[NSString stringWithFormat:parameterSample,value]];
        
        //[paraArray addObject:value];
    }
    propertyQuery = [propertyQuery substringToIndex:propertyQuery.length-1];
    parameterQuery = [parameterQuery substringToIndex:parameterQuery.length-1];
    //Combine the query:
    NSString* finalQuery = [NSString stringWithFormat:baseQuery,tableName,propertyQuery,parameterQuery ];
    
    BOOL result = [db executeUpdate:finalQuery];
    return result;
}*/

-(BOOL)updateModel:(id)model inTable:(NSString*)tableName andIncludedColumns:(NSArray*)includedColumns orExculudedColumns:(NSArray*)excludedColumns withWhereConditions:(NSDictionary*)conditions  ofDataBase:(FMDatabase*)db
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
            id value = [model valueForKey:columnName]==nil?@"":[model valueForKey:columnName];
            
            setQuery = [setQuery stringByAppendingString:[NSString stringWithFormat:setSample,columnName]];
            
            [paraArray addObject:value];
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
    //LOG_FOR_TABLET
    //[self.logHelper log:[self class] methodName:_cmd logMessage:finalQuery logLevel:ACCESS];

    BOOL result = [db executeUpdate:finalQuery withArgumentsInArray:paraArray];
    if (!result)
    {
//        MLKLogHelper *logHelper = [[MLKLogHelper alloc] init];
//        [logHelper log:[self class] methodName:_cmd logMessage:[@"DBエラーが発生しました。エラー対象SQL：" stringByAppendingString:finalQuery] logLevel:ERROR];
    }
    return result;
}
@end
