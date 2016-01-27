//
//  MLKDataProxy.m
//  MLK
//
//  Created by Harly on 15/6/3.
//  Copyright (c) 2015年 Accenture. All rights reserved.
//

#import "MLKDataProxy.h"
#import "MLKDataOperations.h"
#import "MLKDataOperations+Extension.h"

@implementation MLKDataProxy
{
    NSString *_permission;
    MLKDataOperations *_defaultOperations;
    BOOL _isOnTransaction;
    BOOL _hasOpenDB;
}

-(id)initWithDBName:(NSString*) dbname openDB:(BOOL)bOpen
{
    self = [super init];
    if(self)
    {
//        MLKDataBase *database = [[MLKDataBase alloc] init];
//        NSError *error = nil;
//        [database createDBInDocuments:dbname error:&error];
//        
        self.fmDB = [MLKDataBase databaseWithName:dbname];
        _hasOpenDB = NO;
        if (bOpen)
        {
            [self.fmDB open];
            _hasOpenDB = YES;
        }
        _defaultOperations = [MLKDataOperations new];
    }
    return self;
}

- (BOOL)openDB
{
    if ([self.fmDB open])
    {
        _hasOpenDB = YES;
        return YES;
    }
    return NO;
}

- (BOOL)closeDB
{
    if ([self.fmDB close])
    {
        _hasOpenDB = NO;
        return YES;
    }
    return NO;
}

-(BOOL)addModel:(id)model intoTable:(NSString*)tableName
{
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB open];
    
    if([self.dataDelegate respondsToSelector:NSSelectorFromString(@"insertModel:")])
    {
        [self.dataDelegate insertModel:model intoTable:tableName ofDataBase:self.fmDB];
    }
    else
    {
        [_defaultOperations insertModel:model intoTable:tableName ofDataBase:self.fmDB];
    }
    
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB close];
    return YES;
}

-(BOOL)updateModel:(id)model inTable:(NSString*)tableName where:(NSDictionary*)conditions
{
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB open];
    if([self.dataDelegate respondsToSelector:NSSelectorFromString(@"updateModel:")])
    {
        [self.dataDelegate updateModel:model inTable:tableName withWhereConditions:conditions ofDataBase:self.fmDB];
    }
    else
    {
        [_defaultOperations updateModel:model inTable:tableName withWhereConditions:conditions ofDataBase:self.fmDB];
    }
    
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB close];
    return YES;
}

-(BOOL)updateModel:(id)model inTable:(NSString*)tableName includingColumns:(NSArray*)includCol orExcludeColumns:(NSArray*)excludCol andWhere:(NSDictionary*)conditions
{
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB open];
    if([self.dataDelegate respondsToSelector:NSSelectorFromString(@"updateModel:")])
    {
        [self.dataDelegate updateModel:model inTable:tableName andIncludedColumns:includCol orExculudedColumns:excludCol withWhereConditions:conditions ofDataBase:self.fmDB];
    }
    else
    {
        [_defaultOperations updateModel:model inTable:tableName andIncludedColumns:includCol orExculudedColumns:excludCol withWhereConditions:conditions ofDataBase:self.fmDB];
    }
    
    self.changesValue = self.fmDB.changes;
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB close];
    return YES;
}

-(BOOL)updateColumns:(NSArray*)includedColumns orExculudedColumns:(NSArray*)excludedColumns inModel: (id)model inTable:(NSString*)tableName where:(NSDictionary*)conditions
{
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB open];
    
    [_defaultOperations updateSpecificColumns:includedColumns orExculudedColumns:excludedColumns inModel:model inTable:tableName withWhereConditions:conditions ofDataBase:self.fmDB];
    
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB close];
    return YES;
}

-(NSArray*)searchQuery:(NSString*) query withAliasNams:(NSArray*)alias andParameters: (NSArray*) paraArray
{
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB open];
    
    NSArray* result= [_defaultOperations superSearchUsingQuery:query withAliasNams:alias andParameters:paraArray inDataBase:self.fmDB];
    
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB close];
    return result;
}
- (NSArray*)searchModel:(NSString*)modelName InTable:(NSString*)tableName whereDictionary:(NSDictionary*)whereCondition orWhereBlock:(NSString* (^)(NSString* , NSMutableArray*))whereBlock
{
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB open];
    NSArray* set;
    if([self.dataDelegate respondsToSelector:NSSelectorFromString(@"searchModel:")])
    {
        set = [self.dataDelegate searchModel:modelName InTable:tableName whereDictionary:whereCondition orWhereBlock:whereBlock ofDataBase:self.fmDB];
    }
    else
    {
        set = [_defaultOperations searchModel:modelName InTable:tableName whereDictionary:whereCondition orWhereBlock:whereBlock ofDataBase:self.fmDB];

    }
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB close];
    
    return set;
}
- (NSArray*)searchModelOnline:(NSString*)modelName InTable:(NSString*)tableName whereDictionary:(NSDictionary*)whereCondition orWhereBlock:(NSString* (^)(NSString* , NSMutableArray*))whereBlock
{
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB open];
    NSArray* set;
    if([self.dataDelegate respondsToSelector:NSSelectorFromString(@"searchModelOnline:")])
    {
        set = [self.dataDelegate searchModelOnline:modelName InTable:tableName whereDictionary:whereCondition orWhereBlock:whereBlock ofDataBase:self.fmDB];
    }
    else
    {
        set = [_defaultOperations searchModelOnline:modelName InTable:tableName whereDictionary:whereCondition orWhereBlock:whereBlock ofDataBase:self.fmDB];
        
    }
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB close];
    
    return set;
}

- (BOOL)deleteInTable:(NSString *)tableName whereDictionary:(NSDictionary *)whereCondition orWhereBlock:(NSString *(^)(NSString *, NSMutableArray *))whereBlock {
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB open];
    
    [_defaultOperations deleteInTable:tableName whereDictionary:whereCondition orWhereBlock:whereBlock ofDataBase:self.fmDB];
  
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB close];
    
    return YES;
}

- (BOOL)deleteQuery:(NSString *)query withParamaters:(NSArray *)paraArrar {
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB open];
    
    BOOL result = [_defaultOperations superDeleteUsingQuery:query withParameters:paraArrar inDataBase:self.fmDB];
    
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB close];
    return result;
}

- (BOOL)updateQuery:(NSString *)query withParamaters:(NSArray *)paraArrar {
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB open];
    
    BOOL result = [_defaultOperations superUpdateUsingQuery:query withParameters:paraArrar inDataBase:self.fmDB];
    
    if(!_isOnTransaction && !_hasOpenDB)
        [self.fmDB close];
    return result;
}

-(BOOL)handleTransactions:(BOOL (^)())transaction
{
    [self.fmDB open];
    [self.fmDB beginTransaction];
    _isOnTransaction = YES;
    _hasOpenDB = YES;
    BOOL bSuccess = NO;
    if(transaction != nil)
       bSuccess = transaction();
    
    _isOnTransaction = NO;
    if (!bSuccess)
    {
        [self.fmDB rollback];
        [self.fmDB close];
        _isOnTransaction = NO;
        _hasOpenDB = NO;
        return NO;
    }
    else
    {
        [self.fmDB commit];
        [self.fmDB close];
        _isOnTransaction = NO;
        _hasOpenDB = NO;
        return YES;
    }
    
}

@end
