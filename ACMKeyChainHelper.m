/**
 *  MLKKeyChainHelper.m
 *  TPELoginStorage
 *
 *  Created by Harly on 15/3/31.
 *  Copyright (c) 2015 Accenture. All rights reserved.
 */

#import "MLKKeyChainHelper.h"

@implementation MLKKeyChainHelper
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)CFBridgingRelease(kSecClassGenericPassword),(id)CFBridgingRelease(kSecClass),
            service, (id)CFBridgingRelease(kSecAttrService),
            service, (id)CFBridgingRelease(kSecAttrAccount),
            (id)CFBridgingRelease(kSecAttrAccessibleAfterFirstUnlock),(id)CFBridgingRelease(kSecAttrAccessible),
            nil];
}

+ (BOOL)saveKeyChain:(NSString *)userName Password:(NSString* )password {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:userName];
    OSStatus status;
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)CFBridgingRetain(keychainQuery), (CFTypeRef *)&keyData) == noErr)
    {
        //Delete old item before add new item
        status = SecItemDelete((CFDictionaryRef)CFBridgingRetain(keychainQuery));
        if (status != noErr)
        {
            return NO;
        }
    }
    
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:password] forKey:(id)CFBridgingRelease(kSecValueData)];
    //Add item to keychain with the search dictionary
    status = SecItemAdd((CFDictionaryRef)CFBridgingRetain(keychainQuery), NULL);
    if (status == noErr)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (id)getPassword:(NSString *)userName {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:userName];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)CFBridgingRelease(kSecReturnData)];
    [keychainQuery setObject:(id)CFBridgingRelease(kSecMatchLimitOne) forKey:(id)CFBridgingRelease(kSecMatchLimit)];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)CFBridgingRetain(keychainQuery), (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData *)CFBridgingRelease(keyData)];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", userName, e);
        } @finally {
        }
    }

  return ret;
}

+ (BOOL)deleteKeyChain:(NSString *)userName {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:userName];
    OSStatus status = SecItemDelete((CFDictionaryRef)CFBridgingRetain(keychainQuery));
    if (status != noErr)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (BOOL)verifyUser:(NSString *)userName Password:(NSString *)password{
    NSString *tempPassword = (NSString *)[MLKKeyChainHelper getPassword:userName];
    if(!tempPassword){
        return false;
    }
    else{
        if ([password isEqualToString:tempPassword]) {
            return true;
        }
        else{
            return false;
        }
    }
}

@end
