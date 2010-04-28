//
//  OACGLXController.m
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright 2010 John Kooker. All rights reserved.
//

#import "OACGLXController.h"
//#import "cglXnet/cglXNet.h"

int charToKeyCode(unichar a);

@implementation OACGLXController

- (void)mouseMovedToX:(float)x Y:(float)y {
    NSLog(@"Mouse motion to x:%0.2f y:%0.2f", x, y);
}

- (void)updateAcceleration:(UIAcceleration *)acceleration {
    //NSLog(@"accelerometer update x:%0.2f y:%0.2f z:0.2f", acceleration.x, acceleration.y, acceleration.z);
}

- (void)keyPress:(NSString *)key {
    unichar a = [key characterAtIndex:0];
    int keycode = charToKeyCode(a);

    NSLog(@"key code: %d", keycode);
}

@end

int charToKeyCode(unichar a) {
    // TODO: implement lookup table here
    return a;
}