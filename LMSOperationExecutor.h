/**
*  MLKOperationExecutor.h
*  TPEducation
*
*  Created by Accenture on 4/22/15.
*  Copyright (c) 2015 Accenture. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import "MLKBlockAddition.h"

enum TPEOperationType
{
    MLKBackgroundFetchType,
    MLKDownloadType
};

@interface MLKOperationExecutor : NSObject



@property (copy, nonatomic) CompletionHandler completionHandler;

/**
 * @brief initWithQueue:forOperationType: init
 *
 * @param queue target operation queue
 *
 * @param type operation type
 *
 */
- (instancetype)initWithQueue:(NSOperationQueue*)queue forOperationType:(enum TPEOperationType)type;

/**
 * @brief enqueueOperationWithParams add operation to queue
 *
 * @param parameters parameterts of operation
 *
 */
- (void)enqueueOperationWithParams:(id)parameters handler:(void (^)(UIBackgroundFetchResult))completionHandler;

/**
 * @brief runAndWaitUntilFinish run the operation queue
 *
 * @param wait wait the operation queue to finish
 *
 */
- (void)runAndWaitUntilFinish:(BOOL)wait;

/**
 * @brief operationArray get operationArray
 *
 * @result return operationArray
 */
- (NSMutableArray*)operationArray;
@end
