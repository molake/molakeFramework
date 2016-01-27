//
//  TPEBackgroundFetchOperation.m
//  TPEducation
//
//  Created by RenChao on 4/20/15.
//  Copyright (c) 2015 Accenture. All rights reserved.
//

#import "MLKBackgroundFetchOperation.h"
#import "MLKBackgroundPostLogic.h"
#import "MLKBlockAddition.h"
#import "MLKKeyChainHelper.h"

@interface MLKBackgroundFetchOperation ()

@property (copy, nonatomic)CompletionHandler completionHandler;
@end

@implementation MLKBackgroundFetchOperation
- (instancetype)initWithParameters:(id)parameters completionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (self == [super initWithParameters:parameters])
    {
        self.parameters = parameters;
        self.completionHandler = completionHandler;
    }
    return self;
}

- (void)callMainFunction
{
    MLKBackgroundPostLogic *postFunction = [[MLKBackgroundPostLogic alloc] initWithCompeltionHandler:self.completionHandler];
    NSError *error = nil;

    for (NSString *user in self.parameters)
    {
        NSString *password = [MLKKeyChainHelper getPassword:user];
        if (password == nil || [password isEqualToString:@""])
        {
            return;
        }
        NSDictionary *userInfo = @{MLKUSERNAME: user, MLKPASSWORD: password};
        [postFunction postInformationWithUser:userInfo error:&error];
    }
}

@end
