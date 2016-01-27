//
//  MLKCommonFunction.m
//  TPEducation
//
//  Created by Accenture on 4/7/15.
//  Copyright (c) 2015 Accenture. All rights reserved.
//

#import "MLKSimpleHelper.h"

@implementation MLKSimpleHelper
+ (NSString*)getDocumentPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = paths[0];
    NSLog(@"Documents:%@", docDir);
    return docDir;
}

+ (NSDictionary*)getSettingPlist
{
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:strPath];
    return dictionary;
}

+ (NSString*)getLocalHost
{
    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:strPath];
    NSString *strHost = [dictionary objectForKey:@"CommonServerURL"];
#if DEBUG
//    return @"http://10.202.24.117:8080/MLK";
    return @"http://210.148.14.144/it";
#endif
    return strHost;
}

+ (NSString*)formatCurrentDateToString:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];//@"yyyy-MM-dd HH:mm:ss"
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateStr;
}

+ (NSString*)formatDateToString:(NSDate*)date format:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];//@"yyyy-MM-dd HH:mm:ss"
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

+ (NSDate*)formatStringToDate:(NSString*)strDate format:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:strDate];
    return date;
}

+ (NSDate*)firstDayOfThisMonth:(NSDate*)date
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth
                               fromDate:today];
    comps.day = 1;
    NSDate *firstDay = [calendar dateFromComponents:comps];
    return firstDay;
}

+ (NSDate*)lastDayOfThisMonth
{
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    NSDateComponents *comps = [calendar
                               components:NSCalendarUnitYear | NSCalendarUnitMonth
                               fromDate:today];
    
    comps.day = numberOfDaysInMonth;
    NSDate *lastDay = [calendar dateFromComponents:comps];
    return lastDay;
}

+ (NSString*)convertToLocalPath:(NSString*)serverPath
{
    return [serverPath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
}

+ (BOOL)checkLocalFileExit:(NSString*)fileName
{
    NSString *documentPath = [MLKSimpleHelper getDocumentPath];
    NSString *fullPath = [documentPath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:fullPath];
}

+ (NSString*)unzipPassword
{
    NSDictionary *settings = [MLKSimpleHelper getSettingPlist];
    NSString *pwd = settings[@"UnzipPassword"];
    return pwd;
}
@end
