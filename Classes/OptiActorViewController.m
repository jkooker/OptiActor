//
//  OptiActorViewController.m
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright John Kooker 2010. All rights reserved.
//

#import "OptiActorViewController.h"
#import "OAInfoViewController.h"
#import "cglXnet/cglXKeyCodeMap.h"

@implementation OptiActorViewController

@synthesize infoViewController;
@synthesize cglxController;
@synthesize touchesView;
@synthesize leftButton;
@synthesize middleButton;
@synthesize rightButton;
@dynamic touchProcessingType;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    hiddenField = [[UITextField alloc] initWithFrame:CGRectZero];
    hiddenField.delegate = self;
    hiddenField.text = @"0"; // throw in a character so the delete key will work!
    [self.view addSubview:hiddenField];
    
    popoverController = [[UIPopoverController alloc] initWithContentViewController:infoViewController];
    popoverController.popoverContentSize = CGSizeMake(320, 400);
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [hiddenField release];
    [super dealloc];
}

#pragma mark IBActions
- (IBAction)showKeyboard:(id)sender {
    // take first responder
    [hiddenField becomeFirstResponder];
}

- (IBAction)showInfo:(id)sender {
    // show popover with IP and Port info
    [popoverController presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //NSLog(@"incoming text: %@", string);
    [cglxController keyPress:string];
    return NO; // don't actually change the text field contents
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [hiddenField resignFirstResponder];
}

#pragma mark Other

- (OATouchProcessingType)touchProcessingType {
    return touchProcessingType;
}

- (void)setTouchProcessingType:(OATouchProcessingType)type {
    switch (type) {
        case OATouchProcessingTypeMouse:
            [self showMouseButtons:YES];
            touchesView.sendRawMultitouch = NO;
            break;
        case OATouchProcessingTypeMultitouchEvent:
            [self showMouseButtons:NO];
            touchesView.sendRawMultitouch = YES;
            cglxController.sendAtConstantRate = NO;
            break;
        case OATouchProcessingTypeMultitouchConstant:
            [self showMouseButtons:NO];
            touchesView.sendRawMultitouch = YES;
            cglxController.sendAtConstantRate = YES;
            break;
        default:
            break;
    }

    touchProcessingType = type;
}

- (void)showMouseButtons:(BOOL)show {
    if (show) {
        leftButton.hidden = NO;
        middleButton.hidden = NO;
        rightButton.hidden = NO;
    } else {
        leftButton.hidden = YES;
        middleButton.hidden = YES;
        rightButton.hidden = YES;
    }
}

- (IBAction)mouseButtonDown:(id)sender {
    if (sender == leftButton) {
        cglxController.mouseButtonState = CGLX_LEFT_BUTTON;
    } else if (sender == middleButton) {
        cglxController.mouseButtonState = CGLX_MIDDLE_BUTTON;
    } else if (sender == rightButton) {
        cglxController.mouseButtonState = CGLX_RIGHT_BUTTON;
    }
}

- (IBAction)mouseButtonUp:(id)sender {
    cglxController.mouseButtonState = 0;
}

- (void)enableAccelerometer:(BOOL)enable {
    if (enable) {
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.04];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    } else {
        [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    }
}

#pragma mark Accelerometer handling

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    [cglxController updateAcceleration:acceleration];
}

@end
