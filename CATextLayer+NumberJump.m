//
//  CATextLayer+NumberJump.m
//  BZNumberJumpDemo
//
//  Created by Bruce on 14-7-1.
//  Copyright (c) 2014年 com.Bruce.Number. All rights reserved.
//

#import "CATextLayer+NumberJump.h"

#define kPointsNumber 100 // jump 100 times
#define kDurationTime 5.0 // animation time
#define kStartNumber  0   // start num
#define kEndNumber    1000// end num

@implementation CATextLayer (NumberJump)

NSMutableArray *numberPoints;//record the intever and output value of textLayer
float lastTime;
int indexNumber;

Point2D startPoint;
Point2D controlPoint1;
Point2D controlPoint2;
Point2D endPoint;

completionBlock _completeBlock;
int _duration;
float _startNumber;
float _endNumber;
bool _shouldStop;

- (void)cleanUpValue {
    lastTime = 0;
    indexNumber = 0;
    self.string = [NSString stringWithFormat:@"%.0f",_startNumber];
}

-(void)stopJumpingWithFinalNumber:(float)finalNumber
{
    _endNumber = finalNumber;
    indexNumber = kPointsNumber;
}

- (void)jumpNumberWithDuration:(int)duration
                    fromNumber:(float)startNumber
                      toNumber:(float)endNumber
                    completion:(completionBlock)complete
{
    _duration = duration;
    _startNumber = startNumber;
    _endNumber = endNumber;
    _completeBlock = complete;
    
    [self cleanUpValue];
    [self initPoints];
    [self changeNumberBySelector];
}

- (void)initPoints {
    // Bessel curve
    [self initBezierPoints];
    Point2D bezierCurvePoints[4] = {startPoint, controlPoint1, controlPoint2, endPoint};
    numberPoints = [[NSMutableArray alloc] init];
    float dt;
    dt = 1.0 / (kPointsNumber - 1);
    for (int i = 0; i < kPointsNumber; i++) {
        Point2D point = PointOnCubicBezier(bezierCurvePoints, i*dt);
        float durationTime = point.x * _duration;
        float value = point.y * (_endNumber - _startNumber) + _startNumber;
        [numberPoints addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:durationTime], [NSNumber numberWithFloat:value], nil]];
    }
}

- (void)initBezierPoints {
    
    startPoint.x = 0;
    startPoint.y = 0;
    
    controlPoint1.x = 0.25;
    controlPoint1.y = 0.1;
    
    controlPoint2.x = 0.25;
    controlPoint2.y = 1;
    
    endPoint.x = 1;
    endPoint.y = 1;
}

- (void)changeNumberBySelector {
    if (indexNumber >= kPointsNumber ) {
        //self.string = [NSString stringWithFormat:@"%.0f",_endNumber];
        self.string = [self formatterNumberStyle:[NSString stringWithFormat:@"%.0f",_endNumber]];
        _completeBlock(YES);
        return;
    } else {
        NSArray *pointValues = [numberPoints objectAtIndex:indexNumber];
        indexNumber++;
        float value = [(NSNumber *)[pointValues objectAtIndex:1] intValue];
        float currentTime = [(NSNumber *)[pointValues objectAtIndex:0] floatValue];
        float timeDuration = currentTime - lastTime;
        lastTime = currentTime;
        //self.string = [NSString stringWithFormat:@"%.0f",value];
        self.string = [self formatterNumberStyle:[NSString stringWithFormat:@"%.0f",value]];
        [self performSelector:@selector(changeNumberBySelector) withObject:nil afterDelay:timeDuration];
        _completeBlock(NO);

    }
}
- (NSString *)formatterNumberStyle:(NSString *)numberStr {
    NSArray *array = [numberStr componentsSeparatedByString:@","];
    for (int i = 0;i < array.count; i++) {
        if (i == 0) {
            numberStr = array[i];
        }else {
            [numberStr stringByAppendingString:array[i]];
        }
    }
    
    NSString *numberFinalFormatter = @"";
    if (numberStr.length > 3) {
        NSInteger cnt1 = numberStr.length / 3;
        NSInteger cnt2 = numberStr.length % 3;
        NSInteger startIndex = 0;
        NSInteger recyCnt = cnt1;
        if (cnt2 != 0) {
            recyCnt = cnt1 + 1;
        }
        
        for (int i = 0; i < recyCnt; i++) {
            if (cnt2 == 0) {
                startIndex =  3 * i;
                NSRange range = NSMakeRange(startIndex, 3);
                
                NSString *str = [numberStr substringWithRange:range];
                numberFinalFormatter = [numberFinalFormatter stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
            }else {
                NSRange range;
                NSString *str ;
                if (i == 0) {
                    
                    range = NSMakeRange(0, cnt2);
                    str = [numberStr substringWithRange:range];
                    numberFinalFormatter = [numberFinalFormatter stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
                }
                else {
                    startIndex = cnt2 + 3 * (i - 1);
                    range = NSMakeRange(startIndex, 3);
                    str = [numberStr substringWithRange:range];
                    numberFinalFormatter = [numberFinalFormatter stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
                }
                
            }
            
        }
        return [numberFinalFormatter substringWithRange:NSMakeRange(0, numberFinalFormatter.length - 1)];
    }
    return numberStr;
    
}
@end
