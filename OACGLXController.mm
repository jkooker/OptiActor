//
//  OACGLXController.m
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright 2010 John Kooker. All rights reserved.
//

#import "OACGLXController.h"
#import "cglXnet/cglXNet.h"

int charToKeyCode(unichar a);

cglXServer *server;

@implementation OACGLXController
@synthesize sendAtConstantRate;
@synthesize mouseButtonState;

- (void)awakeFromNib {
    server = new cglXServer(CS_HCI_X_SERV, 5510);
    //server = new cglXServer(CS_HCI_MT_SERV, 5510);
    server->setWaitTime(0);
    
    self.sendAtConstantRate = NO;
    self.mouseButtonState = 0;
}

- (void)mouseEventAtX:(float)x Y:(float)y down:(BOOL)down {
    //NSLog(@"Mouse event at x:%0.2f y:%0.2f", x, y);

    lastMousePosition.x = x;
    lastMousePosition.y = y;
    
    CS_EXT_MEVENT_S event;
    event.ID = 0;
    event.type = (down ? CGLX_ButtonPress : CGLX_ButtonRelease);
    switch (mouseButtonState) {
        case CGLX_LEFT_BUTTON:
            event.mask = CGLX_Button1Mask;
            break;
        case CGLX_MIDDLE_BUTTON:
            event.mask = CGLX_Button2Mask;
            break;
        case CGLX_RIGHT_BUTTON:
            event.mask = CGLX_Button3Mask;
            break;
        default:
            event.mask = 0;
            break;
    }
    event.x = x;
    event.y = y;
    event.button = mouseButtonState;
}

- (void)mouseMovedToX:(float)x Y:(float)y {
    //NSLog(@"Mouse motion to x:%0.2f y:%0.2f", x, y);
    
    lastMousePosition.x = x;
    lastMousePosition.y = y;

    CS_EXT_MOTION_S motion;
    motion.ID = 0;
    motion.type = CGLX_MotionNotify;
    switch (mouseButtonState) {
        case CGLX_LEFT_BUTTON:
            motion.mask = CGLX_Button1Mask;
            break;
        case CGLX_MIDDLE_BUTTON:
            motion.mask = CGLX_Button2Mask;
            break;
        case CGLX_RIGHT_BUTTON:
            motion.mask = CGLX_Button3Mask;
            break;
        default:
            motion.mask = 0;
            break;
    }
    motion.x = x;
    motion.y = y;
    
    server->sendData(&motion);
}

- (void)wheelMotionUpAtX:(float)x Y:(float)y {
    //NSLog(@"wheelMotionUp");
    
    CS_EXT_MEVENT_S event;
    event.ID = 0;
    event.type = CGLX_ButtonRelease;
    event.mask = 0;
    event.x = x;
    event.y = y;
    event.button = CGLX_WHEEL_UP;
    
    server->sendData(&event);
}

- (void)wheelMotionDownAtX:(float)x Y:(float)y {
    //NSLog(@"wheelMotionDown");
    
    CS_EXT_MEVENT_S event;
    event.ID = 0;
    event.type = CGLX_ButtonRelease;
    event.mask = 0;
    event.x = x;
    event.y = y;
    event.button = CGLX_WHEEL_DOWN;
    
    server->sendData(&event);
}

- (void)updateAcceleration:(UIAcceleration *)acceleration {
    //NSLog(@"accelerometer update x:%0.2f y:%0.2f z:0.2f", acceleration.x, acceleration.y, acceleration.z);
    
    CS_EXT_SMEVENT_S event;
    event.ID = 0;
    event.b = 0;
    event.X = 0;
    event.Y = 0;
    event.Z = 0;
    event.Rx = acceleration.x;
    event.Ry = acceleration.y;
    event.Rz = acceleration.z;
    
    server->sendData(&event);
}

- (void)keyPress:(NSString *)key {
    unichar a = [key characterAtIndex:0];
    int keycode = charToKeyCode(a);

    //NSLog(@"key code: %d", keycode);
    
    CS_EXT_KBEVENT_S keyEvent;
    keyEvent.ID = 0;
    keyEvent.type = CGLX_KeyRelease;
    keyEvent.mask = ((a >= 'A') ? CGLX_SHIFT_MASK : 0);
    keyEvent.x = lastMousePosition.x;
    keyEvent.y = lastMousePosition.y;
    keyEvent.keycode = keycode;
    
    server->sendData(&keyEvent);
}

#define BLOB_RADIUS 0.02

- (void)updateMultitouch:(NSDictionary *)touchPoints bounds:(CGRect)bounds {
    NSUInteger touchCount = [touchPoints count];
    CS_MT_BLOB_S blobs[touchCount];
    
    int i = 0;
    for (id key in touchPoints) {
        CGPoint p = [[touchPoints objectForKey:key] CGPointValue];
        blobs[i].minX = p.x / bounds.size.width - BLOB_RADIUS;
        blobs[i].minY = 1 - (p.y / bounds.size.height + BLOB_RADIUS);
        blobs[i].maxX = p.x / bounds.size.width + BLOB_RADIUS;
        blobs[i].maxY = 1 - (p.y / bounds.size.height - BLOB_RADIUS);
        blobs[i].pres = 100;
        
        i++;
    }
    
    CS_EXT_MULTIT_S allBlobs;
    allBlobs.ID = 0;
    allBlobs.num = touchCount;
    allBlobs.blobs = blobs;
    
    server->sendData(&allBlobs);
}

- (void)dealloc {
    delete server;
    [super dealloc];
}

@end

int charToKeyCode(unichar a) {
    // TODO: implement lookup table here
    return a;
}