//
//  NSArray+LinqExt.m
//  MLK
//
//  Created by Harly on 15/5/29.
//  Copyright (c) 2015年 Accenture. All rights reserved.
//

#import "NSArray+LinqExt.h"

@implementation NSArray (LinqExt)

-(NSArray*)LinqSelectWithDistinct:(Selector)selector
{
    NSMutableArray* result = [[NSMutableArray alloc]init];
    for(id item in self)
    {
        if(![result containsObject:selector(item)])
            [result addObject:selector(item)];
    }
    return  result;
}

- (NSArray*)LinqWhere:(Condition)predicate
{
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for(id item in self) {
        if (predicate(item)) {
            [result addObject:item];
        }
    }
    return result;
}

- (NSArray *)LinqSort:(SortSelector)keySelector;
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber* valueOne = keySelector(obj1);
        NSNumber* valueTwo = keySelector(obj2);
        NSComparisonResult result = [valueOne compare:valueTwo];
        return result;
    }];
}

- (NSInteger)firstIndexWhere:(Condition)predicate {
    NSInteger result = -1; // not found
    for(id item in self) {
        if (predicate(item)) {
            result = [self indexOfObject:item];
            break;
        }
    }
    return result;
}

@end
