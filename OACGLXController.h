//
//  OACGLXController.h
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright 2010 John Kooker. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OACGLXController : NSObject {
    BOOL sendAtConstantRate;
}

@property BOOL sendAtConstantRate;

- (void)mouseMovedToX:(float)x Y:(float)y;
- (void)wheelMotionUp;
- (void)wheelMotionDown;
- (void)updateAcceleration:(UIAcceleration *)acceleration;
- (void)keyPress:(NSString *)key;
- (void)updateMultitouch:(NSDictionary *)touches bounds:(CGRect)bounds;

@end
