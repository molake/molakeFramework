//
//  MLKDownloadOperation.m
//  MLK
//
//  Created by RenChao on 8/11/15.
//  Copyright (c) 2015 Accenture. All rights reserved.
//

#import "MLKDownloadOperation.h"
#import "MLKSimpleHelper.h"
#import "MLKWebServiceHelper.h"
#import "MLKDownloadHelper.h"
#import "MLKSettingsBundleHelper.h"
#import "MLKBackgroundPostLogic.h"
#import "MLKKeyChainHelper.h"
#import "MLKLoginUsers.h"

@interface MLKDownloadOperation ()
@property (strong, nonatomic) NSMutableArray *downloadArray;

@property (nonatomic) NSInteger downloadCount;

@property (strong, nonatomic) id parameters;

@property (strong, nonatomic) MLKDownloadHelper *downloadHelper;


@end

@implementation MLKDownloadOperation
{
    MLKWebServiceHelper *webService;
    NSString *user;
}
@synthesize delegate;

- (MLKLogHelper *)logHelper {
    if (!_logHelper) {
        _logHelper = [[MLKLogHelper alloc] init];
    }
    return _logHelper;
}

- (instancetype)initWithParameters:(id)parameters
{
    if (self == [super init])
    {
        _downloadArray = [[NSMutableArray alloc] init];
        _downloadCount = 0;
        self.parameters = parameters;
        
    }
    return self;
}

- (void)startDownload
{
    webService = [[MLKWebServiceHelper alloc] init];
    
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];
    NSString *documents = [MLKSimpleHelper getDocumentPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *subPaths = [fileManager subpathsAtPath:documents];
    for (NSString *strPath in subPaths)
    {
        @autoreleasepool {
            NSString *extension = [strPath pathExtension];
            if ([extension isEqualToString:@"zip"])
            {
                NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:[documents stringByAppendingPathComponent:strPath] error:nil];
                if (fileAttributes != nil)
                {
                    NSNumber *fileSize;
                    fileSize = [fileAttributes objectForKey:NSFileSize];
                    [fileArray addObject:@{@"fileName": strPath, @"size": fileSize}];
                }
            }

        }
    }
    NSError *error = nil;
    user = self.parameters[0];
    NSString *password = [MLKKeyChainHelper getPassword:user];
    if (password == nil || [password isEqualToString:@""])
    {
        return;
    }
    
    NSDictionary *userInfo = @{MLKUSERNAME: user, MLKPASSWORD: password};
    self.logHelper.dbName = user;
    [self.logHelper log:[self class] methodName:_cmd logMessage:@"BG DL START" logLevel:DEBUGLOG];
    
    NSString *sessionID = [webService loginWithUserInfo:userInfo error:&error];
    NSString *strCookie = [self createCookieWithSession:sessionID];
    
    if (strCookie != nil && ![strCookie isEqualToString:@""])
    {
        self.cookie = strCookie;
        [[MLKLoginUsers sharedInstance].userInfo setValue:strCookie forKey:user];
        NSDictionary *dictionary = [webService serviceDL:@{@"fileList": fileArray} cookie:strCookie error:&error];
        [_downloadArray addObjectsFromArray:dictionary[@"fileList"]];
        if ([_downloadArray count]>0)
        {
            NSString *strFileName = _downloadArray[_downloadCount];
            NSString *fullPath = [self downloadFullPath:strFileName];
            NSLog(@"downloadFilePath:%@", fullPath);
            strFileName = [strFileName stringByAppendingString:MLKDownloadExtension];
            //NSString *strTempFileName = [strFileName stringByAppendingString:MLKDownloadExtension];
            //NSString *fullPath = [self downloadFullPath:strFileName];
            _downloadHelper = [[MLKDownloadHelper alloc] initWithDelegate:self];
            
            NSDictionary *dictionary = [MLKSimpleHelper getSettingPlist];
            NSNumber *timeout = dictionary[@"DownloadTimeOutBG"];
            [_downloadHelper setTimeoutInterval:[timeout integerValue]];
            [_downloadHelper setStrCookie:strCookie];
            _downloadCount++;
//            [downloadHelper startDownloadTask:strTempFileName url:fullPath];
            
            [_downloadHelper startDownloadTask:strFileName url:fullPath success:nil failed:nil];
            
            
            /*[_downloadHelper downloadWithCookie:strFileName url:fullPath success:^(NSString *fileName) {
                [self downloadRequestFinished:fileName];
            } failed:^(NSString *fileNameAndCode) {
                
                NSArray *strArr = [fileNameAndCode componentsSeparatedByString:@","];
                NSString *fileName = strArr[0];
                NSString *codeValue = strArr[1];
                [self downloadRequestFinishedWitherror:fileName errorCode:codeValue];
            }];*/
        }
        else
        {
            [webService logOutBG:strCookie withDB:user];
            self.completionHandler(UIBackgroundFetchResultNewData);
            [self.logHelper log:[self class] methodName:_cmd logMessage:@"BG DL END" logLevel:DEBUGLOG];
        }
    }
    else
    {
        self.completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (NSString *)createCookieWithSession:(NSString*)sessionID
{
    NSString *strCookie = @"";
    NSArray *sessions = [sessionID componentsSeparatedByString:@", "];
    for (NSString *strSesscion in sessions)
    {
        NSArray *componentArray = [strSesscion componentsSeparatedByString:@"; "];
        NSString *cookie = [componentArray[0] stringByAppendingString:@"; "];
        
        strCookie = [strCookie stringByAppendingString:cookie];
    }
    
    return strCookie;
}

- (NSString*)downloadFullPath:(NSString*)filePath
{
    NSString *strHost = [MLKSettingsBundleHelper getValueForKey:MLKURLString];
    NSString *urlPath = [NSString stringWithFormat:MLKDownloadURL, strHost, filePath];
    
    return urlPath;
    
}

- (void)stopDownload
{
    [_downloadHelper pause];
}

#pragma mark - download delegate
- (void)downloadRequestStart:(NSString*)fileName
{
    
}

- (void)downloadRequestDownloading:(float)progress indexPath:(NSIndexPath*)indexPath
{
    NSLog(@"Downloading..........................");
}

//- (void)downloadRequestFinished:(NSString *)fileName
//{
//    NSString *newName = [fileName stringByReplacingOccurrencesOfString:MLKDownloadExtension withString:@""];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isDirectory = NO;
//    if ([fileManager fileExistsAtPath:[[MLKSimpleHelper getDocumentPath] stringByAppendingPathComponent:newName] isDirectory:&isDirectory])
//    {
//        [fileManager removeItemAtPath:[[MLKSimpleHelper getDocumentPath] stringByAppendingPathComponent:newName] error:nil];
//    }
//    
//    if ([fileManager copyItemAtPath:[[MLKSimpleHelper getDocumentPath] stringByAppendingPathComponent:fileName] toPath:[[MLKSimpleHelper getDocumentPath] stringByAppendingPathComponent:newName] error:nil])
//    {
//        [fileManager removeItemAtPath:[[MLKSimpleHelper getDocumentPath] stringByAppendingPathComponent:fileName] error:nil];
//    }
//    NSLog(@"downloadFileName:%@", fileName);
//    
//    if (_downloadCount +1 <= [_downloadArray count])
//    {
//        NSString *strFileName = _downloadArray[_downloadCount];
//        NSString *fullPath = [self downloadFullPath:strFileName];
//        strFileName = [strFileName stringByAppendingString:MLKDownloadExtension];
//    
//        _downloadCount++;
////        [downloadHelper startDownloadTask:strFileName url:fullPath];
//        [_downloadHelper downloadWithCookie:strFileName url:fullPath success:^(NSString *fileName) {
//            [self downloadRequestFinished:fileName];
//        } failed:^(NSString *fileName) {
//            [self downloadRequestFinishedWitherror:fileName];
//        }];
//        
////        self.completionHandler(UIBackgroundFetchResultNewData);
//    }
//    else
//    {
//        NSLog(@"Download finish");
//        [webService logOutBG:self.cookie withDB:user];
//        [self.logHelper log:[self class] methodName:_cmd logMessage:@"BG DL END" logLevel:DEBUGLOG];
//        [delegate downloadRequestFinished:fileName];
//    }
//
//}

//- (void)downloadRequestFinishedWitherror:(NSString *)fileName
//{
//    [webService logOutBG:self.cookie withDB:user];
//    [_downloadArray removeAllObjects];
//    [delegate downloadRequestFinishedWitherror:fileName];
////    self.completionHandler(UIBackgroundFetchResultNewData);
//}


- (void)downloadRequestFinished:(NSString *)fileName indexPath:(NSIndexPath*)indexPath
{
    NSString *newName = [fileName stringByReplacingOccurrencesOfString:MLKDownloadExtension withString:@""];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if ([fileManager fileExistsAtPath:[[MLKSimpleHelper getDocumentPath] stringByAppendingPathComponent:newName] isDirectory:&isDirectory])
    {
        [fileManager removeItemAtPath:[[MLKSimpleHelper getDocumentPath] stringByAppendingPathComponent:newName] error:nil];
    }
    
    if ([fileManager copyItemAtPath:[[MLKSimpleHelper getDocumentPath] stringByAppendingPathComponent:fileName] toPath:[[MLKSimpleHelper getDocumentPath] stringByAppendingPathComponent:newName] error:nil])
    {
        [fileManager removeItemAtPath:[[MLKSimpleHelper getDocumentPath] stringByAppendingPathComponent:fileName] error:nil];
    }
    
    if (_downloadCount +1 <= [_downloadArray count])
    {
        NSString *strFileName = _downloadArray[_downloadCount];
        NSString *fullPath = [self downloadFullPath:strFileName];
        strFileName = [strFileName stringByAppendingString:MLKDownloadExtension];
        [_downloadHelper startDownloadTask:strFileName url:fullPath success:nil failed:nil];
        _downloadCount++;
        
    }
    else
    {
        [webService logOutBG:self.cookie withDB:user];
        [self.logHelper log:[self class] methodName:_cmd logMessage:@"BG DL END" logLevel:DEBUGLOG];
        [delegate downloadRequestFinished:fileName];
    }
}

- (void)downloadRequestFinishedWitherror:(NSError *)error fileName:(NSString*)fileName indexPath:(NSIndexPath*)indexPath
{
    [webService logOutBG:self.cookie withDB:user];
    [_downloadArray removeAllObjects];
    [delegate downloadRequestFinishedWitherror:fileName];
}
@end
