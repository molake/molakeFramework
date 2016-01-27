
/**
*  ZipArchiveController.h
*  TPEducation
*
*  Created by Accenture on 4/1/15.
*  Copyright (c) 2015 Accenture. All rights reserved.
*/

#import <Foundation/Foundation.h>

@interface MLKZipArchiveHelper : NSObject

/**
 * @brief initWithURL init zip archiver
 *
 * @param fileName the name of zip file
 *
 * @param error get error of 
 *
 * @result return ZipArchiveController object
 */
- (instancetype)initWithZipFileName:(NSString*)fileName error:(NSError**)error;

/**
 * @brief getZipContentNames get all file names in zip file
 *
 * @result return an NSMutableArray with all names
 */
- (NSMutableArray*)getZipContentNames;

/**
 * @brief getSelectedFile Unarchive single file in zip file
 *
 * @param fileName the name of zip file
 *
 * @result return an NSData object of file
 */
- (NSData*)getSelectedFileData:(NSString*)fileName error:(NSError**)error;

/**
 * @brief getSelectedFileDataWithPassword Unarchive single file in zip file with password
 * @param password password for zip file
 *
 * @param fileName the name of zip file
 *
 * @param error get error of
 *
 * @result return an NSData object of file
 */
- (NSData*)getSelectedFileDataWithPassword:(NSString*)password FileName:(NSString*)fileName error:(NSError**)error;
/** 
 * @brief getAllDataFromZipWithURL Unarchive all files and save into an array
 *
 * @param error get error of
 *
 * @result return an array saved all NSData object of files
 */
- (NSMutableArray*)getAllDataFromZipWithURL:(NSError**)error;
@end
