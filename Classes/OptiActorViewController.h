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
        
    UIPopoverController *popoverController;
    UITextField *hiddenField;
    
    OATouchProcessingType touchProcessingType;
}

@property (nonatomic, assign) IBOutlet OAInfoViewController *infoViewController;
@property (nonatomic, retain) IBOutlet OACGLXController *cglxController;
@property (nonatomic, retain) IBOutlet OATouchesView *touchesView;
@property OATouchProcessingType touchProcessingType;

- (IBAction)showKeyboard:(id)sender;
- (IBAction)showInfo:(id)sender;

- (void)showMouseButtons:(BOOL)show;

- (void)enableAccelerometer:(BOOL)enable;

@end

