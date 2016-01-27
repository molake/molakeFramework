/**
 *  MLKSettingsBundleHelper.m
 *  TPEducation
 *
 *  Created by Accenture on 5/11/15.
 *  Copyright (c) 2015 Accenture. All rights reserved.
 */

#import "MLKSettingsBundleHelper.h"

@implementation MLKSettingsBundleHelper
+ (id)getValueForKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id value = [defaults objectForKey:key];
    return value;
}

+ (void)setValue:(id)value forKey:(NSString*)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
}
@end
