/**
*  MLKSettingsBundleHelper.h
*  TPEducation
*
*  Created by Accenture on 5/11/15.
*  Copyright (c) 2015 Accenture. All rights reserved.
*/

#import <Foundation/Foundation.h>

@interface MLKSettingsBundleHelper : NSObject

/**
 * @brief getValueForKey: get value in setings bundle
 *
 * @param key key of settings bundle
 *
 * @result value for key
 */
+ (id)getValueForKey:(NSString*)key;

/**
 * @brief setValue:forKey: set value in settings bundle for key
 *
 * @param value the value to be set
 *
 * @param key key of settings bundle
 */
+ (void)setValue:(id)value forKey:(NSString*)key;
@end
