//
//  NSArray+LinqExt.h
//  MLK
//
//  Created by Harly on 15/5/29.
//  Copyright (c) 2015年 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSNumber* (^SortSelector)(id item);
typedef id (^Selector)(id item);
typedef BOOL (^Condition)(id item);

@interface NSArray (LinqExt)

- (NSArray *)LinqSort:(SortSelector)keySelector;
- (NSArray *)LinqWhere:(Condition)predicate;
- (NSArray *)LinqSelectWithDistinct:(Selector)selector;

- (NSInteger)firstIndexWhere:(Condition)predicate;

@end
