/**
 *  TPEBackgroundPostFunction.h
 *  TPEducation
 *
 *  Created by Accenture on 5/27/15.
 *  Copyright (C) 2015 Accenture. All rights reserved.
 */

#import <Foundation/Foundation.h>


typedef enum {
    ACCESSLOG,
    ERRORLOG,
    DEBUGLOG,
} MLKLogLevel;

@interface MLKLogHelper : NSObject

/**
 * @brief recordWithClassName record current class name
 *
 * @param methodName current method name
 *
 * @param logMessage current custom message
 *
 * @param logState current log state
 */
- (NSDictionary *)recordWithClassName:(id)className methodName:(SEL)methodName logMessage:(NSString *)logMessage logState:(MLKLogLevel)logState;

@end
