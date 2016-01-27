//
//  TPEBackgroundFetchOperation.h
//  TPEducation
//
//  Created by RenChao on 4/20/15.
//  Copyright (c) 2015 Accenture. All rights reserved.
//

#import "MLKOperation.h"
#import <UIKit/UIKit.h>

@interface MLKBackgroundFetchOperation : MLKOperation
- (instancetype)initWithParameters:(id)parameters completionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
@end
