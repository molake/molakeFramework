/**
*  MLKAppStoreHelper.h
*  Accenture
*
*  Created by Accenture on 5/7/15.
*  Copyright (c) 2015 Accenture. All rights reserved.
*/

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

enum UpdateVersionType
{
    RequiredUpdateType,
    OptionalUpdateType,
    NoNeedUpdateType,
};

static NSString * const MLKAppVersionKey = @"AppVersion";

@interface MLKAppStoreHelper : NSObject<SKStoreProductViewControllerDelegate>

/**
 * @brief openAppStoreWithIdentify present a page to download the app
 *
 * @param identify the appID of the app
 *
 * @param viewController the root to present the download page
 */
- (void)openAppStoreWithIdentify:(NSString*)identify presentViewController:(UIViewController*)viewController;

/**
 * @brief openAppStoreWithPresentViewController present a page to download the app
 *
 * @param viewController the root to present the download page
 */
- (void)openAppStoreWithPresentViewController:(UIViewController*)viewController;

/**
 * @brief checkVersion check the app version and update the to new version
 *
 * @param newVersion get the latest version of app
 *
 * @result return updated state
 */
- (enum UpdateVersionType)checkVersion:(NSString*)newVersion;
@end
