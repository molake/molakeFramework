//
//  MLKDataProxy.h
//  MLK
//
//  Created by Harly on 15/6/3.
//  Copyright (c) 2015年 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLKDataBase.h"
#import "FMDB.h"

@protocol MLKDataProxyDelegate <NSObject>

@optional
-(BOOL)insertModel:(id)model intoTable:(NSString*)tableName ofDataBase:(FMDatabase*)db;
-(BOOL)updateModel:(id)model inTable:(NSString*)tableName withWhereConditions:(NSDictionary*)conditions ofDataBase:(FMDatabase*)db ;

-(BOOL)updateModel:(id)model inTable:(NSString*)tableName andIncludedColumns:(NSArray*)includedColumns orExculudedColumns:(NSArray*)excludedColumns withWhereConditions:(NSDictionary*)conditions  ofDataBase:(FMDatabase*)db;


-(NSArray*)searchModel:(NSString*)modelName InTable:(NSString*)tableName whereDictionary:(NSDictionary*)whereCondition orWhereBlock:(NSString* (^)(NSString* , NSMutableArray*))whereBlock ofDataBase :(FMDatabase*)db ;
-(NSArray*)searchModelOnline:(NSString*)modelName InTable:(NSString*)tableName whereDictionary:(NSDictionary*)whereCondition orWhereBlock:(NSString* (^)(NSString* , NSMutableArray*))whereBlock ofDataBase :(FMDatabase*)db ;
- (BOOL)deleteInTable:(NSString *)tableName whereDictionary:(NSDictionary *)whereCondition orWhereBlock:(NSString *(^)(NSString * ,NSMutableArray *))whereBlock ofDataBase:(FMDatabase *)db;

-(void)transactionOperationsOnDataBase:(FMDatabase*)db;

@end

@interface MLKDataProxy : NSObject

@property (strong,nonatomic) id<MLKDataProxyDelegate> dataDelegate;

-(id)initWithDBName:(NSString*) dbname openDB:(BOOL)bOpen;

/**
 * @brief Insert data
 *
 * @param model model to insert
 *
 * @param tableName tableName to of the model
 */
-(BOOL)addModel:(id)model intoTable:(NSString*)tableName;

/**
 * @brief Update data
 *
 * @param model model to update
 *
 * @param tableName tableName to of the model
 *
 * @conditions conditions following the where statement in UPDATE 
 *  where %@ = %@ => the left @ should be key in dictionary and the rest to be the value.
 *  like: where dic.Key = dic.Value.
 *
 * 
 *
 */
-(BOOL)updateModel:(id)model inTable:(NSString*)tableName where:(NSDictionary*)conditions;


-(BOOL)updateModel:(id)model inTable:(NSString*)tableName includingColumns:(NSArray*)includCol orExcludeColumns:(NSArray*)excludCol andWhere:(NSDictionary*)conditions;
/**
 * @brief Search data
 *
 * @param modelName modelName of the datamodel
 *
 * @param tableName tableName to of the model
 *
 * @conditions conditions following the where statement in UPDATE
 *  where %@ = %@ => the left @ should be key in dictionary and the rest to be the value.
 *  like: where dic.Key = dic.Value.
 *
 * @whereBlock customize the where string:
 *  append the string after the parameter passed in and do not forget to add your
 *  parameters by ? in query and value into array parameter.
 */
- (NSArray*)searchModel:(NSString*)modelName InTable:(NSString*)tableName whereDictionary:(NSDictionary*)whereCondition orWhereBlock:(NSString* (^)(NSString* , NSMutableArray*))whereBlock;

- (NSArray*)searchModelOnline:(NSString*)modelName InTable:(NSString*)tableName whereDictionary:(NSDictionary*)whereCondition orWhereBlock:(NSString* (^)(NSString* , NSMutableArray*))whereBlock;
/**
 * @brief Search data using query
 *
 * @param your select query
 *
 * @param alias your alias list using in the query
 *
 * @paraArray  parameters to match the ? in your query
 *
 */
-(NSArray*)searchQuery:(NSString*) query withAliasNams:(NSArray*)alias andParameters: (NSArray*) paraArray;

-(BOOL)updateColumns:(NSArray*)includedColumns orExculudedColumns:(NSArray*)excludedColumns inModel: (id)model inTable:(NSString*)tableName where:(NSDictionary*)conditions;

- (BOOL)deleteInTable:(NSString *)tableName whereDictionary:(NSDictionary *)whereCondition orWhereBlock:(NSString *(^)(NSString * ,NSMutableArray *))whereBlock;

- (BOOL)deleteQuery:(NSString *)query withParamaters:(NSArray *)paraArrar;

- (BOOL)updateQuery:(NSString *)query withParamaters:(NSArray *)paraArrar;

-(BOOL)handleTransactions:(BOOL (^)())transaction;

- (BOOL)openDB;

- (BOOL)closeDB;

@property (strong,nonatomic)  MLKDataBase *fmDB;
@property (nonatomic) int changesValue;
@end
