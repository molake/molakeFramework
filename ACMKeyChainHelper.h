/**
*  MLKKeyChainHelper.h
*  TPELoginStorage
*
*  Created by Harly on 15/3/31.
*  Copyright (c) 2015 Accenture. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface MLKKeyChainHelper : NSObject

/**
 * @brief saveKeyChain save username and password to keychain
 *
 * @param userName user's name
 *
 * @param password user's password
 */
+ (BOOL)saveKeyChain:(NSString *)userName Password:(NSString* )password;

/**
 * @brief getPassword get keychain with username
 *
 * @param userName user's name
 *
 * @result return the reslut that whether the keychain id deleted successfully
 */
+ (id)getPassword:(NSString *)userName;

/**
 * @brief deleteKeyChain description
 *
 * @param username user's name
 *
 * @result return the reslut that whether the keychain id deleted successfully
 */
+ (BOOL)deleteKeyChain:(NSString *)username;

/**
 * @brief verifyUser verify an exist keychain
 *
 * @param userName new username
 *
 * @param password new password
 *
 * @result return the boolean of success
 */
+ (BOOL)verifyUser:(NSString *)userName Password:(NSString *)password;
@end
