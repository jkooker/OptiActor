//
//  OAInfoViewController.m
//  OptiActor
//
//  Created by John Kooker on 5/4/10.
//  Copyright 2010 John Kooker. All rights reserved.
//

#import "OAInfoViewController.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation OAInfoViewController
@synthesize mainViewController;

#pragma mark -
#pragma mark View lifecycle

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
*/

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}


#pragma mark -
#pragma mark Table view data source

enum OASection {
    OASectionNetwork,
    OASectionTouchInterface,
    OASectionOther,
    // ---
    OASectionCount
};

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return OASectionCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *retVal = @"";
    
    switch (section) {
        case OASectionNetwork:
            retVal = @"Network";
            break;
        case OASectionTouchInterface:
            retVal = @"Touch Interface";
            break;
        case OASectionOther:
            retVal = @"Other";
            break;
        default:
            break;
    }
    
    return retVal;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger retVal = 0;
    
    switch (section) {
        case OASectionNetwork:
            retVal = 2;
            break;
        case OASectionTouchInterface:
            retVal = OATouchProcessingTypeCount;
            break;
        case OASectionOther:
            retVal = 1;
            break;
        default:
            break;
    }
    
    return retVal;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell to default properties
    cell.textLabel.text = @"";
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case OASectionNetwork:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"IP";
                    cell.detailTextLabel.text = [self getIPAddress];
                    cell.detailTextLabel.textColor = [UIColor grayColor];
                    break;
                case 1:
                    cell.textLabel.text = @"Port";
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", mainViewController.cglxController.serverPort];
                    break;
                default:
                    break;
            }
            break;
        case OASectionTouchInterface:
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            switch (indexPath.row) {
                case OATouchProcessingTypeMouse:
                    cell.textLabel.text = @"Mouse";
                    if (mainViewController.touchProcessingType == OATouchProcessingTypeMouse) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    break;
                case OATouchProcessingTypeMultitouchEvent:
                    cell.textLabel.text = @"Multitouch (Event Driven)";
                    if (mainViewController.touchProcessingType == OATouchProcessingTypeMultitouchEvent) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    break;
                case OATouchProcessingTypeMultitouchConstant:
                    cell.textLabel.text = @"Multitouch (Constant Rate)";
                    cell.detailTextLabel.text = @"";
                    if (mainViewController.touchProcessingType == OATouchProcessingTypeMultitouchConstant) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    break;
                default:
                    break;
            }
            break;
        case OASectionOther:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Accelerometer";
                    cell.accessoryView = accelerometerSwitch;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == OASectionTouchInterface) {
        [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:mainViewController.touchProcessingType inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
        
        mainViewController.touchProcessingType = indexPath.row;
        
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark -
#pragma mark Memory management

- (void)awakeFromNib {
    accelerometerSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [accelerometerSwitch addTarget:self action:@selector(switchAccelerometer:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [accelerometerSwitch release];
    [super dealloc];
}

#pragma mark -
#pragma mark Other

- (IBAction)switchAccelerometer:(id)sender {
    [mainViewController enableAccelerometer:accelerometerSwitch.on];
}

- (NSString *)getIPAddress {
// TODO: use CFHost instead. http://code.google.com/p/amber-framework/source/browse/trunk/CoreNetworking/AFNetworkServer.m?spec=svn362&r=362
  NSString *address = @"error";
  struct ifaddrs *interfaces = NULL;
  struct ifaddrs *temp_addr = NULL;
  int success = 0;

  // retrieve the current interfaces - returns 0 on success
  success = getifaddrs(&interfaces);
  if (success == 0)
  {
    // Loop through linked list of interfaces
    temp_addr = interfaces;
    while(temp_addr != NULL)
    {
      if(temp_addr->ifa_addr->sa_family == AF_INET)
      {
        // Check if interface is en0 which is the wifi connection on the iPhone
        if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
        {
          // Get NSString from C String
          address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
        }
      }

      temp_addr = temp_addr->ifa_next;
    }
  }

  // Free memory
  freeifaddrs(interfaces);

  return address;
}

@end

