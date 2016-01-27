/**
 *  MLKOperation.m
 *  TPEducation
 *
 *  Created by Accenture on 4/20/15.
 *  Copyright (c) 2015 Accenture. All rights reserved.
 */

#import "MLKOperation.h"

@interface MLKOperation()
@property (nonatomic) BOOL isFinished;
@property (nonatomic) BOOL isExecuting;
@end

@implementation MLKOperation
@synthesize parameters = _parameters;
- (instancetype)init
{
    if (self == [super init])
    {
        _isExecuting = NO;
        _isFinished = NO;
    }
    return self;
}

- (instancetype)initWithParameters:(id)parameters
{
    if (self == [super init])
    {
        _isExecuting = NO;
        _isFinished = NO;
        _parameters = parameters;
    }
    return self;
}

- (void)main
{
    @autoreleasepool
    {
        [self callMainFunction];
        
        [self willChangeValueForKey:@"isExecuting"];
        [self willChangeValueForKey:@"isFinished"];
        
        _isExecuting = NO;
        _isFinished = YES;
        
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];
    }
}

- (void)start
{
    if ([self isCancelled])
    {
        [self willChangeValueForKey:@"isFinished"];
        
        _isFinished = YES;
        
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    
//    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    [self main];
    _isExecuting = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)callMainFunction
{
//    realized in subclass
}

- (BOOL)isExecuting{
    //进程是否在执行
    return _isExecuting;
}

- (BOOL)isFinished{
    //进程是否完成
    return _isFinished;
}

- (BOOL)isConcurrent{
    return YES;
}
@end
