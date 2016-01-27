//
//  TPESettings.h
//  TPEducation
//
//  Created by RenChao on 5/11/15.
//  Copyright (c) 2015 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLKSettings : NSObject
@property (strong, nonatomic) NSString *strURL;

@property (strong, nonatomic) NSString *strFakeTime;

+ (MLKSettings*)defaultSettings;
@end
