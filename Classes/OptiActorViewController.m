//
//  OptiActorViewController.m
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright John Kooker 2010. All rights reserved.
//

#import "OptiActorViewController.h"
#import "OptiActorAppDelegate.h"
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
    
    OptiActorAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.navController = [[[UINavigationController alloc] initWithRootViewController:infoViewController] autorelease];
    
    popoverController = [[UIPopoverController alloc] initWithContentViewController:appDelegate.navController];
    popoverController.popoverContentSize = CGSizeMake(320, 500);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillMove:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillMove:) name:UIKeyboardWillHideNotification object:nil];
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
    [popoverController release];
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

// TODO: fix this copy/paste hack
enum cs_hci_type_E
{
	CS_HCI_UNDEF		= 0,
	CS_HCI_X_SERV		= 1,
	CS_HCI_SPM_SERV		= 2,
	CS_HCI_JOY_SERV		= 3,
	CS_HCI_ASC_SERV		= 4,
	CS_HCI_MT_SERV		= 5,
	CS_HCI_CUST_SERV	= 6
};

- (void)setTouchProcessingType:(OATouchProcessingType)type {
    switch (type) {
        case OATouchProcessingTypeTrackpad:
            [self showMouseButtons:YES];
            touchesView.sendRawMultitouch = NO;
            touchesView.isInTrackpadMode = YES;
            [cglxController setServerType:CS_HCI_X_SERV];
            break;
        case OATouchProcessingTypeMouse:
            [self showMouseButtons:YES];
            touchesView.sendRawMultitouch = NO;
            touchesView.isInTrackpadMode = NO;
            [cglxController setServerType:CS_HCI_X_SERV];
            break;
        case OATouchProcessingTypeMultitouchEvent:
            [self showMouseButtons:NO];
            touchesView.sendRawMultitouch = YES;
            touchesView.isInTrackpadMode = NO;
            cglxController.sendAtConstantRate = NO;
            [cglxController setServerType:CS_HCI_MT_SERV];
            break;
        case OATouchProcessingTypeMultitouchConstant:
            [self showMouseButtons:NO];
            touchesView.sendRawMultitouch = YES;
            touchesView.isInTrackpadMode = NO;
            cglxController.sendAtConstantRate = YES;
            [cglxController setServerType:CS_HCI_MT_SERV];
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

- (void)keyboardWillMove:(NSNotification *)note {
    NSDictionary *info = [note userInfo];
    CGRect kbBeginFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect kbEndFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbBeginFrame = [self.view convertRect:kbBeginFrame fromView:nil];
    kbEndFrame = [self.view convertRect:kbEndFrame fromView:nil];
    
    double animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
        
    [UIView beginAnimations:@"OAKeyboardAnimation" context:nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];

    CGFloat kbYDelta = kbEndFrame.origin.y - kbBeginFrame.origin.y;
    CGFloat x = leftButton.center.x;

    leftButton.center = CGPointMake(x, leftButton.center.y + kbYDelta);
    middleButton.center = CGPointMake(x, middleButton.center.y + kbYDelta);
    rightButton.center = CGPointMake(x, rightButton.center.y + kbYDelta);
    
    [UIView commitAnimations];
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
