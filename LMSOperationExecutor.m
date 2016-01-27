/**
 *  MLKOperationExecutor.h
 *  TPEducation
 *
 *  Created by Accenture on 4/22/15.
 *  Copyright (c) 2015 Accenture. All rights reserved.
 */

#import "MLKOperationExecutor.h"
#import "MLKBackgroundFetchOperation.h"
#import "MLKOperation.h"

@interface MLKOperationExecutor ()
@property (nonatomic) enum TPEOperationType type;
@property (weak, nonatomic) NSOperationQueue *queue;
@property (strong, nonatomic) NSMutableArray *operationArray;
@property (nonatomic) BOOL bForeground;
@end

@implementation MLKOperationExecutor
- (instancetype)initWithQueue:(NSOperationQueue*)queue forOperationType:(enum TPEOperationType)type
{
    if (self == [super init])
    {
        _type = type;
        _queue = queue;
        _operationArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSMutableArray*)operationArray
{
    return _operationArray;
}

- (void)enqueueOperationWithParams:(id)parameters handler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    switch (_type)
    {
        case MLKBackgroundFetchType:
        {
            MLKBackgroundFetchOperation *fetchOperation = [[MLKBackgroundFetchOperation alloc] initWithParameters:parameters completionHandler:completionHandler];
            [_operationArray addObject:fetchOperation];
        }
            break;
        case MLKDownloadType:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)runAndWaitUntilFinish:(BOOL)wait
{
    [_queue addOperations:_operationArray waitUntilFinished:wait];
}
@end
