//
//  LogOutViewController.h
//  ClassBeacon
//
//  Created by Luke Alexander Harris on 04/03/2015.
//  Copyright (c) 2015 lah37kentacuk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface LogOutViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

- (IBAction)logOutButtonTapAction:(id)sender;


@end