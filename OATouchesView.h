//
//  OATouchesView.h
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright 2010 John Kooker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OACGLXController.h"

@interface OATouchesView : UIView {
    IBOutlet OACGLXController *cglxController;
    
    NSMutableDictionary *touchPoints;
    BOOL sendRawMultitouch;
}

@property (nonatomic, retain) IBOutlet OACGLXController *cglxController;
@property BOOL sendRawMultitouch;

@end
