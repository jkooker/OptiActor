//
//  OptiActorViewController.h
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright John Kooker 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptiActorViewController : UIViewController <UITextFieldDelegate> {
    UITextField *hiddenField;
}

- (IBAction)showKeyboard:(id)sender;
- (IBAction)showInfo:(id)sender;

@end

