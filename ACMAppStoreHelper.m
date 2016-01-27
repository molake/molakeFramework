/**
 *  MLKAppStoreHelper.m
 *  Accenture
 *
 *  Created by Accenture on 5/7/15.
 *  Copyright (c) 2015 Accenture. All rights reserved.
 */

#import "MLKAppStoreHelper.h"
#import <StoreKit/StoreKit.h>
#import "MLKSimpleHelper.h"


static NSString * const MLKAppIDKey = @"AppID";

@implementation MLKAppStoreHelper
- (void)openAppStoreWithIdentify:(NSString*)identify presentViewController:(UIViewController*)viewController
{
    SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
    productViewController.delegate = self;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:identify forKey:SKStoreProductParameterITunesItemIdentifier];
    [productViewController loadProductWithParameters:dictionary completionBlock:^(BOOL result, NSError *error) {
        if (result)
        {
            [viewController presentViewController:productViewController animated:YES completion:nil];
        }
    }];
}

- (void)openAppStoreWithPresentViewController:(UIViewController*)viewController
{
    NSDictionary *simpleHelperDic = [MLKSimpleHelper getSettingPlist];
    NSString *appID = simpleHelperDic[MLKAppIDKey];//@"507080867";
    SKStoreProductViewController *productViewController = [[SKStoreProductViewController alloc] init];
    productViewController.delegate = self;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:appID forKey:SKStoreProductParameterITunesItemIdentifier];
//    [viewController presentViewController:productViewController animated:YES completion:nil];
    [productViewController loadProductWithParameters:dictionary completionBlock:^(BOOL result, NSError *error) {
        if (result)
        {
            [viewController presentViewController:productViewController animated:YES completion:nil];
        }
    }];
}


- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (enum UpdateVersionType)checkVersion:(NSString*)newVersion
{
    NSDictionary *settingsDic = [MLKSimpleHelper getSettingPlist];
    NSString *strCurrentVersion = [settingsDic objectForKey:MLKAppVersionKey];
    
    if ([strCurrentVersion isEqualToString:newVersion])
    {
        return NoNeedUpdateType;
    }
    
    NSArray *currentVersionArray = [strCurrentVersion componentsSeparatedByString:@"."];
    
    NSArray *newVersionArray = [newVersion componentsSeparatedByString:@"."];
    
    NSInteger count = currentVersionArray.count;
    
    for (int i=0; i<count; i++)
    {
        NSInteger currentVersionCount = [currentVersionArray[i] integerValue];
        NSInteger newVersionCount = [newVersionArray[i] integerValue];
        
        if (i<=1)
        {
            if (newVersionCount > currentVersionCount)
            {
                return RequiredUpdateType;
            } else if (newVersionCount < currentVersionCount)
            {
                return NoNeedUpdateType;
            }
        }
        else
        {
            if (newVersionCount > currentVersionCount)
            {
                return OptionalUpdateType;
            }
        }
    }
    return NoNeedUpdateType;
}
@end
