//
//  MLKDownloadOperation.h
//  MLK
//
//  Created by RenChao on 8/11/15.
//  Copyright (c) 2015 Accenture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLKOperation.h"
#import "MLKLogHelper.h"
#import <UIKit/UIKit.h>
#import "MLKDownloadHelper.h"

@protocol MLKDownlaodOperationDelegate;
@interface MLKDownloadOperation : NSObject<MLKDownloadControllerDelegate>
@property (strong, nonatomic) MLKLogHelper *logHelper;

@property (strong, nonatomic) NSString *cookie;

@property (weak, nonatomic) id<MLKDownlaodOperationDelegate> delegate;

@property (copy, nonatomic) CompletionHandler completionHandler;

- (instancetype)initWithParameters:(id)parameters;

- (void)startDownload;

- (void)stopDownload;

@end

@protocol MLKDownlaodOperationDelegate <NSObject>
- (void)downloadRequestFinished:(NSString *)fileName;

- (void)downloadRequestFinishedWitherror:(NSString*)fileName;

@end