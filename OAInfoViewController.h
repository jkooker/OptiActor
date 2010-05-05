//
//  OAInfoViewController.h
//  OptiActor
//
//  Created by John Kooker on 5/4/10.
//  Copyright 2010 John Kooker. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OptiActorViewController;

@interface OAInfoViewController : UITableViewController {
    IBOutlet OptiActorViewController *mainViewController;
    
    UISwitch *accelerometerSwitch;
}

@property (retain, nonatomic) IBOutlet OptiActorViewController *mainViewController;

@end
