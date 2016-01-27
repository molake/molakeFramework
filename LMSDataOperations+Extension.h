//
//  MLKDataOperations+Extension.h
//  MLK
//
//  Created by Harly on 15/6/10.
//  Copyright (c) 2015年 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLKDataOperations.h"

@interface MLKDataOperations(Extension)

-(BOOL)updateSpecificColumns:(NSArray*)includedColumns orExculudedColumns:(NSArray*)excludedColumns inModel:(id)model inTable:(NSString*)tableName withWhereConditions:(NSDictionary*)conditions  ofDataBase:(FMDatabase*)db;

@end
