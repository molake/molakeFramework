//
//  TPESettings.m
//  TPEducation
//
//  Created by RenChao on 5/11/15.
//  Copyright (c) 2015 Accenture. All rights reserved.
//

#import "MLKSettings.h"
#import "MLKSettingsBundleHelper.h"

static NSString * const MLKURLTextFieldKey = @"connectUrl";
static NSString * const MLKFakeDayKey = @"deemDateUpdateTime";

@implementation MLKSettings
@synthesize strURL = _strURL, strFakeTime = _strFakeTime;

+ (MLKSettings*)defaultSettings
{
    static MLKSettings *defaultSettings = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        defaultSettings = [[MLKSettings alloc] init];
    });
    return defaultSettings;
}

- (instancetype)init
{
    if (self == [super init])
    {
        _strURL = @"";
        _strFakeTime = @"";
    }
    return self;
}

- (void)setDefaultValue
{
    [MLKSettingsBundleHelper setValue:_strURL forKey:MLKURLTextFieldKey];
    [MLKSettingsBundleHelper setValue:_strFakeTime forKey:MLKFakeDayKey];
}

- (void)setStrURL:(NSString *)strURL
{
    _strURL = strURL;
    [MLKSettingsBundleHelper setValue:_strURL forKey:MLKURLTextFieldKey];
}

- (void)setStrFakeTime:(NSString *)strFakeDay
{
    _strFakeTime = strFakeDay;
    [MLKSettingsBundleHelper setValue:_strFakeTime forKey:MLKFakeDayKey];
}

- (NSString*)strFakeTime
{
    NSString *strValue = [MLKSettingsBundleHelper getValueForKey:MLKFakeDayKey];
    _strFakeTime = strValue;
    return _strFakeTime;
}

- (NSString*)strURL
{
    NSString *strValue = [MLKSettingsBundleHelper getValueForKey:MLKURLTextFieldKey];
    _strURL = strValue;
    return _strURL;
}

@end
