/**
*  MLKCoreDataHelper.h
*  Accenture
*
*  Created by Accenture on 4/28/15.
*  Copyright (c) 2015 Accenture. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MLKBlockAddition.h"
//#import "Test.h"

@interface MLKCoreDataHelper : NSObject

/**
 * @brief shareHelper singleton
 *
 * @result MLKCoreDataHelper
 */
+ (MLKCoreDataHelper*)shareHelper;
/**
 * @brief initWithDatabaseName: init coredata context and set the url of database file
 *
 * @param dbName name of database with extension
 *
 * @result self
 */
- (instancetype)initDB:(NSString*)dbName;

/**
 * @brief searchDataWithEntityName:query:sortDescriptorWithKey:ascending:error: search data in database with coredata
 *
 * @param entityName the name of entity
 *
 * @param query the query you want to search in the database
 *
 * @param sortArray array of sorts
 *
 * @param error error of searching data from database
 *
 * @result return the entity objects' array
 */
- (NSArray*)searchData:(NSString*)entityName query:(NSPredicate*)query sortDescriptors:(NSArray*)sortArray error:(NSError**)error;

/**
 * @brief deleteDataWithEntityName:query:error: delete the data with query
 *
 * @param entityName the name of entity
 *
 * @param query the query you want to search in the database
 *
 * @param error error of saving data into database
 */
- (void)deleteData:(NSString*)entityName query:(NSPredicate*)query error:(NSError**)error;

/**
 * @brief createObjectForInsertWithEntityName: insert data into database with coredata
 *
 * @param entityName the name of the entity
 *
 * @result return entity 
 */
- (NSManagedObject*)createObjectForInsert:(NSString*)entityName;

/**
 * @brief searchDataForUpdateWithEntityName: insert data into database with coredata
 *
 * @param entityName the name of the entity
 *
 * @param query the query you want to search in the database
 *
 * @param error error of inserting data to database
 *
 * @result return search array to be updated
 */
- (NSArray*)searchDataForUpdate:(NSString*)entityName query:(NSPredicate*)query error:(NSError**)error;

/**
 * @brief save: save change in context
 *
 * @param error save error
 */
- (void)saveData:(NSError**)error;

/**
 * @brief undoWithLevel undo change in context
 */
- (void)undoData;

/**
 * @brief redo Will redo last top-level undo
 */
- (void)redo;
@end
