//
//  CATextLayer+NumberJump.h
//  BZNumberJumpDemo
//
//  Created by Bruce on 14-7-1.
//  Copyright (c) 2014年 com.Bruce.Number. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NJDBezierCurve.h"

@interface CATextLayer (NumberJump)
typedef void (^completionBlock)(BOOL finished);
- (void)jumpNumberWithDuration:(int)duration
                    fromNumber:(float)startNumber
                      toNumber:(float)endNumber
                    completion:(completionBlock)predicate;

-(void)stopJumpingWithFinalNumber:(float)finalNumber;

@end
