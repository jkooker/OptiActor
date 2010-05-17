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
    int mouseButtonState;
    CGPoint lastMousePosition;
    int serverType;
    int serverPort;
}

@property BOOL sendAtConstantRate;
@property int mouseButtonState;
@property int serverPort;

- (void)mouseEventAtX:(float)x Y:(float)y down:(BOOL)down;
- (void)mouseMovedToX:(float)x Y:(float)y;
- (void)wheelMotionUpAtX:(float)x Y:(float)y;
- (void)wheelMotionDownAtX:(float)x Y:(float)y;
- (void)updateAcceleration:(UIAcceleration *)acceleration;
- (void)keyPress:(NSString *)key;
- (void)updateMultitouch:(NSDictionary *)touches bounds:(CGRect)bounds;
- (void)setServerType:(int)type;

@end
