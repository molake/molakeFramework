/**
*  MLKOperation.h
*  TPEducation
*
*  Created by Accenture on 4/20/15.
*  Copyright (c) 2015 Accenture. All rights reserved.
*/

#import <Foundation/Foundation.h>

@interface MLKOperation : NSOperation

/**
 * @brief parameters
 *
 * parameters of function
 *
 */
@property (strong, nonatomic) id parameters;
/**
 * @brief initWithParameters init
 *
 * @param parameters parameters of operation
 *
 * @result self
 */
- (instancetype)initWithParameters:(id)parameters;
@end
