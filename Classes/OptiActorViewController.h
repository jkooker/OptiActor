//
//  OptiActorViewController.h
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright John Kooker 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OACGLXController.h"
#import "OATouchesView.h"

@class OAInfoViewController;

typedef enum {
    OATouchProcessingTypeTrackpad,
    OATouchProcessingTypeMouse,
    OATouchProcessingTypeMultitouchEvent,
    OATouchProcessingTypeMultitouchConstant,
    // ----
    OATouchProcessingTypeCount
} OATouchProcessingType;

@interface OptiActorViewController : UIViewController <UITextFieldDelegate, UIAccelerometerDelegate> {
    IBOutlet OAInfoViewController *infoViewController;
    IBOutlet OACGLXController *cglxController;
    IBOutlet OATouchesView *touchesView;
    
    UIButton *leftButton;
    UIButton *middleButton;
    UIButton *rightButton;
    
    UIPopoverController *popoverController;
    UITextField *hiddenField;
    
    OATouchProcessingType touchProcessingType;
}

@property (nonatomic, assign) IBOutlet OAInfoViewController *infoViewController;
@property (nonatomic, retain) IBOutlet OACGLXController *cglxController;
@property (nonatomic, retain) IBOutlet OATouchesView *touchesView;
@property (nonatomic, retain) IBOutlet UIButton *leftButton;
@property (nonatomic, retain) IBOutlet UIButton *middleButton;
@property (nonatomic, retain) IBOutlet UIButton *rightButton;
@property OATouchProcessingType touchProcessingType;

- (IBAction)showKeyboard:(id)sender;
- (void)keyboardWillMove:(NSNotification *)note;

- (IBAction)showInfo:(id)sender;

- (void)showMouseButtons:(BOOL)show;
- (IBAction)mouseButtonDown:(id)sender;
- (IBAction)mouseButtonUp:(id)sender;

- (void)enableAccelerometer:(BOOL)enable;

@end

