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

- (void)awakeFromNib {
    touchPoints = [[NSMutableDictionary dictionaryWithCapacity:11] retain];
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
    
    if ([touchPoints count] == 1) {
        CGPoint p = [[[touchPoints allValues] objectAtIndex:0] CGPointValue];
        float x = p.x / [self bounds].size.width;
        float y = p.y / [self bounds].size.height;

        [cglxController mouseMovedToX:x Y:y];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [touchPoints setObject:[NSValue valueWithCGPoint:[touch locationInView:self]] forKey:[NSNumber numberWithUnsignedInteger:[touch hash]]];
        [self setNeedsDisplay];
        
        //NSLog(@"touch moved to %@", NSStringFromCGPoint([touch locationInView:self]));
    }
    
    if ([touchPoints count] == 1) {
        CGPoint p = [[[touchPoints allValues] objectAtIndex:0] CGPointValue];
        float x = p.x / [self bounds].size.width;
        float y = p.y / [self bounds].size.height;

        [cglxController mouseMovedToX:x Y:y];
    } else if ([touchPoints count] == 2) {
        // wheel up/down based on touch motion
        UITouch *touch = [touches anyObject];
        if ([touch locationInView:self].y > [touch previousLocationInView:self].y) {
            [cglxController wheelMotionDown];
        } else {
            [cglxController wheelMotionUp];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [touchPoints removeObjectForKey:[NSNumber numberWithUnsignedInteger:[touch hash]]];
        [self setNeedsDisplay];

        //NSLog(@"touch ended at %@", NSStringFromCGPoint([touch locationInView:self]));
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches cancelled");
}




@end
