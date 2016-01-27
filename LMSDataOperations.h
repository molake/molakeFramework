//
//  MLKDataOperations.h
//  MLK
//
//  Created by Harly on 15/6/3.
//  Copyright (c) 2015年 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLKDataBase.h"
#import "FMDB.h"
#import "MLKLogHelper.h"

#import "MLKDataProxy.h"

@interface MLKDataOperations : NSObject<MLKDataProxyDelegate>

@property (nonatomic, strong) MLKLogHelper *logHelper;

-(NSArray*)superSearchUsingQuery:(NSString*)query withAliasNams:(NSArray*)alias andParameters: (NSArray*) paraArray inDataBase:(FMDatabase*)db;

-(BOOL)superDeleteUsingQuery:(NSString *)query withParameters:(NSArray *)paraArray inDataBase:(FMDatabase *)db;

- (BOOL)superUpdateUsingQuery:(NSString *)query withParameters:(NSArray *)paraArray inDataBase:(FMDatabase *)db;
@end
