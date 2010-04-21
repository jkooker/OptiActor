//
//  OptiActorViewController.h
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright John Kooker 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAInfoViewController.h"
#import "OACGLXController.h"

@interface OptiActorViewController : UIViewController <UITextFieldDelegate, UIAccelerometerDelegate> {
    IBOutlet OAInfoViewController *infoViewController;
    IBOutlet OACGLXController *cglxController;
    
    UIPopoverController *popoverController;
    UITextField *hiddenField;
}

@property (nonatomic, assign) IBOutlet OAInfoViewController *infoViewController;
@property (nonatomic, retain) IBOutlet OACGLXController *cglxController;

- (IBAction)showKeyboard:(id)sender;
- (IBAction)showInfo:(id)sender;

@end

