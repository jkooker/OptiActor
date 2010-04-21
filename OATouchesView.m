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

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        touchPoint.x = -50;
        touchPoint.y = -50;
    }
    return self;
}

#define CIRCLE_RADIUS 40

- (void)drawRect:(CGRect)rect {
    if (touchPoint.x > 0) {
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(contextRef, 0, 0, 0.4, 0.8);
        CGContextSetRGBStrokeColor(contextRef, 0, 0, 1, 0.9);
        CGContextSetLineWidth(contextRef, 3);
        
        CGRect circle_rect = CGRectMake(touchPoint.x - CIRCLE_RADIUS, touchPoint.y - CIRCLE_RADIUS, 2 * CIRCLE_RADIUS, 2 * CIRCLE_RADIUS);
        
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
        // monitor and log it
        touchPoint.x = [touch locationInView:self].x;
        touchPoint.y = [touch locationInView:self].y;
        [self setNeedsDisplay];
        
        float x = touchPoint.x / [self bounds].size.width;
        float y = touchPoint.y / [self bounds].size.height;
        
        //NSLog(@"new touch at %@", NSStringFromCGPoint([touch locationInView:self]));
        [cglxController mouseMovedToX:x Y:y];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        // monitor and log it
        touchPoint.x = [touch locationInView:self].x;
        touchPoint.y = [touch locationInView:self].y;
        [self setNeedsDisplay];
        
        float x = touchPoint.x / [self bounds].size.width;
        float y = touchPoint.y / [self bounds].size.height;

        //NSLog(@"touch moved to %@", NSStringFromCGPoint([touch locationInView:self]));
        [cglxController mouseMovedToX:x Y:y];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        // redraw and log it
        touchPoint.x = -50;
        touchPoint.y = -50;
        [self setNeedsDisplay];

        //NSLog(@"touch ended at %@", NSStringFromCGPoint([touch locationInView:self]));
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches cancelled");
}




@end
