//
//  MLKCommonFunction.h
//  TPEducation
//
//  Created by Accenture on 4/7/15.
//  Copyright (c) 2015 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLKSimpleHelper : NSObject
//Get Documents path
+ (NSString*)getDocumentPath;

//Get Setting.plist
+ (NSDictionary*)getSettingPlist;

//get localhost
+ (NSString*)getLocalHost;

+ (NSString*)formatCurrentDateToString:(NSString*)format;

+ (NSString*)formatDateToString:(NSDate*)date format:(NSString*)format;

+ (NSDate*)formatStringToDate:(NSString*)strDate format:(NSString*)format;

+ (NSDate*)firstDayOfThisMonth:(NSDate*)date;

+ (NSDate*)lastDayOfThisMonth;

+ (NSString*)convertToLocalPath:(NSString*)serverPath;

+ (BOOL)checkLocalFileExit:(NSString*)fileName;

+ (NSString*)unzipPassword;
@end
