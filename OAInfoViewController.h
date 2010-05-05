//
//  OAInfoViewController.h
//  OptiActor
//
//  Created by John Kooker on 5/4/10.
//  Copyright 2010 John Kooker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptiActorViewController.h"

@interface OAInfoViewController : UITableViewController {
    IBOutlet OptiActorViewController *mainViewController;
    
    UISwitch *accelerometerSwitch;
}

@property (retain, nonatomic) IBOutlet OptiActorViewController *mainViewController;

- (IBAction)switchAccelerometer:(id)sender;
- (NSString *)getIPAddress;

@end
