/**
 *  TPEBackgroundPostFunction.h
 *  TPEducation
 *
 *  Created by Accenture on 5/27/15.
 *  Copyright (C) 2015 Accenture. All rights reserved.
 */

#import "MLKLogHelper.h"

#define MLKStateAccess @"ACCESSLOG"
#define MLKStateError @"ERRORLOG"
#define MLKStateDebug @"DEBUGLOG"

@implementation MLKLogHelper

- (NSDictionary *)recordWithClassName:(id)className methodName:(SEL)methodName logMessage:(NSString *)logMessage logState:(MLKLogLevel)logState {
    NSString *classNameStr = NSStringFromClass(className);
    
    NSDate *sendDate=[NSDate date];
    NSDateFormatter  *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString *currentTime = [dateFormatter stringFromDate:sendDate];
    
    NSString *methodNameStr = NSStringFromSelector(methodName);
    
    NSString *strLogState;
    if (logState == 0) {
        strLogState = MLKStateAccess;
    }else if (logState == 1){
        strLogState = MLKStateError;
    }
    else {
        strLogState = MLKStateDebug;
    }
    
    return [[NSDictionary alloc]initWithObjects:@[currentTime, classNameStr, methodNameStr, logMessage, strLogState] forKeys:@[@"create_time", @"class_name", @"method_name", @"log_message", @"log_state"]];
}
@end
