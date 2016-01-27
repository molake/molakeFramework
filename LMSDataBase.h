//
//  MLKDataBase.h
//  MLK
//
//  Created by RenChao on 5/28/15.
//  Copyright (c) 2015 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDatabase.h>

@interface MLKDataBase : FMDatabase
- (void)createDBInDocuments:(NSString*)dbName error:(NSError**)error;

+ (MLKDataBase*)databaseWithName:(NSString*)dbName;

//+ (void)createDBView;
@end
