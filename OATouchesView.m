//
//  OATouchesView.m
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright 2010 John Kooker. All rights reserved.
//

#import "OATouchesView.h"


@implementation OATouchesView

@synthesize cglxController;
@synthesize sendRawMultitouch;
@synthesize isInTrackpadMode;

- (void)awakeFromNib {
    touchPoints = [[NSMutableDictionary dictionaryWithCapacity:11] retain];
    sendRawMultitouch = NO;
    isInTrackpadMode = YES;
}

#define CIRCLE_RADIUS 40

- (void)drawRect:(CGRect)rect {
    for (id key in touchPoints) {
        CGPoint p = [[touchPoints objectForKey:key] CGPointValue];
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(contextRef, 0, 0, 0.4, 0.8);
        CGContextSetRGBStrokeColor(contextRef, 0, 0, 1, 0.9);
        CGContextSetLineWidth(contextRef, 3);
        
        CGRect circle_rect = CGRectMake(p.x - CIRCLE_RADIUS, p.y - CIRCLE_RADIUS, 2 * CIRCLE_RADIUS, 2 * CIRCLE_RADIUS);
        
        // Draw a circle (filled)
        CGContextFillEllipseInRect(contextRef, circle_rect);
        // Draw a circle (border only)
        CGContextStrokeEllipseInRect(contextRef, circle_rect);
    }
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark Touch Handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [touchPoints setObject:[NSValue valueWithCGPoint:[touch locationInView:self]] forKey:[NSNumber numberWithUnsignedInteger:[touch hash]]];
        [self setNeedsDisplay];
        
        //NSLog(@"new touch at %@", NSStringFromCGPoint([touch locationInView:self]));
    }
    
    // Touch Processing
    if (sendRawMultitouch) {
        [cglxController updateMultitouch:touchPoints bounds:[self bounds]];
    } else {
        if ([touchPoints count] == 1) {
            if (!isInTrackpadMode) {
                CGPoint p = [[[touchPoints allValues] objectAtIndex:0] CGPointValue];
                float x = p.x / [self bounds].size.width;
                float y = p.y / [self bounds].size.height;

                [cglxController mouseEventAtX:x Y:y down:YES];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [touchPoints setObject:[NSValue valueWithCGPoint:[touch locationInView:self]] forKey:[NSNumber numberWithUnsignedInteger:[touch hash]]];
        [self setNeedsDisplay];
        
        //NSLog(@"touch moved to %@", NSStringFromCGPoint([touch locationInView:self]));
    }
    
    if (sendRawMultitouch) {
        [cglxController updateMultitouch:touchPoints bounds:[self bounds]];
    } else {
        if (isInTrackpadMode) {
            if ([touchPoints count] == 1) {
                UITouch *touch = [touches anyObject];
                CGPoint p = [touch locationInView:self];
                CGPoint pp = [touch previousLocationInView:self];
                float x = (p.x - pp.x) / [self bounds].size.width;
                float y = (p.y - pp.y) / [self bounds].size.height;

                [cglxController trackpadMotionX:x Y:y];
            } else if ([touchPoints count] == 2) {
                // wheel up/down based on touch motion
                UITouch *touch = [touches anyObject];
                CGPoint p = [touch locationInView:self];

                [cglxController trackpadScroll:(p.y > [touch previousLocationInView:self].y) ? YES : NO];
            }
        } else {
            if ([touchPoints count] == 1) {
                CGPoint p = [[[touchPoints allValues] objectAtIndex:0] CGPointValue];
                float x = p.x / [self bounds].size.width;
                float y = p.y / [self bounds].size.height;

                [cglxController mouseMovedToX:x Y:y];
            } else if ([touchPoints count] == 2) {
                // wheel up/down based on touch motion
                UITouch *touch = [touches anyObject];
                CGPoint p = [touch locationInView:self];
                float x = p.x / [self bounds].size.width;
                float y = p.y / [self bounds].size.height;

                if (p.y > [touch previousLocationInView:self].y) {
                    [cglxController wheelMotionDownAtX:x Y:y];
                } else {
                    [cglxController wheelMotionUpAtX:x Y:y];
                }
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if ([touchPoints count] == 1) {
            if (!isInTrackpadMode) {
                CGPoint p = [[[touchPoints allValues] objectAtIndex:0] CGPointValue];
                float x = p.x / [self bounds].size.width;
                float y = p.y / [self bounds].size.height;

                [cglxController mouseEventAtX:x Y:y down:NO];
            }
        }
        
        [touchPoints removeObjectForKey:[NSNumber numberWithUnsignedInteger:[touch hash]]];
        [self setNeedsDisplay];

        //NSLog(@"touch ended at %@", NSStringFromCGPoint([touch locationInView:self]));
    }
    
    if (sendRawMultitouch) {
        [cglxController updateMultitouch:touchPoints bounds:[self bounds]];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches cancelled");
}

@end
