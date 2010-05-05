//
//  OptiActorViewController.m
//  OptiActor
//
//  Created by John Kooker on 4/20/10.
//  Copyright John Kooker 2010. All rights reserved.
//

#import "OptiActorViewController.h"

@implementation OptiActorViewController

@synthesize infoViewController;
@synthesize cglxController;

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
    popoverController.popoverContentSize = CGSizeMake(320, 500);
}

- (void)enableAccelerometer:(BOOL)enable {
    if (enable) {
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.04];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    } else {
        [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
    }
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

#pragma mark Accelerometer handling

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    [cglxController updateAcceleration:acceleration];
}

@end
