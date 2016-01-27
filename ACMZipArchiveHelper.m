/**
 *  ZipArchiveController.m
 *  TPEducation
 *
 *  Created by Accenture on 4/1/15.
 *  Copyright (c) 2015 Accenture. All rights reserved.
 */

#import "MLKZipArchiveHelper.h"
#import <zipzap/zipzap.h>
#import "MLKSimpleHelper.h"

static NSString * const TPEZipNameKey = @"TPEZipNameKey";
static NSString * const TPEZipCountKey = @"TPEZipCountKey";

@interface MLKZipArchiveHelper()
@property (strong, nonatomic) ZZArchive* archiver;
@end

@implementation MLKZipArchiveHelper

- (instancetype)initWithZipFileName:(NSString*)fileName error:(NSError**)error
{
    if (self == [super init])
    {
        NSURL *url = [self getDataFromPath:fileName];
        _archiver = [[ZZArchive alloc] initWithURL:url options:@{ZZOpenOptionsEncodingKey: [NSNumber numberWithInt:NSShiftJISStringEncoding]} error:error];
    }
    return self;
}

#pragma mark - zipArchive
- (NSMutableArray*)getZipContentNames
{
    NSInteger count = [_archiver.entries count];
    NSMutableArray *namesArray = [[NSMutableArray alloc] init];
    for (int i=0; i<count; i++)
    {
        ZZArchiveEntry *archiveEntry = _archiver.entries[i];
        NSString *strName = [archiveEntry.fileName lastPathComponent];
        NSMutableDictionary *dictionary = [self getInvalidName:strName Position:i];
        if (dictionary != nil)
        {
            [namesArray addObject:dictionary];
        }
    }
    return namesArray;
}

- (NSData*)getSelectedFileData:(NSString*)fileName error:(NSError**)error
{
    NSInteger count = [_archiver.entries count];
    for (int i=0; i<count; i++)
    {
        ZZArchiveEntry *archiveEntry = _archiver.entries[i];
        if ([archiveEntry.fileName isEqualToString:fileName])
        {
            NSData *data = [archiveEntry newDataWithError:error];
            return data;
        }
    }
    return nil;
}

- (NSData*)getSelectedFileDataWithPassword:(NSString*)password FileName:(NSString*)fileName error:(NSError**)error
{
    NSInteger count = [_archiver.entries count];
    for (int i=0; i<count; i++)
    {
        ZZArchiveEntry *archiveEntry = _archiver.entries[i];
        if ([archiveEntry.fileName isEqualToString:fileName])
        {
            NSData *data = [archiveEntry newDataWithPassword:password error:error];
            return data;
        }
    }
    return nil;
}

- (NSMutableArray*)getAllDataFromZipWithURL:(NSError**)error
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ZZArchiveEntry *archiveEntry in _archiver.entries) {
        NSData *data = [archiveEntry newDataWithError:error];
        [array addObject:data];
    }
    return array;
}

/** 
 * @brief getInvalidName filter the hidden in zip archived by MacOS
 *
 * @param name the file name to compare
 *
 * @param count the count of the file in zip file
 *
 * @result return a dictionary with file name and count
 */
- (NSMutableDictionary*)getInvalidName:(NSString*)name Position:(NSInteger)count
{
    if ([name rangeOfString:@"_MACOSX"].length <= 0)
    {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:name, TPEZipNameKey, [NSNumber numberWithInteger:count], TPEZipCountKey, nil];
        return dictionary;
    }
    else
    {
        return nil;
    }
}

/**
 * @brief getDataFromPath get local path of zip file
 *
 * @param strName the name of zip file
 *
 * @result the url of the path
 */
- (NSURL*)getDataFromPath:(NSString*)strName
{
    NSString *docDir = [MLKSimpleHelper getDocumentPath];
    NSString *strPath = [docDir stringByAppendingPathComponent:strName];
//    NSString *strPath = [[NSBundle mainBundle] pathForResource:@"123" ofType:@"zip"];
    NSURL *url = [NSURL fileURLWithPath:strPath];
    return url;
}

@end
