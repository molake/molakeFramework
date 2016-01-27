/**
 *  MLKCoreDataHelper.m
 *  Accenture
 *
 *  Created by Accenture on 4/28/15.
 *  Copyright (c) 2015 Accenture. All rights reserved.
 */

#import "MLKCoreDataHelper.h"
#import "MLKBlockAddition.h"
#import "MLKSimpleHelper.h"
#import <sqlite3.h>

@interface MLKCoreDataHelper ()
@property (strong, nonatomic) NSURL *dbFileURL;

@property(strong,nonatomic,readonly) NSManagedObjectContext* managedObjectContext;

@property (nonatomic) BOOL isDisplay;

/**
 * @brief createDatabaseWithPath: create database file at path
 *
 * @param strPath the path were the database file is at
 *
 * @result whether the database file is created succeefully
 */
- (BOOL)createDatabaseWithPath:(NSString*)strPath;

/**
 * @brief entityWithName: get the entity
 *
 * @param name the name of entity
 *
 * @result return entity object
 */
- (id)entityWithName:(NSString*)name;
@end

@implementation MLKCoreDataHelper

+ (MLKCoreDataHelper*)shareHelper
{
    static dispatch_once_t onceToken;
    static MLKCoreDataHelper *_coreDataHelper;
    dispatch_once(&onceToken, ^{
        if (_coreDataHelper == nil) {
            _coreDataHelper = [[MLKCoreDataHelper alloc] initDB:@""];
        }
    });
    return _coreDataHelper;
}

- (BOOL)createDatabaseWithPath:(NSString*)strPath
{
    NSString *parentPath = [MLKSimpleHelper getDocumentPath];
    strPath = [strPath stringByAppendingPathExtension:@"sqlite"];
    NSString *database_path = [parentPath stringByAppendingPathComponent:strPath];
    sqlite3 *db;
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
    }
    return YES;
}

- (instancetype)initDB:(NSString*)dbName
{
    if (self == [super init])
    {
        NSString *strPath = [MLKSimpleHelper getDocumentPath];
        NSString *filePath = [strPath stringByAppendingPathComponent:dbName];
        filePath = [filePath stringByAppendingString:@".sqlite"];
        NSLog(@"%@", filePath);
        [self createDatabaseWithPath:filePath];
        _dbFileURL = [NSURL fileURLWithPath:filePath];
        [self createManagedObjectContext];
    }
    return self;
}

- (NSManagedObjectModel *)managedObjectModel
{
    NSManagedObjectModel *_managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    for (NSEntityDescription *desc in _managedObjectModel.entities)
    {
        NSLog(@"%@", desc.name);
    }
    return _managedObjectModel;
}

- (void)createManagedObjectContext
{
    NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
    if (coordinator!=nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.undoManager = [[NSUndoManager alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    NSError* error=nil;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:_dbFileURL options:nil error:&error]) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    return _persistentStoreCoordinator;
}

- (id)entityWithName:(NSString*)name
{
   return  [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:_managedObjectContext];
}

- (NSArray*)searchData:(NSString*)entityName query:(NSPredicate*)query sortDescriptors:(NSArray*)sortArray error:(NSError**)error
{
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:entityName];
    fetch.predicate = query;
    
    fetch.sortDescriptors = sortArray;
    
    NSArray *array=[_managedObjectContext executeFetchRequest:fetch error:error];
    return array;
}

- (void)deleteData:(NSString*)entityName query:(NSPredicate*)query error:(NSError**)error
{
    NSArray *array = [self searchData:entityName query:query sortDescriptors:nil error:error];
    for (NSManagedObject *object in array)
    {
        [_managedObjectContext deleteObject:object];
    }
}

- (NSManagedObject*)createObjectForInsert:(NSString*)entityName
{
    return [self entityWithName:entityName];
}

- (NSArray*)searchDataForUpdate:(NSString*)entityName query:(NSPredicate*)query error:(NSError**)error
{
    return [self searchData:entityName query:query sortDescriptors:nil error:error];
}

- (void)saveData:(NSError**)error
{
    [_managedObjectContext save:error];
}

- (void)undoData
{
    [[self undoManager] setLevelsOfUndo:0];
    [[self undoManager] undo];
}

- (void)redo
{
    [[self undoManager] redo];
}

- (NSUndoManager*)undoManager
{
    return _managedObjectContext.undoManager;
}
@end
