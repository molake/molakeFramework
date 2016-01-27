//
//  MLKDataBase.m
//  MLK
//
//  Created by RenChao on  5/28/15.
//  Copyright (c) 2015 Accenture. All rights reserved.
//

#import "MLKDataBase.h"
#import "FMDB.h"
#import "MLKSimpleHelper.h"
#import "MLKStudent.h"
#import "FMEncryptHelper.h"
#import "MLKSimpleHelper.h"

@implementation MLKDataBase
- (void)createDBInDocuments:(NSString*)dbName error:(NSError**)error
{
    NSString *parentPath = [MLKSimpleHelper getDocumentPath];

    dbName = [dbName stringByAppendingPathExtension:@"sqlite"];
    NSString *databasePath = [parentPath stringByAppendingPathComponent:dbName];
    
    NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"MLK" ofType:@"sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:databasePath])
    {
        NSDictionary *settings = [MLKSimpleHelper getSettingPlist];
        
        BOOL needEncrypted = [settings[@"NeedEncryption"] boolValue];
        
        if (needEncrypted)
        {
            [FMEncryptHelper encryptDatabase:defaultDBPath targetPath:databasePath];
        }
        else
        {
            [fileManager copyItemAtPath:defaultDBPath toPath:databasePath error:error];
        }
    }
}

+ (MLKDataBase*)databaseWithName:(NSString*)dbName
{
    NSString *parentPath = [MLKSimpleHelper getDocumentPath];
    dbName = [dbName stringByAppendingPathExtension:@"sqlite"];
    NSString *databasePath = [parentPath stringByAppendingPathComponent:dbName];
    MLKDataBase *db = [MLKDataBase databaseWithPath:databasePath];
    return db;
}

- (BOOL)open {
    if (_db) {
        return YES;
    }
    
    int err = sqlite3_open([self sqlitePath], &_db );
    if(err != SQLITE_OK) {
        NSLog(@"error opening!: %d", err);
        return NO;
    } else {
        
        NSDictionary *settings = [MLKSimpleHelper getSettingPlist];
        BOOL needEncrypted = [settings[@"NeedEncryption"] boolValue];
        
        if (needEncrypted)
        {
            NSDictionary *settings = [MLKSimpleHelper getSettingPlist];
            NSString *key=settings[@"DatabaseEncryptedKey"];
            sqlite3_exec(_db, [[NSString stringWithFormat:@"PRAGMA key = \"%@\";", key] UTF8String], NULL, NULL, NULL);
            //sqlite3_exec(_db, [[NSString stringWithFormat:@"PRAGMA cipher_default_use_hmac = off;"] UTF8String], NULL, NULL, NULL);
        }

    }
    
    if (_maxBusyRetryTimeInterval > 0.0) {
        // set the handler
        [self setMaxBusyRetryTimeInterval:_maxBusyRetryTimeInterval];
    }
    
    return YES;
}

#if SQLITE_VERSION_NUMBER >= 3005000
- (BOOL)openWithFlags:(int)flags {
    if (_db) {
        return YES;
    }
    
    int err = sqlite3_open_v2([self sqlitePath], &_db, flags, NULL /* Name of VFS module to use */);
    if(err != SQLITE_OK) {
        NSLog(@"error opening!: %d", err);
        return NO;
    } else {

        NSDictionary *settings = [MLKSimpleHelper getSettingPlist];
        BOOL needEncrypted = [settings[@"NeedEncryption"] boolValue];
        
        if (needEncrypted)
        {
            NSDictionary *settings = [MLKSimpleHelper getSettingPlist];
            NSString *key=settings[@"DatabaseEncryptedKey"];
            sqlite3_exec(_db, [[NSString stringWithFormat:@"PRAGMA key = \"%@\";", key] UTF8String], NULL, NULL, NULL);
            //sqlite3_exec(_db, [[NSString stringWithFormat:@"PRAGMA cipher_default_use_hmac = off;"] UTF8String], NULL, NULL, NULL);
        }

    }
    if (_maxBusyRetryTimeInterval > 0.0) {
        // set the handler
        
        [self setMaxBusyRetryTimeInterval:_maxBusyRetryTimeInterval];
    }
    
    return YES;
}

#endif

- (const char*)sqlitePath {
    
    if (!_databasePath) {
        return ":memory:";
    }
    
    if ([_databasePath length] == 0) {
        return ""; // this creates a temporary database (it's an sqlite thing).
    }
    
    return [_databasePath fileSystemRepresentation];
    
}

- (void)createDBView
{
    
}
@end
