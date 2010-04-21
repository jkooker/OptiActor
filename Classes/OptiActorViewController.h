//
//  OptiActorViewController.h
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright John Kooker 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "OAInfoViewController.h"

@interface OptiActorViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet OAInfoViewController *infoViewController;
    
    UIPopoverController *popoverController;
    UITextField *hiddenField;
}

@property (nonatomic, assign) IBOutlet OAInfoViewController *infoViewController;

- (IBAction)showKeyboard:(id)sender;
- (IBAction)showInfo:(id)sender;

@end

