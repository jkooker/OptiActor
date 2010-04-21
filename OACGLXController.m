//
//  OACGLXController.m
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright 2010 John Kooker. All rights reserved.
//

#import "OACGLXController.h"
//#import "cglX.h"

@implementation OACGLXController

- (void)mouseMovedToX:(float)x Y:(float)y {
    NSLog(@"Mouse motion to x:%0.2f y:%0.2f", x, y);
}

- (void)updateAcceleration:(UIAcceleration *)acceleration {
    NSLog(@"accelerometer update x:%0.2f y:%0.2f z:0.2f", acceleration.x, acceleration.y, acceleration.z);
}

- (void)keyPress:(NSString *)key {
    int keycode = 0;
    NSLog(@"key code: %d", keycode);
}

@end
