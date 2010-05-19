//
//  OptiActorAppDelegate.h
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright John Kooker 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptiActorViewController;

@interface OptiActorAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    OptiActorViewController *viewController;
    UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet OptiActorViewController *viewController;
@property (nonatomic, retain) UINavigationController *navController;

@end

